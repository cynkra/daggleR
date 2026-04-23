# Download a tamper-evident run archive

Creates (or refreshes) the server-side archive and writes the `.tar.gz`
bytes to `dest`. Use
[`daggle_verify_archive()`](https://cynkra.github.io/daggleR/reference/daggle_verify_archive.md)
afterwards to confirm integrity.

## Usage

``` r
daggle_archive_run(
  name,
  run_id,
  dest = tempfile(fileext = ".tar.gz"),
  base_url = NULL
)
```

## Arguments

- name:

  Character string. Name of the DAG.

- run_id:

  Character string. Run ID, or `"latest"` for the most recent.

- dest:

  Character string. Local file path to write the archive to. Defaults to
  a temporary file with extension `.tar.gz`.

- base_url:

  Base URL of the daggle API. See Details.

## Value

The absolute path to `dest`, returned invisibly.

## Details

This is the first wrapper in daggleR that returns a binary response.
Future binary downloads should mirror this shape: resolve the base URL
with
[`resolve_base_url()`](https://cynkra.github.io/daggleR/reference/resolve_base_url.md),
build the request directly via
[`httr2::request()`](https://httr2.r-lib.org/reference/request.html) and
[`httr2::req_url_path_append()`](https://httr2.r-lib.org/reference/req_url.html)
(skipping
[`daggle_request()`](https://cynkra.github.io/daggleR/reference/daggle_request.md),
which always parses the response as JSON), then persist with
[`writeBin()`](https://rdrr.io/r/base/readBin.html) on
[`httr2::resp_body_raw()`](https://httr2.r-lib.org/reference/resp_body_raw.html).
