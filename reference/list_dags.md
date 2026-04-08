# List all DAGs

List all DAGs

## Usage

``` r
list_dags(base_url = NULL)
```

## Arguments

- base_url:

  Base URL of the daggle API. See Details.

## Value

A data.frame with columns: `name`, `steps`, `project`, `schedule`,
`last_status`, `last_run`.

## Details

The base URL is resolved in order: explicit `base_url` parameter,
`DAGGLE_API_URL` environment variable, default `http://127.0.0.1:9090`.
