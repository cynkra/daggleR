# Resolve the daggle API base URL

Resolves the base URL in order: explicit parameter, `DAGGLE_API_URL`
environment variable, default `http://127.0.0.1:9090`.

## Usage

``` r
resolve_base_url(base_url = NULL)
```

## Arguments

- base_url:

  Character string or `NULL`. Explicit base URL.

## Value

Character string with trailing slashes removed.
