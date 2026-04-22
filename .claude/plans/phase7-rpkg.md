# Phase 7 — daggleR Package Implementation Spec

Target repo: [cynkra/daggleR](https://github.com/cynkra/daggleR) at `/Users/david/projects/rdag/daggle-R`

Current state: 25 exported functions, 3 source files (`R/in-step.R`, `R/api.R`, `R/utils.R`), version 0.1.1.

This spec adds 12 new exports (6 in-step helpers + 6 API wrappers) to reach version 0.2.0.

---

## Step 1: Add 6 new in-step helpers to R/in-step.R

Append these functions to the end of `R/in-step.R`. Follow the exact style of the existing `output()` function: roxygen2 docs, `@export`, `@examples` with `\dontrun{}`, use `cat(sprintf(...))` for marker emission, validate inputs, return invisibly.

### summary_md(text)
```r
#' Emit a markdown summary for the current step
#'
#' Write a markdown summary to stdout that daggle captures and stores
#' as a per-step summary file. Viewable via the API.
#'
#' @param text Character string. Markdown-formatted summary text.
#'
#' @return `text`, invisibly.
#' @export
#' @examples
#' \dontrun{
#' summary_md("## Results\n- 1542 rows processed\n- 3 outliers found")
#' }
summary_md <- function(text) {
  cat(sprintf("::daggle-summary format=markdown::%s\n", as.character(text)))
  invisible(text)
}
```

### meta_numeric(name, value)
```r
#' Emit a numeric metadata value
#'
#' Emit a typed numeric metric that daggle stores per-step. Numeric metadata
#' can be tracked across runs for trend analysis.
#'
#' @param name Character string. Metric name. Must match `[a-zA-Z_][a-zA-Z0-9_]*`.
#' @param value Numeric. Metric value.
#'
#' @return `value`, invisibly.
#' @export
#' @examples
#' \dontrun{
#' meta_numeric("row_count", nrow(df))
#' meta_numeric("accuracy", 0.95)
#' }
meta_numeric <- function(name, value) {
  if (!grepl("^[a-zA-Z_][a-zA-Z0-9_]*$", name)) {
    stop("Invalid metadata name '", name, "'. Must match [a-zA-Z_][a-zA-Z0-9_]*.", call. = FALSE)
  }
  cat(sprintf("::daggle-meta type=numeric name=%s::%s\n", name, as.character(value)))
  invisible(value)
}
```

### meta_text(name, value)
```r
#' Emit a text metadata value
#'
#' @param name Character string. Metadata key. Must match `[a-zA-Z_][a-zA-Z0-9_]*`.
#' @param value Character string. Metadata value.
#'
#' @return `value`, invisibly.
#' @export
#' @examples
#' \dontrun{
#' meta_text("model_type", "linear regression")
#' }
meta_text <- function(name, value) {
  if (!grepl("^[a-zA-Z_][a-zA-Z0-9_]*$", name)) {
    stop("Invalid metadata name '", name, "'. Must match [a-zA-Z_][a-zA-Z0-9_]*.", call. = FALSE)
  }
  cat(sprintf("::daggle-meta type=text name=%s::%s\n", name, as.character(value)))
  invisible(value)
}
```

### meta_table(name, df)
```r
#' Emit a table metadata value
#'
#' Serialize a data.frame to JSON and emit as table metadata. Requires the
#' jsonlite package (Suggests dependency).
#'
#' @param name Character string. Table name. Must match `[a-zA-Z_][a-zA-Z0-9_]*`.
#' @param df A data.frame to serialize.
#'
#' @return `df`, invisibly.
#' @export
#' @examples
#' \dontrun{
#' meta_table("top5", head(results, 5))
#' }
meta_table <- function(name, df) {
  if (!grepl("^[a-zA-Z_][a-zA-Z0-9_]*$", name)) {
    stop("Invalid metadata name '", name, "'. Must match [a-zA-Z_][a-zA-Z0-9_]*.", call. = FALSE)
  }
  if (!requireNamespace("jsonlite", quietly = TRUE)) {
    stop("The jsonlite package is required for meta_table(). Install with: install.packages('jsonlite')", call. = FALSE)
  }
  json <- jsonlite::toJSON(df, auto_unbox = TRUE)
  cat(sprintf("::daggle-meta type=table name=%s::%s\n", name, json))
  invisible(df)
}
```

### meta_image(name, path)
```r
#' Emit an image metadata reference
#'
#' Reference an image file (PNG, SVG, PDF) as step metadata. The file should
#' be a declared artifact in the step's YAML definition.
#'
#' @param name Character string. Image name. Must match `[a-zA-Z_][a-zA-Z0-9_]*`.
#' @param path Character string. Path to the image file.
#'
#' @return `path`, invisibly.
#' @export
#' @examples
#' \dontrun{
#' meta_image("residuals_plot", "output/residuals.png")
#' }
meta_image <- function(name, path) {
  if (!grepl("^[a-zA-Z_][a-zA-Z0-9_]*$", name)) {
    stop("Invalid metadata name '", name, "'. Must match [a-zA-Z_][a-zA-Z0-9_]*.", call. = FALSE)
  }
  cat(sprintf("::daggle-meta type=image name=%s::%s\n", name, as.character(path)))
  invisible(path)
}
```

### validation(name, status, message)
```r
#' Emit a validation result
#'
#' Emit a structured validation result that daggle captures and stores
#' per-step. Validation failures may cause the step to fail depending on
#' the step's `error_on` setting.
#'
#' @param name Character string. Validation check name.
#' @param status Character string. One of `"pass"`, `"warn"`, `"fail"`.
#' @param message Character string. Human-readable result description.
#'
#' @return `status`, invisibly.
#' @export
#' @examples
#' \dontrun{
#' validation("row_count", "pass", "Expected > 0, got 1542")
#' validation("missing_pct", "warn", "12% missing (threshold: 20%)")
#' validation("schema", "fail", "Column 'date' expected date, got character")
#' }
validation <- function(name, status = c("pass", "warn", "fail"), message = "") {
  status <- match.arg(status)
  if (!grepl("^[a-zA-Z_][a-zA-Z0-9_]*$", name)) {
    stop("Invalid validation name '", name, "'. Must match [a-zA-Z_][a-zA-Z0-9_]*.", call. = FALSE)
  }
  cat(sprintf("::daggle-validation status=%s name=%s::%s\n", status, name, as.character(message)))
  invisible(status)
}
```

---

## Step 2: Add 6 new API wrappers to R/api.R

Append these functions to the end of `R/api.R`. Follow the exact pattern of existing functions: use `resolve_base_url()`, pipe with `|>`, use `httr2::req_url_path_append()` for path construction. Collection endpoints use `simplifyVector = TRUE` to return data.frames; single-object endpoints return lists.

### list_artifacts()
```r
#' List artifacts for a run
#'
#' @param name Character string. Name of the DAG.
#' @param run_id Character string. Run ID, or `"latest"` for the most recent.
#' @inheritParams list_dags
#'
#' @return A data.frame with columns: `step_id`, `name`, `path`, `abs_path`,
#'   `hash`, `size`, `format`.
#' @export
list_artifacts <- function(name, run_id = "latest", base_url = NULL) {
  url <- resolve_base_url(base_url)
  httr2::request(url) |>
    httr2::req_url_path_append(
      "api", "v1", "dags", name, "runs", run_id, "artifacts"
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}
```

### plan()
```r
#' Show execution plan with cache status
#'
#' Returns which steps would run vs skip based on the current cache state.
#'
#' @param name Character string. Name of the DAG.
#' @inheritParams list_dags
#'
#' @return A data.frame with columns: `step_id`, `status`, `reason`.
#' @export
plan <- function(name, base_url = NULL) {
  url <- resolve_base_url(base_url)
  httr2::request(url) |>
    httr2::req_url_path_append("api", "v1", "dags", name, "plan") |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}
```

### get_summaries()
```r
#' Get step summaries for a run
#'
#' @param name Character string. Name of the DAG.
#' @param run_id Character string. Run ID, or `"latest"` for the most recent.
#' @inheritParams list_dags
#'
#' @return A data.frame with columns: `step_id`, `format`, `content`.
#' @export
get_summaries <- function(name, run_id = "latest", base_url = NULL) {
  url <- resolve_base_url(base_url)
  httr2::request(url) |>
    httr2::req_url_path_append(
      "api", "v1", "dags", name, "runs", run_id, "summaries"
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}
```

### get_metadata()
```r
#' Get step metadata for a run
#'
#' @param name Character string. Name of the DAG.
#' @param run_id Character string. Run ID, or `"latest"` for the most recent.
#' @inheritParams list_dags
#'
#' @return A data.frame with columns: `step_id`, `name`, `type`, `value`.
#' @export
get_metadata <- function(name, run_id = "latest", base_url = NULL) {
  url <- resolve_base_url(base_url)
  httr2::request(url) |>
    httr2::req_url_path_append(
      "api", "v1", "dags", name, "runs", run_id, "metadata"
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}
```

### get_validations()
```r
#' Get validation results for a run
#'
#' @param name Character string. Name of the DAG.
#' @param run_id Character string. Run ID, or `"latest"` for the most recent.
#' @inheritParams list_dags
#'
#' @return A data.frame with columns: `step_id`, `name`, `status`, `message`.
#' @export
get_validations <- function(name, run_id = "latest", base_url = NULL) {
  url <- resolve_base_url(base_url)
  httr2::request(url) |>
    httr2::req_url_path_append(
      "api", "v1", "dags", name, "runs", run_id, "validations"
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}
```

### compare_runs()
```r
#' Compare two runs
#'
#' @param name Character string. Name of the DAG.
#' @param run1 Character string. First run ID.
#' @param run2 Character string. Second run ID.
#' @inheritParams list_dags
#'
#' @return A list with elements: `outputs_diff` (data.frame with columns
#'   `step_id`, `key`, `value1`, `value2`), `duration_diff` (list with
#'   `run1_seconds`, `run2_seconds`, `diff_seconds`), `meta_diff` (list with
#'   `dag_hash1`, `dag_hash2`, `changed`).
#' @export
compare_runs <- function(name, run1, run2, base_url = NULL) {
  url <- resolve_base_url(base_url)
  httr2::request(url) |>
    httr2::req_url_path_append(
      "api", "v1", "dags", name, "runs", "compare"
    ) |>
    httr2::req_url_query(run1 = run1, run2 = run2) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}
```

---

## Step 3: Update DESCRIPTION

- Bump `Version:` from `0.1.1` to `0.2.0`
- Add `jsonlite` to `Suggests:` (needed by `meta_table()`)

---

## Step 4: Update NAMESPACE

Run `devtools::document()` to regenerate NAMESPACE from roxygen2 tags. The 12 new `@export` tags will produce:

```
export(compare_runs)
export(get_metadata)
export(get_summaries)
export(get_validations)
export(list_artifacts)
export(meta_image)
export(meta_numeric)
export(meta_table)
export(meta_text)
export(plan)
export(summary_md)
export(validation)
```

---

## Step 5: Add tests

### tests/testthat/test-in-step-phase7.R

Use `capture.output()` to verify marker format. Follow the pattern in existing `test-in-step.R`.

```r
test_that("summary_md emits correct marker", {
  out <- capture.output(summary_md("# Hello"))
  expect_match(out, "^::daggle-summary format=markdown::# Hello$")
})

test_that("meta_numeric emits correct marker", {
  out <- capture.output(meta_numeric("row_count", 42))
  expect_match(out, "^::daggle-meta type=numeric name=row_count::42$")
})

test_that("meta_text emits correct marker", {
  out <- capture.output(meta_text("model", "lm"))
  expect_match(out, "^::daggle-meta type=text name=model::lm$")
})

test_that("meta_table emits JSON", {
  skip_if_not_installed("jsonlite")
  df <- data.frame(x = 1:2, y = c("a", "b"))
  out <- capture.output(meta_table("top", df))
  expect_match(out, "^::daggle-meta type=table name=top::")
  # Verify JSON is parseable
  json_part <- sub("^::daggle-meta type=table name=top::", "", out)
  parsed <- jsonlite::fromJSON(json_part)
  expect_equal(nrow(parsed), 2)
})

test_that("meta_image emits correct marker", {
  out <- capture.output(meta_image("plot", "output/fig.png"))
  expect_match(out, "^::daggle-meta type=image name=plot::output/fig.png$")
})

test_that("validation emits correct marker", {
  out <- capture.output(validation("schema", "pass", "All columns valid"))
  expect_match(out, "^::daggle-validation status=pass name=schema::All columns valid$")
})

test_that("validation matches status argument", {
  expect_error(validation("x", "invalid"), "should be one of")
})

test_that("meta_numeric rejects invalid name", {
  expect_error(meta_numeric("123bad", 1), "Invalid metadata name")
})

test_that("validation rejects invalid name", {
  expect_error(validation("123bad", "pass", "msg"), "Invalid validation name")
})

test_that("summary_md returns invisibly", {
  expect_invisible(summary_md("test"))
})
```

### tests/testthat/test-api-phase7.R

Use `httptest2::with_mock_dir()` following the pattern in existing `test-api.R`. Create mock response directories under `tests/testthat/` with the expected JSON responses.

Test each function returns the correct type (data.frame or list) with expected column/element names. Use `base_url = "http://127.0.0.1:8787"` for mock consistency with existing tests.

```r
with_mock_dir("phase7-api", {
  test_that("list_artifacts returns data.frame", {
    res <- list_artifacts("test-dag", "latest", base_url = "http://127.0.0.1:8787")
    expect_s3_class(res, "data.frame")
    expect_true(all(c("step_id", "name", "path", "hash", "size") %in% names(res)))
  })

  test_that("plan returns data.frame", {
    res <- plan("test-dag", base_url = "http://127.0.0.1:8787")
    expect_s3_class(res, "data.frame")
    expect_true(all(c("step_id", "status", "reason") %in% names(res)))
  })

  test_that("get_summaries returns data.frame", {
    res <- get_summaries("test-dag", "latest", base_url = "http://127.0.0.1:8787")
    expect_s3_class(res, "data.frame")
    expect_true(all(c("step_id", "format", "content") %in% names(res)))
  })

  test_that("get_metadata returns data.frame", {
    res <- get_metadata("test-dag", "latest", base_url = "http://127.0.0.1:8787")
    expect_s3_class(res, "data.frame")
    expect_true(all(c("step_id", "name", "type", "value") %in% names(res)))
  })

  test_that("get_validations returns data.frame", {
    res <- get_validations("test-dag", "latest", base_url = "http://127.0.0.1:8787")
    expect_s3_class(res, "data.frame")
    expect_true(all(c("step_id", "name", "status", "message") %in% names(res)))
  })

  test_that("compare_runs returns list", {
    res <- compare_runs("test-dag", "run1", "run2", base_url = "http://127.0.0.1:8787")
    expect_type(res, "list")
    expect_true(all(c("outputs_diff", "duration_diff", "meta_diff") %in% names(res)))
  })
})
```

You need to create the mock response directories. The directory structure must match the `httptest2` convention: `tests/testthat/phase7-api/` with subdirs mirroring the URL path, containing JSON response files. Create them by running the tests against a live daggle server, or manually:

```
tests/testthat/phase7-api/
  api/v1/dags/test-dag/
    plan.json
    runs/latest/
      artifacts.json
      summaries.json
      metadata.json
      validations.json
    runs/
      compare-b31680.json  (httptest2 hashes query params)
```

Each JSON file contains a sample response matching the API spec. See existing mock dirs in `tests/testthat/` for the exact format.

---

## Step 6: Update _pkgdown.yml

Replace the existing reference section with:

```yaml
reference:
  - title: In-step helpers
    contents:
      - output
      - run_id
      - dag_name
      - run_dir
      - get_matrix
      - get_output
      - summary_md
      - meta_numeric
      - meta_text
      - meta_table
      - meta_image
      - validation
  - title: DAG management
    contents:
      - list_dags
      - get_dag
      - plan
  - title: Run management
    contents:
      - trigger
      - list_runs
      - get_run
      - get_outputs
      - get_step_log
      - cancel_run
      - compare_runs
      - list_artifacts
      - get_summaries
      - get_metadata
      - get_validations
  - title: Approval gates
    contents:
      - approve
      - reject
  - title: Project management
    contents:
      - list_projects
      - register_project
      - unregister_project
  - title: System
    contents:
      - health
      - cleanup
      - cli_version
```

---

## Step 7: Update README.md

Update the function count and add examples for the new functions. The README currently lists 3 categories with counts. Update to:

- In-step helpers: 12 functions (was 6)
- API wrappers: 23 functions (was 17)
- Total exports: 37 (was 25)

Add a brief section mentioning the new Phase 7 capabilities (summaries, metadata, validations, artifacts, plan, compare).

---

## Verification

After all changes:

```r
devtools::document()   # regenerate NAMESPACE and man/ pages
devtools::check()      # full R CMD check
devtools::test()       # run testthat
```

Expected: 0 errors, 0 warnings, 0 notes (excluding any pre-existing notes).

---

## Summary

| File | Action |
|------|--------|
| `R/in-step.R` | Append 6 new functions |
| `R/api.R` | Append 6 new functions |
| `DESCRIPTION` | Bump version, add jsonlite to Suggests |
| `NAMESPACE` | Regenerate via devtools::document() |
| `_pkgdown.yml` | Update reference section |
| `README.md` | Update counts and examples |
| `tests/testthat/test-in-step-phase7.R` | New test file (10 tests) |
| `tests/testthat/test-api-phase7.R` | New test file (6 tests) |
| `tests/testthat/phase7-api/` | Mock response directory |
| `man/` | Regenerated by devtools::document() |
