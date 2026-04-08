# Get details for a single DAG

Get details for a single DAG

## Usage

``` r
get_dag(name, base_url = NULL)
```

## Arguments

- name:

  Character string. Name of the DAG.

- base_url:

  Base URL of the daggle API. See Details.

## Value

A list with elements: `name`, `steps`, `step_ids`, `schedule`,
`workdir`, `r_version`, `last_status`, `last_run_id`, `last_run`.
