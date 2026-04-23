# Get step metadata for a run

Get step metadata for a run

## Usage

``` r
daggle_get_metadata(name, run_id = "latest", base_url = NULL)
```

## Arguments

- name:

  Character string. Name of the DAG.

- run_id:

  Character string. Run ID, or `"latest"` for the most recent.

- base_url:

  Base URL of the daggle API. See Details.

## Value

A data.frame with columns: `step_id`, `name`, `type`, `value`.
