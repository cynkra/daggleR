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
