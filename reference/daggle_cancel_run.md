# Cancel a running DAG run

Cancel a running DAG run

## Usage

``` r
daggle_cancel_run(name, run_id = "latest", base_url = NULL)
```

## Arguments

- name:

  Character string. Name of the DAG.

- run_id:

  Character string. Run ID, or `"latest"` for the most recent.

- base_url:

  Base URL of the daggle API. See Details.

## Value

A list with elements: `status`, `run_id`, `message`.
