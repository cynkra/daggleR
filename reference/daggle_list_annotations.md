# List annotations for a run

Returns free-form notes attached to a run via `daggle annotate` or the
annotations API. Annotations are stored as `run_annotated` events in the
run's `events.jsonl`.

## Usage

``` r
daggle_list_annotations(name, run_id = "latest", base_url = NULL)
```

## Arguments

- name:

  Character string. Name of the DAG.

- run_id:

  Character string. Run ID, or `"latest"` for the most recent.

- base_url:

  Base URL of the daggle API. See Details.

## Value

A data.frame with columns: `timestamp`, `author`, `note`.
