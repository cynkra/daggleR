# Remove a runtime schedule from a DAG

Only schedules added via
[`daggle_add_schedule()`](https://cynkra.github.io/daggleR/reference/daggle_add_schedule.md)
(`source = "runtime"`) can be removed. Attempting to delete a
YAML-declared schedule returns a `400 Bad Request` from the server.

## Usage

``` r
daggle_remove_schedule(name, schedule_id, base_url = NULL)
```

## Arguments

- name:

  Character string. Name of the DAG.

- schedule_id:

  Character string. ID of the schedule to remove, as returned by
  [`daggle_list_schedules()`](https://cynkra.github.io/daggleR/reference/daggle_list_schedules.md)
  or
  [`daggle_add_schedule()`](https://cynkra.github.io/daggleR/reference/daggle_add_schedule.md).

- base_url:

  Base URL of the daggle API. See Details.

## Value

`TRUE`, invisibly.
