# Emit a validation result

Emit a structured validation result that daggle captures and stores
per-step. Validation failures may cause the step to fail depending on
the step's `error_on` setting.

## Usage

``` r
daggle_validation(name, status = c("pass", "warn", "fail"), message = "")
```

## Arguments

- name:

  Character string. Validation check name.

- status:

  Character string. One of `"pass"`, `"warn"`, `"fail"`.

- message:

  Character string. Human-readable result description.

## Value

`status`, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
daggle_validation("row_count", "pass", "Expected > 0, got 1542")
daggle_validation("missing_pct", "warn", "12% missing (threshold: 20%)")
daggle_validation("schema", "fail", "Column 'date' expected date, got character")
} # }
```
