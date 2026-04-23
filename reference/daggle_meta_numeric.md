# Emit a numeric metadata value

Emit a typed numeric metric that daggle stores per-step. Numeric
metadata can be tracked across runs for trend analysis.

## Usage

``` r
daggle_meta_numeric(name, value)
```

## Arguments

- name:

  Character string. Metric name. Must match `[a-zA-Z_][a-zA-Z0-9_]*`.

- value:

  Numeric. Metric value.

## Value

`value`, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
daggle_meta_numeric("row_count", nrow(df))
daggle_meta_numeric("accuracy", 0.95)
} # }
```
