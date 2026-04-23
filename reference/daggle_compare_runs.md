# Compare two runs

Compare two runs

## Usage

``` r
daggle_compare_runs(name, run1, run2, base_url = NULL)
```

## Arguments

- name:

  Character string. Name of the DAG.

- run1:

  Character string. First run ID.

- run2:

  Character string. Second run ID.

- base_url:

  Base URL of the daggle API. See Details.

## Value

A list with elements: `outputs_diff` (data.frame with columns `step_id`,
`key`, `value1`, `value2`), `duration_diff` (list with `run1_seconds`,
`run2_seconds`, `diff_seconds`), `meta_diff` (list with `dag_hash1`,
`dag_hash2`, `changed`).
