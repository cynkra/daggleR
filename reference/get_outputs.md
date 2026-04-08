# Get outputs for a run

Get outputs for a run

## Usage

``` r
get_outputs(name, run_id = "latest", base_url = NULL)
```

## Arguments

- name:

  Character string. Name of the DAG.

- run_id:

  Character string. Run ID, or `"latest"` for the most recent.

- base_url:

  Base URL of the daggle API. See Details.

## Value

A data.frame with columns: `step_id`, `key`, `value`.
