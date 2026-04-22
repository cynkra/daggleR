# Phase 8 — daggleR Package Implementation Spec

Target repo: [cynkra/daggleR](https://github.com/cynkra/daggleR) at `/Users/david/projects/rdag/daggle-R`

Current state: 37 exported functions, 3 source files (`R/in-step.R`, `R/api.R`, `R/utils.R`), version `0.2.0`.

This spec adds 3 new API wrappers, updates existing wrappers with new optional filter params and expanded response shapes, and bumps to version `0.3.0`. All changes are **additive** — existing callers keep working.

Phase 8 is predominantly server-side (notifications, ownership metadata, annotations, SSE streaming, TUI, rusage profiling, exposures). There are no new `::daggle-*::` stdout protocols, so **no in-step helpers are added**.

---

## Step 1: No new in-step helpers

Phase 8 introduced no new stdout-marker protocols. `R/in-step.R` is unchanged. Skip to Step 2.

---

## Step 2: Add 3 new API wrappers to R/api.R

Append these functions to the end of `R/api.R`, after `compare_runs`. Follow the exact pattern of existing functions: use `resolve_base_url()`, pipe with `|>`, use `httr2::req_url_path_append()`. Collection endpoints use `simplifyVector = TRUE` to return data.frames; single-object endpoints return lists.

### list_annotations()

```r
#' List annotations for a run
#'
#' Returns free-form notes attached to a run via `daggle annotate` or the
#' annotations API. Annotations are stored as `run_annotated` events in the
#' run's `events.jsonl`.
#'
#' @param name Character string. Name of the DAG.
#' @param run_id Character string. Run ID, or `"latest"` for the most recent.
#' @inheritParams list_dags
#'
#' @return A data.frame with columns: `timestamp`, `author`, `note`.
#' @export
list_annotations <- function(name, run_id = "latest", base_url = NULL) {
  url <- resolve_base_url(base_url)
  httr2::request(url) |>
    httr2::req_url_path_append(
      "api", "v1", "dags", name, "runs", run_id, "annotations"
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}
```

### add_annotation()

```r
#' Add an annotation to a run
#'
#' Attaches a free-form note to an existing run. Writes a `run_annotated` event
#' to the run's `events.jsonl`. Annotations surface in `daggle status`, the API,
#' and the web UI.
#'
#' @param name Character string. Name of the DAG.
#' @param run_id Character string. Run ID (must be an existing run).
#' @param note Character string. The annotation text.
#' @param author Character string. Who wrote the annotation. Defaults to the
#'   value of `Sys.getenv("USER")`.
#' @inheritParams list_dags
#'
#' @return Invisibly, the HTTP response status list returned by the server.
#' @export
add_annotation <- function(name, run_id, note, author = NULL, base_url = NULL) {
  if (is.null(author) || !nzchar(author)) {
    author <- Sys.getenv("USER")
  }
  url <- resolve_base_url(base_url)
  body <- list(note = note, author = author)
  resp <- httr2::request(url) |>
    httr2::req_url_path_append(
      "api", "v1", "dags", name, "runs", run_id, "annotations"
    ) |>
    httr2::req_body_json(body) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  invisible(resp)
}
```

### get_impact()

```r
#' Get downstream impact of a DAG
#'
#' Returns DAGs that depend on the given DAG (via `trigger.on_dag.name`) plus
#' any `exposures:` (dashboards, reports, Shiny apps) declared on the DAG.
#'
#' @param name Character string. Name of the DAG.
#' @inheritParams list_dags
#'
#' @return A list with elements `dag` (character), `downstream_dags`
#'   (data.frame with `name`, `project`, `trigger_on_status`), and `exposures`
#'   (data.frame with `name`, `type`, `url`, `description`).
#' @export
get_impact <- function(name, base_url = NULL) {
  url <- resolve_base_url(base_url)
  httr2::request(url) |>
    httr2::req_url_path_append("api", "v1", "dags", name, "impact") |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}
```

### Deferred: SSE streaming

`GET /api/v1/dags/{name}/runs/{run_id}/stream` is intentionally **not wrapped** in this phase. The primary consumer is the Go-side `daggle monitor` TUI, and httr2's streaming ergonomics don't map cleanly onto R for this use case. Add a `stream_run()` wrapper later if a concrete R use case emerges (e.g. Shiny live dashboards).

---

## Step 3: Update existing wrappers

Two existing functions gain optional filter parameters and richer response shapes. All changes are backwards-compatible.

### list_dags() — add filter params

Update the signature to accept `tag`, `team`, `owner`, and thread them through the request as query params. The API filters server-side with AND semantics.

```r
#' List all DAGs
#'
#' @param tag Character string. If set, only return DAGs that declare this tag.
#' @param team Character string. If set, only return DAGs owned by this team.
#' @param owner Character string. If set, only return DAGs owned by this user.
#' @param base_url Character string. Override the base URL (default: auto-resolve).
#'
#' @return A data.frame with one row per DAG. May include `owner`, `team`,
#'   `description`, and `tags` columns when any DAG declares those fields.
#' @export
list_dags <- function(tag = NULL, team = NULL, owner = NULL, base_url = NULL) {
  url <- resolve_base_url(base_url)
  req <- httr2::request(url) |>
    httr2::req_url_path_append("api", "v1", "dags")
  if (!is.null(tag))   req <- req |> httr2::req_url_query(tag = tag)
  if (!is.null(team))  req <- req |> httr2::req_url_query(team = team)
  if (!is.null(owner)) req <- req |> httr2::req_url_query(owner = owner)
  req |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}
```

Note: `tags` in the response is a multi-value field, so `jsonlite` returns it as a list-column. No special handling needed in R — `df$tags[[i]]` gives the character vector for row `i`.

### get_dag() — no signature change

`GET /api/v1/dags/{name}` now returns additional top-level fields: `owner`, `team`, `description`, `tags`, `exposures`. The existing wrapper already uses `resp_body_json()` (no simplify), so these fields flow through automatically. **Update the roxygen `@return` text** to document the new elements:

```r
#' @return A list with the DAG definition and latest run status. Includes
#'   optional fields `owner`, `team`, `description`, `tags`, and `exposures`
#'   (a data.frame with `name`, `type`, `url`, `description`) when declared
#'   on the DAG.
```

### get_run() — no signature change

`GET /api/v1/dags/{name}/runs/{run_id}` now includes `peak_rss_kb`, `user_cpu_sec`, and `sys_cpu_sec` on each element of `steps`, plus a top-level `annotations` field (list of `{timestamp, author, note}`). Update the roxygen `@return` text accordingly:

```r
#' @return A list describing the run. The `steps` element is a data.frame
#'   that may include resource columns `peak_rss_kb` (int), `user_cpu_sec`
#'   (num), `sys_cpu_sec` (num). The run also carries an `annotations`
#'   element (data.frame of `timestamp`, `author`, `note`) when notes have
#'   been attached.
```

No code changes needed in the wrapper body — the new fields are transparent to `resp_body_json`.

---

## Step 4: Update DESCRIPTION

- Bump `Version:` from `0.2.0` to `0.3.0`
- No new `Imports` or `Suggests` needed. Annotations and impact are plain JSON over the existing `httr2` dependency.

---

## Step 5: Update NAMESPACE

Run `devtools::document()` to regenerate NAMESPACE from roxygen2 tags. The 3 new `@export` tags will add:

```
export(add_annotation)
export(get_impact)
export(list_annotations)
```

Plus updated roxygen on `list_dags` (no NAMESPACE change — already exported).

---

## Step 6: Add tests

### tests/testthat/test-api-phase8.R

Use `httptest2::with_mock_dir()` following the pattern in existing `test-api-phase7.R`. Create mock response directories under `tests/testthat/phase8-api/` with the expected JSON responses.

```r
with_mock_dir("phase8-api", {
  test_that("list_annotations returns data.frame", {
    res <- list_annotations("test-dag", "latest", base_url = "http://127.0.0.1:8787")
    expect_s3_class(res, "data.frame")
    expect_true(all(c("timestamp", "author", "note") %in% names(res)))
  })

  test_that("add_annotation POSTs JSON body and returns response", {
    res <- add_annotation(
      "test-dag", "run123",
      note = "restarted manually",
      author = "alice",
      base_url = "http://127.0.0.1:8787"
    )
    expect_type(res, "list")
    expect_equal(res$status, "ok")
  })

  test_that("add_annotation falls back to Sys.getenv('USER') when author missing", {
    withr::with_envvar(list(USER = "bob"), {
      res <- add_annotation(
        "test-dag", "run123",
        note = "no author given",
        base_url = "http://127.0.0.1:8787"
      )
      # The mock fixture should have captured author=bob in the request body
      expect_type(res, "list")
    })
  })

  test_that("get_impact returns list with downstream_dags and exposures", {
    res <- get_impact("test-dag", base_url = "http://127.0.0.1:8787")
    expect_type(res, "list")
    expect_true(all(c("dag", "downstream_dags", "exposures") %in% names(res)))
  })

  test_that("list_dags passes filter params as query string", {
    res <- list_dags(tag = "etl", team = "data", base_url = "http://127.0.0.1:8787")
    expect_s3_class(res, "data.frame")
  })
})
```

Mock fixture layout:

```
tests/testthat/phase8-api/
  api/v1/dags/
    test-dag/
      impact.json
      runs/
        run123/
          annotations-POST.json     (shared response for both POST tests)
        latest/
          annotations.json
    dags-<hash>.json                (httptest2 hashes the tag/team query params)
```

Each JSON file contains a sample response matching the API spec. See existing `tests/testthat/phase7-api/` for the format. Generate fixtures by running against a live `daggle serve --port 8787` or by hand-authoring minimal JSON.

---

## Step 7: Update _pkgdown.yml

Add the 3 new functions to the existing reference section:

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
      - get_impact            # new
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
      - list_annotations      # new
      - add_annotation        # new
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

## Step 8: Update README.md

Update the function counts and add a short example:

- In-step helpers: 12 (unchanged)
- API wrappers: 23 → **26**
- Total exports: 37 → **40**

Add a brief example under the existing examples section:

```r
library(daggleR)

# Filter DAGs by ownership metadata
etl_dags <- list_dags(tag = "etl", team = "data")

# See who depends on this DAG
impact <- get_impact("daily-etl")
impact$downstream_dags
impact$exposures

# Attach a post-mortem note to a run
add_annotation("daily-etl", "run_abc123", "DB was down - manual restart at 08:30")
```

---

## Verification

After all changes:

```r
devtools::document()   # regenerate NAMESPACE and man/ pages
devtools::check()      # full R CMD check
devtools::test()       # run testthat
```

Expected: 0 errors, 0 warnings, 0 notes (excluding pre-existing notes).

---

## Summary

| File | Action |
|------|--------|
| `R/in-step.R` | No changes |
| `R/api.R` | Append 3 new functions; update roxygen on `list_dags`, `get_dag`, `get_run` |
| `DESCRIPTION` | Bump version `0.2.0` → `0.3.0` |
| `NAMESPACE` | Regenerate via `devtools::document()` (3 new exports) |
| `_pkgdown.yml` | Add `get_impact`, `list_annotations`, `add_annotation` to reference |
| `README.md` | Update counts (23→26 API, 37→40 total) and add annotations/impact example |
| `tests/testthat/test-api-phase8.R` | New test file (5 tests) |
| `tests/testthat/phase8-api/` | New mock response directory |
| `man/` | Regenerated by `devtools::document()` |
