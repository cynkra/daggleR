# Emit a daggle output marker

Write an output marker to stdout that daggle captures and passes to
downstream steps. Must be called inside an R step executed by daggle.

## Usage

``` r
output(name, value)
```

## Arguments

- name:

  Character string. Output key name. Must match
  `[a-zA-Z_][a-zA-Z0-9_]*`.

- value:

  Value to emit. Coerced to character with
  [`as.character()`](https://rdrr.io/r/base/character.html).

## Value

`value`, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
output("row_count", nrow(df))
output("model_path", "/tmp/model.rds")
} # }
```
