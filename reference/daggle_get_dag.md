# Get details for a single DAG

Get details for a single DAG

## Usage

``` r
daggle_get_dag(name, base_url = NULL)
```

## Arguments

- name:

  Character string. Name of the DAG.

- base_url:

  Base URL of the daggle API. See Details.

## Value

A list with the DAG definition and latest run status. Always includes
`name`, `steps`, `step_ids`, `schedule`, `workdir`, `r_version`,
`last_status`, `last_run_id`, `last_run`. May also include optional
fields `owner`, `team`, `description`, `tags`, and `exposures` (a
data.frame with `name`, `type`, `url`, `description`) when declared on
the DAG.
