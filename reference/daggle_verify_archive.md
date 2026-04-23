# Verify integrity of a run archive

Recomputes hashes of every file recorded in the archive's manifest and
reports any files whose contents, presence, or count differs.

## Usage

``` r
daggle_verify_archive(name, run_id, base_url = NULL)
```

## Arguments

- name:

  Character string. Name of the DAG.

- run_id:

  Character string. Run ID, or `"latest"` for the most recent.

- base_url:

  Base URL of the daggle API. See Details.

## Value

A list with elements `ok` (logical, overall integrity), `files` (count),
`mismatched` (character vector of file paths whose contents changed),
`missing` (expected but not found), `extra` (found but not expected).
