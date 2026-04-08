#' List all DAGs
#'
#' @param base_url Base URL of the daggle API. See Details.
#'
#' @details
#' The base URL is resolved in order: explicit `base_url` parameter,
#' `DAGGLE_API_URL` environment variable, default `http://127.0.0.1:9090`.
#'
#' @return A data.frame with columns: `name`, `steps`, `project`, `schedule`,
#'   `last_status`, `last_run`.
#' @export
list_dags <- function(base_url = NULL) {
  url <- resolve_base_url(base_url)
  httr2::request(url) |>
    httr2::req_url_path_append("api", "v1", "dags") |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}

#' Get details for a single DAG
#'
#' @param name Character string. Name of the DAG.
#' @inheritParams list_dags
#'
#' @return A list with elements: `name`, `steps`, `step_ids`, `schedule`,
#'   `workdir`, `r_version`, `last_status`, `last_run_id`, `last_run`.
#' @export
get_dag <- function(name, base_url = NULL) {
  url <- resolve_base_url(base_url)
  httr2::request(url) |>
    httr2::req_url_path_append("api", "v1", "dags", name) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' Trigger a new DAG run
#'
#' @param name Character string. Name of the DAG to trigger.
#' @param params Named list of parameters to pass to the run.
#' @inheritParams list_dags
#'
#' @return A list with elements: `run_id`, `status`.
#' @export
trigger <- function(name, params = list(), base_url = NULL) {
  url <- resolve_base_url(base_url)
  httr2::request(url) |>
    httr2::req_url_path_append("api", "v1", "dags", name, "run") |>
    httr2::req_body_json(list(params = params)) |>
    httr2::req_method("POST") |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' List runs for a DAG
#'
#' @param name Character string. Name of the DAG.
#' @inheritParams list_dags
#'
#' @return A data.frame with columns: `run_id`, `started`, `status`,
#'   `duration_seconds`, `dag_hash`.
#' @export
list_runs <- function(name, base_url = NULL) {
  url <- resolve_base_url(base_url)
  httr2::request(url) |>
    httr2::req_url_path_append("api", "v1", "dags", name, "runs") |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}

#' Get details for a specific run
#'
#' @param name Character string. Name of the DAG.
#' @param run_id Character string. Run ID, or `"latest"` for the most recent.
#' @inheritParams list_dags
#'
#' @return A list with elements: `run_id`, `dag_name`, `status`, `started`,
#'   `ended`, `duration_seconds`, `dag_hash`, `r_version`, `platform`,
#'   `params`, `steps`.
#' @export
get_run <- function(name, run_id = "latest", base_url = NULL) {
  url <- resolve_base_url(base_url)
  httr2::request(url) |>
    httr2::req_url_path_append("api", "v1", "dags", name, "runs", run_id) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' Get outputs for a run
#'
#' @param name Character string. Name of the DAG.
#' @param run_id Character string. Run ID, or `"latest"` for the most recent.
#' @inheritParams list_dags
#'
#' @return A data.frame with columns: `step_id`, `key`, `value`.
#' @export
get_outputs <- function(name, run_id = "latest", base_url = NULL) {
  url <- resolve_base_url(base_url)
  httr2::request(url) |>
    httr2::req_url_path_append(
      "api", "v1", "dags", name, "runs", run_id, "outputs"
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}

#' Get log output for a step
#'
#' @param name Character string. Name of the DAG.
#' @param run_id Character string. Run ID.
#' @param step_id Character string. Step ID.
#' @inheritParams list_dags
#'
#' @return A list with elements: `step_id`, `stdout`, `stderr`.
#' @export
get_step_log <- function(name, run_id, step_id, base_url = NULL) {
  url <- resolve_base_url(base_url)
  httr2::request(url) |>
    httr2::req_url_path_append(
      "api", "v1", "dags", name, "runs", run_id, "steps", step_id, "log"
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' Cancel a running DAG run
#'
#' @param name Character string. Name of the DAG.
#' @param run_id Character string. Run ID, or `"latest"` for the most recent.
#' @inheritParams list_dags
#'
#' @return A list with elements: `status`, `run_id`, `message`.
#' @export
cancel_run <- function(name, run_id = "latest", base_url = NULL) {
  url <- resolve_base_url(base_url)
  httr2::request(url) |>
    httr2::req_url_path_append(
      "api", "v1", "dags", name, "runs", run_id, "cancel"
    ) |>
    httr2::req_method("POST") |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' Approve a waiting step
#'
#' @param name Character string. Name of the DAG.
#' @param run_id Character string. Run ID.
#' @param step_id Character string. Step ID to approve.
#' @inheritParams list_dags
#'
#' @return A list with elements: `step_id`, `status`.
#' @export
approve <- function(name, run_id, step_id, base_url = NULL) {
  url <- resolve_base_url(base_url)
  httr2::request(url) |>
    httr2::req_url_path_append(
      "api", "v1", "dags", name, "runs", run_id, "steps", step_id, "approve"
    ) |>
    httr2::req_method("POST") |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' Reject a waiting step
#'
#' @param name Character string. Name of the DAG.
#' @param run_id Character string. Run ID.
#' @param step_id Character string. Step ID to reject.
#' @inheritParams list_dags
#'
#' @return A list with elements: `step_id`, `status`.
#' @export
reject <- function(name, run_id, step_id, base_url = NULL) {
  url <- resolve_base_url(base_url)
  httr2::request(url) |>
    httr2::req_url_path_append(
      "api", "v1", "dags", name, "runs", run_id, "steps", step_id, "reject"
    ) |>
    httr2::req_method("POST") |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' List registered projects
#'
#' @inheritParams list_dags
#'
#' @return A data.frame with columns: `name`, `path`, `status`, `dags`.
#' @export
list_projects <- function(base_url = NULL) {
  url <- resolve_base_url(base_url)
  httr2::request(url) |>
    httr2::req_url_path_append("api", "v1", "projects") |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}

#' Register a project
#'
#' @param path Character string. Absolute path to the project directory.
#' @param name Character string or `NULL`. Optional project name; defaults to
#'   the directory basename on the server side.
#' @inheritParams list_dags
#'
#' @return A list with elements: `name`, `path`.
#' @export
register_project <- function(path, name = NULL, base_url = NULL) {
  url <- resolve_base_url(base_url)
  body <- list(path = path)
  if (!is.null(name)) body$name <- name
  httr2::request(url) |>
    httr2::req_url_path_append("api", "v1", "projects") |>
    httr2::req_body_json(body) |>
    httr2::req_method("POST") |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' Unregister a project
#'
#' @param name Character string. Name of the project to unregister.
#' @inheritParams list_dags
#'
#' @return A list with element: `name`.
#' @export
unregister_project <- function(name, base_url = NULL) {
  url <- resolve_base_url(base_url)
  httr2::request(url) |>
    httr2::req_url_path_append("api", "v1", "projects", name) |>
    httr2::req_method("DELETE") |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' Check API health
#'
#' @inheritParams list_dags
#'
#' @return A list with elements: `status`, `version`, `uptime_seconds`.
#' @export
health <- function(base_url = NULL) {
  url <- resolve_base_url(base_url)
  httr2::request(url) |>
    httr2::req_url_path_append("api", "v1", "health") |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' Clean up old runs
#'
#' @param older_than Character string. Age threshold (e.g., `"30d"`).
#' @inheritParams list_dags
#'
#' @return A list with elements: `removed`, `freed_bytes`, `freed`.
#' @export
cleanup <- function(older_than = "30d", base_url = NULL) {
  url <- resolve_base_url(base_url)
  httr2::request(url) |>
    httr2::req_url_path_append("api", "v1", "runs", "cleanup") |>
    httr2::req_body_json(list(older_than = older_than)) |>
    httr2::req_method("POST") |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}
