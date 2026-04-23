# List schedules for a DAG

Returns every schedule registered for the DAG — both YAML-defined
schedules and ones added at runtime via
[`daggle_add_schedule()`](https://cynkra.github.io/daggleR/reference/daggle_add_schedule.md).

## Usage

``` r
daggle_list_schedules(name, base_url = NULL)
```

## Arguments

- name:

  Character string. Name of the DAG.

- base_url:

  Base URL of the daggle API. See Details.

## Value

A data.frame with columns `id`, `cron`, `source`, `enabled`, `next_run`.
The `source` column is `"yaml"` for schedules declared in the DAG's YAML
and `"runtime"` for ones added via the API. `next_run` is an RFC3339
timestamp or the empty string when the schedule is disabled. A `params`
list-column is present when any schedule carries parameter overrides.
