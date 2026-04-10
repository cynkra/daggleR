# Emit a text metadata value

Emit a text metadata value

## Usage

``` r
meta_text(name, value)
```

## Arguments

- name:

  Character string. Metadata key. Must match `[a-zA-Z_][a-zA-Z0-9_]*`.

- value:

  Character string. Metadata value.

## Value

`value`, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
meta_text("model_type", "linear regression")
} # }
```
