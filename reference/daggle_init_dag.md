# Scaffold a new DAG YAML under `.daggle/`

Creates `<dir>/.daggle/` if missing and writes
`<dir>/.daggle/<name>.yaml` from a built-in template. Useful for
bootstrapping a new DAG from an R session without leaving the IDE. This
mirrors the `daggle init <template>` CLI command.

## Usage

``` r
daggle_init_dag(
  name,
  template = c("minimal", "data-pipeline", "pkg-check", "pkg-release"),
  dir = getwd(),
  overwrite = FALSE
)
```

## Arguments

- name:

  Character string. Name for the DAG. Becomes the YAML file's basename
  (`.daggle/<name>.yaml`) and the value of the `name:` field in the
  generated YAML. Must not be empty and must not contain `/` or `\`.

- template:

  Template to scaffold. One of `"minimal"`, `"data-pipeline"`,
  `"pkg-check"`, or `"pkg-release"`.

- dir:

  Character string. Directory to create `.daggle/` inside. Defaults to
  the current working directory.

- overwrite:

  Logical. If `FALSE` (default), errors when the target file already
  exists. Set to `TRUE` to replace it.

## Value

The absolute path to the written YAML file, returned invisibly.

## See also

[`daggle_register_project()`](https://cynkra.github.io/daggleR/reference/daggle_register_project.md)
to register the project with the daggle daemon so newly scaffolded DAGs
become visible over the HTTP API.
