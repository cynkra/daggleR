# Create and describe a tamper-evident run archive

Triggers creation (or refresh) of the tamper-evident `.tar.gz` archive
for a run on the server and returns the archive metadata without
downloading the bytes. The archive is stored server-side at
`DAGGLE_DATA_DIR/archives/{name}_{run_id}.tar.gz`; use
[`daggle_archive_run()`](https://cynkra.github.io/daggleR/reference/daggle_archive_run.md)
to stream it locally.

## Usage

``` r
daggle_archive_info(name, run_id, base_url = NULL)
```

## Arguments

- name:

  Character string. Name of the DAG.

- run_id:

  Character string. Run ID, or `"latest"` for the most recent.

- base_url:

  Base URL of the daggle API. See Details.

## Value

A list with elements `path` (absolute path on the server), `files`
(count), `bytes` (total size), `created_at` (RFC3339 UTC).
