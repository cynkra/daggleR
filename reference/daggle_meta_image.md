# Emit an image metadata reference

Reference an image file (PNG, SVG, PDF) as step metadata. The file
should be a declared artifact in the step's YAML definition.

## Usage

``` r
daggle_meta_image(name, path)
```

## Arguments

- name:

  Character string. Image name. Must match `[a-zA-Z_][a-zA-Z0-9_]*`.

- path:

  Character string. Path to the image file.

## Value

`path`, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
daggle_meta_image("residuals_plot", "output/residuals.png")
} # }
```
