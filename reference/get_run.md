# Get details for a specific run

Get details for a specific run

## Usage

``` r
get_run(name, run_id = "latest", base_url = NULL)
```

## Arguments

- name:

  Character string. Name of the DAG.

- run_id:

  Character string. Run ID, or `"latest"` for the most recent.

- base_url:

  Base URL of the daggle API. See Details.

## Value

A list with elements: `run_id`, `dag_name`, `status`, `started`,
`ended`, `duration_seconds`, `dag_hash`, `r_version`, `platform`,
`params`, `steps`.
