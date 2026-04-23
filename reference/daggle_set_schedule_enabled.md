# Enable or disable a schedule

Toggles a schedule's `enabled` flag without otherwise modifying it.
Works for both YAML- and runtime-sourced schedules.

## Usage

``` r
daggle_set_schedule_enabled(name, schedule_id, enabled, base_url = NULL)
```

## Arguments

- name:

  Character string. Name of the DAG.

- schedule_id:

  Character string. ID of the schedule to update.

- enabled:

  Logical. `TRUE` to enable, `FALSE` to disable.

- base_url:

  Base URL of the daggle API. See Details.

## Value

A list with the updated schedule object.
