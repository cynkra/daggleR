# Emit a markdown summary for the current step

Write a markdown summary to stdout that daggle captures and stores as a
per-step summary file. Viewable via the API.

## Usage

``` r
summary_md(text)
```

## Arguments

- text:

  Character string. Markdown-formatted summary text.

## Value

`text`, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
summary_md("## Results\n- 1542 rows processed\n- 3 outliers found")
} # }
```
