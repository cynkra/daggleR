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

#' Get the daggle CLI version
#'
#' Shells out to `daggle version` and returns the version string.
#'
#' @return A character string with the daggle CLI version.
#' @export
#' @examples
#' \dontrun{
#' cli_version()
#' }
cli_version <- function() {
  if (Sys.which("daggle") == "") {
    stop("daggle CLI not found on PATH.", call. = FALSE)
  }
  out <- system2("daggle", "version", stdout = TRUE, stderr = TRUE)
  trimws(out)
}
