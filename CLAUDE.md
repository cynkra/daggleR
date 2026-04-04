# daggle R package

Companion R package for [daggle](https://github.com/cynkra/daggle), a lightweight DAG scheduler for R.

## What this package does

Thin wrappers around the daggle protocol. Three categories:

1. **In-step helpers** — used inside R steps run by daggle. No network, no daggle binary needed.
2. **API wrappers** — talk to the daggle REST API (`daggle serve --port 8787`). Require `httr2`.
3. **Approval helpers** — approve/reject waiting steps via API.

## Package structure

Standard R package layout: `R/`, `man/`, `tests/testthat/`, `DESCRIPTION`, `NAMESPACE`.

Use `roxygen2` for docs. Use `testthat` for tests. Use `httr2` (not `httr`) for HTTP.

## Dependencies

- `httr2` — for API wrappers
- No other external dependencies. Base R only for in-step helpers.

## Functions to implement

### In-step helpers (no dependencies, base R only)

These run INSIDE an R step executed by daggle. They use stdout markers and env vars.

#### `daggle::output(name, value)`
Emit an output marker that daggle captures and passes to downstream steps.

```r
output <- function(name, value) {
  cat(sprintf("::daggle-output name=%s::%s\n", name, as.character(value)))
  invisible(value)
}
```

**Protocol:** Write `::daggle-output name=<key>::<value>\n` to stdout. One line, no newlines in value.
- Key regex: `[a-zA-Z_][a-zA-Z0-9_]*`
- Value: everything after `::` until newline, trimmed
- daggle strips these lines from terminal output but keeps them in log files

#### `daggle::run_id()`
```r
run_id <- function() Sys.getenv("DAGGLE_RUN_ID")
```

#### `daggle::dag_name()`
```r
dag_name <- function() Sys.getenv("DAGGLE_DAG_NAME")
```

#### `daggle::run_dir()`
```r
run_dir <- function() Sys.getenv("DAGGLE_RUN_DIR")
```

#### `daggle::get_output(step, key)`
Read an output from a completed upstream step.
```r
get_output <- function(step, key) {
  var_name <- paste0("DAGGLE_OUTPUT_",
    toupper(gsub("-", "_", step)), "_",
    toupper(key))
  Sys.getenv(var_name)
}
```

**Naming convention:** Step "fit-lda" emitting key "accuracy" becomes env var `DAGGLE_OUTPUT_FIT_LDA_ACCURACY`.
- Step ID: hyphens replaced with underscores, uppercased
- Key: uppercased
- Prefix: `DAGGLE_OUTPUT_`

### API wrappers (require httr2, require running daggle API)

All API wrappers should:
- Accept `base_url` parameter (default: `Sys.getenv("DAGGLE_API_URL", "http://127.0.0.1:8787")`)
- Return tibbles/data.frames where possible (list endpoints return flat arrays)
- Use `httr2::request() |> req_perform() |> resp_body_json()` pattern
- Error with clear message on HTTP errors

#### `daggle::list_dags(base_url = NULL)`
```
GET /api/v1/dags
```
Returns data.frame with columns: `name`, `steps`, `schedule`, `last_status`, `last_run`

#### `daggle::get_dag(name, base_url = NULL)`
```
GET /api/v1/dags/{name}
```
Returns list with: `name`, `steps`, `step_ids`, `schedule`, `workdir`, `r_version`, `last_status`, `last_run_id`, `last_run`

#### `daggle::trigger(name, params = list(), base_url = NULL)`
```
POST /api/v1/dags/{name}/run
Body: {"params": {"key": "value"}}
```
Returns list with: `run_id`, `status`

#### `daggle::list_runs(name, base_url = NULL)`
```
GET /api/v1/dags/{name}/runs
```
Returns data.frame with columns: `run_id`, `started`, `status`, `duration_seconds`, `dag_hash`

#### `daggle::get_run(name, run_id = "latest", base_url = NULL)`
```
GET /api/v1/dags/{name}/runs/{run_id}
```
"latest" is a valid run_id value that returns the most recent run.

Returns list with: `run_id`, `dag_name`, `status`, `started`, `ended`, `duration_seconds`, `dag_hash`, `r_version`, `platform`, `params` (named list), `steps` (data.frame with: `step_id`, `status`, `duration_seconds`, `attempts`, `error`, `message`)

#### `daggle::get_outputs(name, run_id = "latest", base_url = NULL)`
```
GET /api/v1/dags/{name}/runs/{run_id}/outputs
```
Returns data.frame with columns: `step_id`, `key`, `value`

This is intentionally flat (not nested) so it converts directly to a data.frame.

#### `daggle::get_step_log(name, run_id, step_id, base_url = NULL)`
```
GET /api/v1/dags/{name}/runs/{run_id}/steps/{step_id}/log
```
Returns list with: `step_id`, `stdout`, `stderr`

#### `daggle::cancel_run(name, run_id = "latest", base_url = NULL)`
```
POST /api/v1/dags/{name}/runs/{run_id}/cancel
```
Returns list with: `status`, `run_id`, `message`

#### `daggle::approve(name, run_id, step_id, base_url = NULL)`
```
POST /api/v1/dags/{name}/runs/{run_id}/steps/{step_id}/approve
```
Returns list with: `step_id`, `status`

#### `daggle::reject(name, run_id, step_id, base_url = NULL)`
```
POST /api/v1/dags/{name}/runs/{run_id}/steps/{step_id}/reject
```
Returns list with: `step_id`, `status`

#### `daggle::health(base_url = NULL)`
```
GET /api/v1/health
```
Returns list with: `status`, `version`, `uptime_seconds`

#### `daggle::cleanup(older_than = "30d", base_url = NULL)`
```
POST /api/v1/runs/cleanup
Body: {"older_than": "30d"}
```
Returns list with: `removed`, `freed_bytes`, `freed`

## API response format

All list endpoints return **flat JSON arrays** — no nesting. This means `jsonlite::fromJSON()` or `httr2::resp_body_json(simplifyVector = TRUE)` gives you a data.frame directly.

Example outputs response:
```json
[
  {"step_id": "extract", "key": "row_count", "value": "42"},
  {"step_id": "extract", "key": "file_path", "value": "/tmp/data.csv"}
]
```

Error responses are:
```json
{"error": "human-readable message"}
```
HTTP status codes: 200, 201, 400, 404, 409, 500.

## Base URL resolution

All API functions should resolve the base URL in this order:
1. Explicit `base_url` parameter
2. `DAGGLE_API_URL` environment variable
3. Default: `http://127.0.0.1:8787`

Helper:
```r
resolve_base_url <- function(base_url = NULL) {
  if (!is.null(base_url)) return(base_url)
  url <- Sys.getenv("DAGGLE_API_URL", "http://127.0.0.1:8787")
  sub("/+$", "", url)  # strip trailing slash
}
```

## Testing strategy

- In-step helpers: test with `withr::local_envvar()` to mock env vars, capture stdout with `capture.output()`
- API wrappers: use `httptest2` or `webmockr` to mock HTTP responses
- No real daggle instance needed for tests

## Code style

- Use `snake_case` for all function and variable names
- Use roxygen2 `@export`, `@param`, `@return`, `@examples` tags
- Pipe-friendly: return tibbles/data.frames from list endpoints
- No S4 or R6 — plain functions only
- Minimal dependencies: only `httr2` beyond base R

## DESCRIPTION fields

```
Package: daggle
Title: R Interface to the Daggle Scheduler
Version: 0.1.0
Authors@R: person("David", "Schoch", role = c("aut", "cre"), email = "david.schoch@cynkra.com")
Description: Companion R package for daggle, a lightweight DAG scheduler for R.
    Provides in-step helpers for emitting outputs and reading metadata,
    plus API wrappers for triggering runs, checking status, and managing
    approval gates.
License: GPL-3
URL: https://github.com/cynkra/daggleR
BugReports: https://github.com/cynkra/daggleR/issues
Imports: httr2
Suggests: testthat (>= 3.0.0), withr, httptest2
Config/testthat/edition: 3
Encoding: UTF-8
Roxygen: list(markdown = TRUE)
RoxygenNote: 7.3.2
```
