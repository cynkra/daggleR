#' List all DAGs
#'
#' @param tag Character string. If set, only return DAGs that declare this tag.
#' @param team Character string. If set, only return DAGs owned by this team.
#' @param owner Character string. If set, only return DAGs owned by this user.
#' @param base_url Base URL of the daggle API. See Details.
#'
#' @details
#' The base URL is resolved in order: explicit `base_url` parameter,
#' `DAGGLE_API_URL` environment variable, default `http://127.0.0.1:9090`.
#'
#' @return A data.frame with one row per DAG. Always includes `name`, `steps`,
#'   `project`, `schedule`, `last_status`, `last_run`. May also include
#'   `owner`, `team`, `description`, and `tags` columns when any DAG declares
#'   those fields. The `tags` column is a list-column of character vectors.
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

#' Get details for a single DAG
#'
#' @param name Character string. Name of the DAG.
#' @inheritParams list_dags
#'
#' @return A list with the DAG definition and latest run status. Always
#'   includes `name`, `steps`, `step_ids`, `schedule`, `workdir`, `r_version`,
#'   `last_status`, `last_run_id`, `last_run`. May also include optional
#'   fields `owner`, `team`, `description`, `tags`, and `exposures`
#'   (a data.frame with `name`, `type`, `url`, `description`) when declared
#'   on the DAG.
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
#' @return A list describing the run. Includes `run_id`, `dag_name`, `status`,
#'   `started`, `ended`, `duration_seconds`, `dag_hash`, `r_version`,
#'   `platform`, `params`, `steps`. The `steps` element is a data.frame that
#'   may include resource columns `peak_rss_kb` (int), `user_cpu_sec` (num),
#'   `sys_cpu_sec` (num). The run also carries an `annotations` element
#'   (data.frame of `timestamp`, `author`, `note`) when notes have been
#'   attached.
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
