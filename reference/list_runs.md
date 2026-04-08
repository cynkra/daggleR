# List runs for a DAG

List runs for a DAG

## Usage

``` r
list_runs(name, base_url = NULL)
```

## Arguments

- name:

  Character string. Name of the DAG.

- base_url:

  Base URL of the daggle API. See Details.

## Value

A data.frame with columns: `run_id`, `started`, `status`,
`duration_seconds`, `dag_hash`.
