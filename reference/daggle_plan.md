# Show execution plan with cache status

Returns which steps would run vs skip based on the current cache state.

## Usage

``` r
daggle_plan(name, base_url = NULL)
```

## Arguments

- name:

  Character string. Name of the DAG.

- base_url:

  Base URL of the daggle API. See Details.

## Value

A data.frame with columns: `step_id`, `status`, `reason`.
