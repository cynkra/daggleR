# Get details for a specific run

Get details for a specific run

## Usage

``` r
daggle_get_run(name, run_id = "latest", base_url = NULL)
```

## Arguments

- name:

  Character string. Name of the DAG.

- run_id:

  Character string. Run ID, or `"latest"` for the most recent.

- base_url:

  Base URL of the daggle API. See Details.

## Value

A list describing the run. Includes `run_id`, `dag_name`, `status`,
`started`, `ended`, `duration_seconds`, `dag_hash`, `r_version`,
`platform`, `params`, `steps`. The `steps` element is a data.frame that
may include resource columns `peak_rss_kb` (int), `user_cpu_sec` (num),
`sys_cpu_sec` (num). The run also carries an `annotations` element
(data.frame of `timestamp`, `author`, `note`) when notes have been
attached.
