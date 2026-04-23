# Emit a table metadata value

Serialize a data.frame to JSON and emit as table metadata. Requires the
jsonlite package (Suggests dependency).

## Usage

``` r
daggle_meta_table(name, df)
```

## Arguments

- name:

  Character string. Table name. Must match `[a-zA-Z_][a-zA-Z0-9_]*`.

- df:

  A data.frame to serialize.

## Value

`df`, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
daggle_meta_table("top5", head(results, 5))
} # }
```
