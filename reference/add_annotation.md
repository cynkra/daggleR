# Add an annotation to a run

Attaches a free-form note to an existing run. Writes a `run_annotated`
event to the run's `events.jsonl`. Annotations surface in
`daggle status`, the API, and the web UI.

## Usage

``` r
add_annotation(name, run_id, note, author = NULL, base_url = NULL)
```

## Arguments

- name:

  Character string. Name of the DAG.

- run_id:

  Character string. Run ID (must be an existing run).

- note:

  Character string. The annotation text.

- author:

  Character string. Who wrote the annotation. Defaults to the value of
  `Sys.getenv("USER")`.

- base_url:

  Base URL of the daggle API. See Details.

## Value

Invisibly, the HTTP response status list returned by the server.
