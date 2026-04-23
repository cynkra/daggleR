# Run `daggle lint` on a DAG

Shells out to the local `daggle` CLI to run semantic diagnostics on a
DAG (missing scripts, unresolvable secrets, unknown notification
channels, and optionally missing R packages). Returns a tidy data.frame
of diagnostics.

## Usage

``` r
daggle_lint(dag, check_packages = FALSE, daggle_bin = "daggle")
```

## Arguments

- dag:

  Character string. DAG name or path to a DAG YAML file.

- check_packages:

  Logical. If `TRUE`, also verify that R packages required by R-based
  step types (`rmd`, `coverage`, `pkgdown`, `pins`, ...) are installed.
  Slower; runs a single `Rscript` invocation. Default `FALSE`.

- daggle_bin:

  Character string. Path to the `daggle` binary. Defaults to `"daggle"`
  (resolved via PATH).

## Value

A data.frame with columns `path`, `line`, `col`, `severity` (`"error"`,
`"warning"`, `"info"`), `code`, and `message`. Returns a zero-row
data.frame when the DAG passes cleanly.

## Details

Requires the `daggle` binary on the user's PATH.

## Examples

``` r
if (FALSE) { # \dontrun{
diagnostics <- daggle_lint("etl-pipeline")
stopifnot(nrow(diagnostics[diagnostics$severity == "error", ]) == 0)
} # }
```
