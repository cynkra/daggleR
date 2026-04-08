#' Emit a daggle output marker
#'
#' Write an output marker to stdout that daggle captures and passes to
#' downstream steps. Must be called inside an R step executed by daggle.
#'
#' @param name Character string. Output key name. Must match
#'   `[a-zA-Z_][a-zA-Z0-9_]*`.
#' @param value Value to emit. Coerced to character with [as.character()].
#'
#' @return `value`, invisibly.
#' @export
#' @examples
#' \dontrun{
#' output("row_count", nrow(df))
#' output("model_path", "/tmp/model.rds")
#' }
output <- function(name, value) {
  if (!grepl("^[a-zA-Z_][a-zA-Z0-9_]*$", name)) {
    stop(
      "Invalid output name '", name, "'. ",
      "Must match [a-zA-Z_][a-zA-Z0-9_]*.",
      call. = FALSE
    )
  }
  cat(sprintf("::daggle-output name=%s::%s\n", name, as.character(value)))
  invisible(value)
}

#' Get the current daggle run ID
#'
#' @return Character string from the `DAGGLE_RUN_ID` environment variable.
#' @export
#' @examples
#' \dontrun{
#' run_id()
#' }
run_id <- function() {
  Sys.getenv("DAGGLE_RUN_ID")
}

#' Get the current DAG name
#'
#' @return Character string from the `DAGGLE_DAG_NAME` environment variable.
#' @export
#' @examples
#' \dontrun{
#' dag_name()
#' }
dag_name <- function() {
  Sys.getenv("DAGGLE_DAG_NAME")
}

#' Get the current run directory
#'
#' @return Character string from the `DAGGLE_RUN_DIR` environment variable.
#' @export
#' @examples
#' \dontrun{
#' run_dir()
#' }
run_dir <- function() {
  Sys.getenv("DAGGLE_RUN_DIR")
}

#' Get a matrix parameter value
#'
#' Reads the value of a matrix parameter for the current step. Matrix steps
#' receive `DAGGLE_MATRIX_<KEY>` environment variables with the key uppercased.
#'
#' @param key Character string. The matrix parameter name (e.g., `"region"`).
#'
#' @return Character string with the matrix value, or `""` if not set.
#' @export
#' @examples
#' \dontrun{
#' region <- get_matrix("region")
#' }
get_matrix <- function(key) {
  Sys.getenv(paste0("DAGGLE_MATRIX_", toupper(key)))
}

#' Read an output from a completed upstream step
#'
#' Reads the value of an output emitted by a completed upstream step via
#' the corresponding environment variable.
#'
#' @param step Character string. The step ID (e.g., `"fit-lda"`).
#' @param key Character string. The output key name (e.g., `"accuracy"`).
#'
#' @return Character string with the output value, or `""` if not set.
#' @export
#' @examples
#' \dontrun{
#' accuracy <- get_output("fit-lda", "accuracy")
#' }
get_output <- function(step, key) {
  var_name <- paste0(
    "DAGGLE_OUTPUT_",
    toupper(gsub("-", "_", step)), "_",
    toupper(key)
  )
  Sys.getenv(var_name)
}
