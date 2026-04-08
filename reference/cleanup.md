# Clean up old runs

Clean up old runs

## Usage

``` r
cleanup(older_than = "30d", base_url = NULL)
```

## Arguments

- older_than:

  Character string. Age threshold (e.g., `"30d"`).

- base_url:

  Base URL of the daggle API. See Details.

## Value

A list with elements: `removed`, `freed_bytes`, `freed`.
