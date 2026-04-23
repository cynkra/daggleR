# Add a runtime schedule to a DAG

Registers a new cron schedule without editing the DAG's YAML. The
schedule is stored server-side with `source = "runtime"` and can be
removed with
[`daggle_remove_schedule()`](https://cynkra.github.io/daggleR/reference/daggle_remove_schedule.md).

## Usage

``` r
daggle_add_schedule(name, cron, params = NULL, enabled = TRUE, base_url = NULL)
```

## Arguments

- name:

  Character string. Name of the DAG.

- cron:

  Character string. Cron expression (e.g. `"0 7 * * *"`).

- params:

  Named list of parameter overrides passed to each triggered run, or
  `NULL`.

- enabled:

  Logical. Whether the schedule fires immediately. Defaults to `TRUE`.

- base_url:

  Base URL of the daggle API. See Details.

## Value

A list describing the created schedule: `id`, `cron`, `source`,
`enabled`, `next_run`, and (when set) `params`.
