#' Scaffold a new DAG YAML under `.daggle/`
#'
#' Creates `<dir>/.daggle/` if missing and writes `<dir>/.daggle/<name>.yaml`
#' from a built-in template. Useful for bootstrapping a new DAG from an R
#' session without leaving the IDE. This mirrors the `daggle init <template>`
#' CLI command.
#'
#' @param name Character string. Name for the DAG. Becomes the YAML file's
#'   basename (`.daggle/<name>.yaml`) and the value of the `name:` field in
#'   the generated YAML. Must not be empty and must not contain `/` or `\`.
#' @param template Template to scaffold. One of `"minimal"`,
#'   `"data-pipeline"`, `"pkg-check"`, or `"pkg-release"`.
#' @param dir Character string. Directory to create `.daggle/` inside.
#'   Defaults to the current working directory.
#' @param overwrite Logical. If `FALSE` (default), errors when the target
#'   file already exists. Set to `TRUE` to replace it.
#'
#' @return The absolute path to the written YAML file, returned invisibly.
#'
#' @seealso [register_project()] to register the project with the daggle
#'   daemon so newly scaffolded DAGs become visible over the HTTP API.
#'
#' @export
init_dag <- function(name,
                     template = c("minimal", "data-pipeline", "pkg-check", "pkg-release"),
                     dir = getwd(),
                     overwrite = FALSE) {
  template <- match.arg(template)

  if (!is.character(name) || length(name) != 1L || !nzchar(name)) {
    stop("`name` must be a non-empty character string.", call. = FALSE)
  }
  if (grepl("[/\\\\]", name) || startsWith(name, ".")) {
    stop("`name` must not contain '/' or '\\\\' or start with '.'.", call. = FALSE)
  }

  dag_dir <- file.path(dir, ".daggle")
  dir.create(dag_dir, showWarnings = FALSE, recursive = TRUE)

  target <- file.path(dag_dir, paste0(name, ".yaml"))
  if (file.exists(target) && !overwrite) {
    stop("file already exists: ", target, " (use overwrite = TRUE)", call. = FALSE)
  }

  content <- .dag_templates[[template]]
  content <- sub("^name:.*", paste0("name: ", name), content, perl = TRUE)

  writeLines(content, target)
  invisible(normalizePath(target))
}

.dag_templates <- list(
  minimal = "name: minimal
triggers:
  - schedule: \"0 7 * * *\"  # daily at 07:00
steps:
  - id: hello
    r_expr: |
      message(\"Hello from daggle\")
",

  "pkg-check" = "name: pkg-check
steps:
  - id: document
    document: \".\"

  - id: lint
    lint: \".\"
    depends: [document]

  - id: test
    test: \".\"
    depends: [document]

  - id: coverage
    coverage: \".\"
    depends: [test]

  - id: check
    check: \".\"
    depends: [document]

on_failure:
  command: echo \"Package check failed\"
",

  "pkg-release" = "name: pkg-release
params:
  - name: bump
    default: patch

steps:
  - id: document
    document: \".\"

  - id: lint
    lint: \".\"
    depends: [document]

  - id: test
    test: \".\"
    depends: [document]

  - id: check
    check: \".\"
    depends: [document]

  - id: review
    approve:
      message: \"Review check results before releasing\"
    depends: [lint, test, check]

  - id: pkgdown
    pkgdown: \".\"
    depends: [review]
",

  "data-pipeline" = "name: data-pipeline
params:
  - name: date
    default: \"{{ .Today }}\"

env:
  DATA_DIR: data
  OUTPUT_DIR: output

steps:
  - id: extract
    script: R/extract.R
    timeout: 30m
    retry:
      limit: 3

  - id: validate
    r_expr: |
      data <- readRDS(file.path(Sys.getenv(\"DATA_DIR\"), \"raw.rds\"))
      stopifnot(nrow(data) > 0)
      cat(\"::daggle-output name=row_count::\", nrow(data), \"\\n\")
    depends: [extract]

  - id: transform
    script: R/transform.R
    depends: [validate]

  - id: report
    quarto: reports/summary.qmd
    depends: [transform]
"
)
