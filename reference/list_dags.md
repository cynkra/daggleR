# List all DAGs

List all DAGs

## Usage

``` r
list_dags(tag = NULL, team = NULL, owner = NULL, base_url = NULL)
```

## Arguments

- tag:

  Character string. If set, only return DAGs that declare this tag.

- team:

  Character string. If set, only return DAGs owned by this team.

- owner:

  Character string. If set, only return DAGs owned by this user.

- base_url:

  Base URL of the daggle API. See Details.

## Value

A data.frame with one row per DAG. Always includes `name`, `steps`,
`project`, `schedule`, `last_status`, `last_run`. May also include
`owner`, `team`, `description`, and `tags` columns when any DAG declares
those fields. The `tags` column is a list-column of character vectors.

## Details

The base URL is resolved in order: explicit `base_url` parameter,
`DAGGLE_API_URL` environment variable, default `http://127.0.0.1:9090`.
