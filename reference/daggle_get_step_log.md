# Get log output for a step

Get log output for a step

## Usage

``` r
daggle_get_step_log(name, run_id, step_id, base_url = NULL)
```

## Arguments

- name:

  Character string. Name of the DAG.

- run_id:

  Character string. Run ID.

- step_id:

  Character string. Step ID.

- base_url:

  Base URL of the daggle API. See Details.

## Value

A list with elements: `step_id`, `stdout`, `stderr`.
