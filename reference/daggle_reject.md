# Reject a waiting step

Reject a waiting step

## Usage

``` r
daggle_reject(name, run_id, step_id, base_url = NULL)
```

## Arguments

- name:

  Character string. Name of the DAG.

- run_id:

  Character string. Run ID.

- step_id:

  Character string. Step ID to reject.

- base_url:

  Base URL of the daggle API. See Details.

## Value

A list with elements: `step_id`, `status`.
