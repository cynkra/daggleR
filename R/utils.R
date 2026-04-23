#' Resolve the daggle API base URL
#'
#' Resolves the base URL in order: explicit parameter, `DAGGLE_API_URL`
#' environment variable, default `http://127.0.0.1:9090`.
#'
#' @param base_url Character string or `NULL`. Explicit base URL.
#'
#' @return Character string with trailing slashes removed.
#' @keywords internal
resolve_base_url <- function(base_url = NULL) {
  if (!is.null(base_url)) return(sub("/+$", "", base_url))
  url <- Sys.getenv("DAGGLE_API_URL", "http://127.0.0.1:9090")
  sub("/+$", "", url)
}

#' Send a request to the daggle API
#'
#' Internal helper used by the API wrappers. Builds an `httr2` request
#' against the resolved base URL, performs it, and parses the JSON body.
#' Centralises the boilerplate so each wrapper only declares the path,
#' method, and optional query/body.
#'
#' @param path Character vector of URL path segments appended after the
#'   base URL via [httr2::req_url_path_append()]. Example:
#'   `c("api", "v1", "dags", name, "runs", run_id)`.
#' @param method HTTP method. One of `"GET"`, `"POST"`, `"DELETE"`, `"PATCH"`.
#' @param query Named list of query parameters, or `NULL`. Elements whose
#'   value is `NULL` are dropped (so callers can pass optional filters
#'   without conditional wiring).
#' @param body Named list serialised as a JSON request body, or `NULL`.
#' @param simplify Passed to [httr2::resp_body_json()] as `simplifyVector`.
#'   Set `TRUE` for collection endpoints that should return a data.frame;
#'   leave `FALSE` for single-object endpoints that should return a list.
#' @param base_url Character string or `NULL`. Passed to [resolve_base_url()].
#'
#' @return Parsed JSON response — a list, or a data.frame when
#'   `simplify = TRUE`. Returns `NULL` for responses with no body
#'   (e.g. `204 No Content`).
#' @keywords internal
daggle_request <- function(path,
                           method = c("GET", "POST", "DELETE", "PATCH"),
                           query = NULL,
                           body = NULL,
                           simplify = FALSE,
                           base_url = NULL) {
  method <- match.arg(method)
  url <- resolve_base_url(base_url)
  req <- Reduce(httr2::req_url_path_append, path, httr2::request(url))
  if (!is.null(query)) {
    query <- query[!vapply(query, is.null, logical(1))]
    if (length(query) > 0) {
      req <- do.call(httr2::req_url_query, c(list(req), query))
    }
  }
  if (!is.null(body)) {
    req <- httr2::req_body_json(req, body)
  }
  if (method != "GET") {
    req <- httr2::req_method(req, method)
  }
  resp <- httr2::req_perform(req)
  if (!httr2::resp_has_body(resp)) return(NULL)
  httr2::resp_body_json(resp, simplifyVector = simplify)
}

#' Get the daggle CLI version
#'
#' Shells out to `daggle version` and returns the version string.
#'
#' @return A character string with the daggle CLI version.
#' @export
#' @examples
#' \dontrun{
#' daggle_cli_version()
#' }
daggle_cli_version <- function() {
  if (Sys.which("daggle") == "") {
    stop("daggle CLI not found on PATH.", call. = FALSE)
  }
  out <- system2("daggle", "version", stdout = TRUE, stderr = TRUE)
  trimws(out)
}

#' Run `daggle lint` on a DAG
#'
#' Shells out to the local `daggle` CLI to run semantic diagnostics on a DAG
#' (missing scripts, unresolvable secrets, unknown notification channels, and
#' optionally missing R packages). Returns a tidy data.frame of diagnostics.
#'
#' Requires the `daggle` binary on the user's PATH.
#'
#' @param dag Character string. DAG name or path to a DAG YAML file.
#' @param check_packages Logical. If `TRUE`, also verify that R packages
#'   required by R-based step types (`rmd`, `coverage`, `pkgdown`, `pins`, ...)
#'   are installed. Slower; runs a single `Rscript` invocation. Default `FALSE`.
#' @param daggle_bin Character string. Path to the `daggle` binary. Defaults
#'   to `"daggle"` (resolved via PATH).
#'
#' @return A data.frame with columns `path`, `line`, `col`, `severity`
#'   (`"error"`, `"warning"`, `"info"`), `code`, and `message`. Returns a
#'   zero-row data.frame when the DAG passes cleanly.
#' @export
#' @examples
#' \dontrun{
#' diagnostics <- daggle_lint("etl-pipeline")
#' stopifnot(nrow(diagnostics[diagnostics$severity == "error", ]) == 0)
#' }
daggle_lint <- function(dag, check_packages = FALSE, daggle_bin = "daggle") {
  args <- c("lint", dag, "--format", "json")
  if (isTRUE(check_packages)) args <- c(args, "--check-packages")
  res <- tryCatch(
    suppressWarnings(
      system2(daggle_bin, args, stdout = TRUE, stderr = TRUE)
    ),
    error = function(e) {
      stop("daggle lint failed: ", conditionMessage(e), call. = FALSE)
    }
  )
  status <- attr(res, "status")
  if (!is.null(status) && !status %in% c(0L, 1L)) {
    stop(
      "daggle lint failed with exit code ", status, ":\n",
      paste(res, collapse = "\n"),
      call. = FALSE
    )
  }
  if (!requireNamespace("jsonlite", quietly = TRUE)) {
    stop(
      "daggle_lint() requires the jsonlite package. ",
      "Install with: install.packages('jsonlite')",
      call. = FALSE
    )
  }
  parsed <- jsonlite::fromJSON(paste(res, collapse = "\n"))
  if (is.null(parsed) || length(parsed) == 0L) {
    return(data.frame(
      path = character(), line = integer(), col = integer(),
      severity = character(), code = character(), message = character(),
      stringsAsFactors = FALSE
    ))
  }
  parsed
}
