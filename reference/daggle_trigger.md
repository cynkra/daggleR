# Trigger a new DAG run

Trigger a new DAG run

## Usage

``` r
daggle_trigger(name, params = list(), base_url = NULL)
```

## Arguments

- name:

  Character string. Name of the DAG to trigger.

- params:

  Named list of parameters to pass to the run.

- base_url:

  Base URL of the daggle API. See Details.

## Value

A list with elements: `run_id`, `status`.
