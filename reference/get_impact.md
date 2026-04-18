# Get downstream impact of a DAG

Returns DAGs that depend on the given DAG (via `trigger.on_dag.name`)
plus any `exposures:` (dashboards, reports, Shiny apps) declared on the
DAG.

## Usage

``` r
get_impact(name, base_url = NULL)
```

## Arguments

- name:

  Character string. Name of the DAG.

- base_url:

  Base URL of the daggle API. See Details.

## Value

A list with elements `dag` (character), `downstream_dags` (data.frame
with `name`, `project`, `trigger_on_status`), and `exposures`
(data.frame with `name`, `type`, `url`, `description`).
