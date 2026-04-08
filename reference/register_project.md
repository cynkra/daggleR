# Register a project

Register a project

## Usage

``` r
register_project(path, name = NULL, base_url = NULL)
```

## Arguments

- path:

  Character string. Absolute path to the project directory.

- name:

  Character string or `NULL`. Optional project name; defaults to the
  directory basename on the server side.

- base_url:

  Base URL of the daggle API. See Details.

## Value

A list with elements: `name`, `path`.
