# Read an output from a completed upstream step

Reads the value of an output emitted by a completed upstream step via
the corresponding environment variable.

## Usage

``` r
get_output(step, key)
```

## Arguments

- step:

  Character string. The step ID (e.g., `"fit-lda"`).

- key:

  Character string. The output key name (e.g., `"accuracy"`).

## Value

Character string with the output value, or `""` if not set.

## Examples

``` r
if (FALSE) { # \dontrun{
accuracy <- get_output("fit-lda", "accuracy")
} # }
```
