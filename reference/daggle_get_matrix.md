# Get a matrix parameter value

Reads the value of a matrix parameter for the current step. Matrix steps
receive `DAGGLE_MATRIX_<KEY>` environment variables with the key
uppercased.

## Usage

``` r
daggle_get_matrix(key)
```

## Arguments

- key:

  Character string. The matrix parameter name (e.g., `"region"`).

## Value

Character string with the matrix value, or `""` if not set.

## Examples

``` r
if (FALSE) { # \dontrun{
region <- daggle_get_matrix("region")
} # }
```
