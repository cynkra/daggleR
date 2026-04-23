# Changelog

## daggleR 0.5.0

### New features

- [`daggle_lint()`](https://cynkra.github.io/daggleR/reference/daggle_lint.md):
  shell-out wrapper around `daggle lint --format json`. Returns a
  data.frame of diagnostics (missing scripts, unresolvable secrets,
  unknown notification channels). Fits into CI and `goodpractice`-style
  composite checks. Optional `check_packages = TRUE` also verifies that
  R packages required by R-based step types are installed.

### Documentation

- README now shows a downstream-consumer example for the Phase 10
  `database:`, `email:`, and `docker:` step types. These are authored in
  YAML and executed by the daggle binary; their outputs are consumed
  from downstream R steps via
  [`daggle_get_output()`](https://cynkra.github.io/daggleR/reference/daggle_get_output.md).
- `_pkgdown.yml` reference index brought back in sync with exports:
  every entry uses the new `daggle_` prefix, and the previously missing
  schedule, archive, and `daggle_init_dag` functions are now grouped
  into their own sections.

## daggleR 0.4.0

### Breaking changes

All exported functions are now prefixed with `daggle_` to avoid
namespace collisions with popular packages (e.g. `future::plan()`,
generic verbs like `trigger()`, `health()`, `validation()`,
`cleanup()`). This mirrors the `targets::tar_*` convention.

Rename map:

- In-step helpers: `output()` →
  [`daggle_output()`](https://cynkra.github.io/daggleR/reference/daggle_output.md),
  `run_id()` →
  [`daggle_run_id()`](https://cynkra.github.io/daggleR/reference/daggle_run_id.md),
  `dag_name()` →
  [`daggle_dag_name()`](https://cynkra.github.io/daggleR/reference/daggle_dag_name.md),
  `run_dir()` →
  [`daggle_run_dir()`](https://cynkra.github.io/daggleR/reference/daggle_run_dir.md),
  `get_matrix()` →
  [`daggle_get_matrix()`](https://cynkra.github.io/daggleR/reference/daggle_get_matrix.md),
  `get_output()` →
  [`daggle_get_output()`](https://cynkra.github.io/daggleR/reference/daggle_get_output.md),
  `summary_md()` →
  [`daggle_summary_md()`](https://cynkra.github.io/daggleR/reference/daggle_summary_md.md),
  `meta_numeric()` →
  [`daggle_meta_numeric()`](https://cynkra.github.io/daggleR/reference/daggle_meta_numeric.md),
  `meta_text()` →
  [`daggle_meta_text()`](https://cynkra.github.io/daggleR/reference/daggle_meta_text.md),
  `meta_table()` →
  [`daggle_meta_table()`](https://cynkra.github.io/daggleR/reference/daggle_meta_table.md),
  `meta_image()` →
  [`daggle_meta_image()`](https://cynkra.github.io/daggleR/reference/daggle_meta_image.md),
  `validation()` →
  [`daggle_validation()`](https://cynkra.github.io/daggleR/reference/daggle_validation.md).
- API wrappers: `list_dags()` →
  [`daggle_list_dags()`](https://cynkra.github.io/daggleR/reference/daggle_list_dags.md),
  `get_dag()` →
  [`daggle_get_dag()`](https://cynkra.github.io/daggleR/reference/daggle_get_dag.md),
  `trigger()` →
  [`daggle_trigger()`](https://cynkra.github.io/daggleR/reference/daggle_trigger.md),
  `list_runs()` →
  [`daggle_list_runs()`](https://cynkra.github.io/daggleR/reference/daggle_list_runs.md),
  `get_run()` →
  [`daggle_get_run()`](https://cynkra.github.io/daggleR/reference/daggle_get_run.md),
  `get_outputs()` →
  [`daggle_get_outputs()`](https://cynkra.github.io/daggleR/reference/daggle_get_outputs.md),
  `get_step_log()` →
  [`daggle_get_step_log()`](https://cynkra.github.io/daggleR/reference/daggle_get_step_log.md),
  `cancel_run()` →
  [`daggle_cancel_run()`](https://cynkra.github.io/daggleR/reference/daggle_cancel_run.md),
  `approve()` →
  [`daggle_approve()`](https://cynkra.github.io/daggleR/reference/daggle_approve.md),
  `reject()` →
  [`daggle_reject()`](https://cynkra.github.io/daggleR/reference/daggle_reject.md),
  `list_projects()` →
  [`daggle_list_projects()`](https://cynkra.github.io/daggleR/reference/daggle_list_projects.md),
  `register_project()` →
  [`daggle_register_project()`](https://cynkra.github.io/daggleR/reference/daggle_register_project.md),
  `unregister_project()` →
  [`daggle_unregister_project()`](https://cynkra.github.io/daggleR/reference/daggle_unregister_project.md),
  `health()` →
  [`daggle_health()`](https://cynkra.github.io/daggleR/reference/daggle_health.md),
  `cleanup()` →
  [`daggle_cleanup()`](https://cynkra.github.io/daggleR/reference/daggle_cleanup.md),
  `list_artifacts()` →
  [`daggle_list_artifacts()`](https://cynkra.github.io/daggleR/reference/daggle_list_artifacts.md),
  `plan()` →
  [`daggle_plan()`](https://cynkra.github.io/daggleR/reference/daggle_plan.md),
  `get_summaries()` →
  [`daggle_get_summaries()`](https://cynkra.github.io/daggleR/reference/daggle_get_summaries.md),
  `get_metadata()` →
  [`daggle_get_metadata()`](https://cynkra.github.io/daggleR/reference/daggle_get_metadata.md),
  `get_validations()` →
  [`daggle_get_validations()`](https://cynkra.github.io/daggleR/reference/daggle_get_validations.md),
  `compare_runs()` →
  [`daggle_compare_runs()`](https://cynkra.github.io/daggleR/reference/daggle_compare_runs.md),
  `list_annotations()` →
  [`daggle_list_annotations()`](https://cynkra.github.io/daggleR/reference/daggle_list_annotations.md),
  `add_annotation()` →
  [`daggle_add_annotation()`](https://cynkra.github.io/daggleR/reference/daggle_add_annotation.md),
  `get_impact()` →
  [`daggle_get_impact()`](https://cynkra.github.io/daggleR/reference/daggle_get_impact.md),
  `list_schedules()` →
  [`daggle_list_schedules()`](https://cynkra.github.io/daggleR/reference/daggle_list_schedules.md),
  `add_schedule()` →
  [`daggle_add_schedule()`](https://cynkra.github.io/daggleR/reference/daggle_add_schedule.md),
  `remove_schedule()` →
  [`daggle_remove_schedule()`](https://cynkra.github.io/daggleR/reference/daggle_remove_schedule.md),
  `set_schedule_enabled()` →
  [`daggle_set_schedule_enabled()`](https://cynkra.github.io/daggleR/reference/daggle_set_schedule_enabled.md),
  `archive_info()` →
  [`daggle_archive_info()`](https://cynkra.github.io/daggleR/reference/daggle_archive_info.md),
  `verify_archive()` →
  [`daggle_verify_archive()`](https://cynkra.github.io/daggleR/reference/daggle_verify_archive.md),
  `archive_run()` →
  [`daggle_archive_run()`](https://cynkra.github.io/daggleR/reference/daggle_archive_run.md).
- Other: `init_dag()` →
  [`daggle_init_dag()`](https://cynkra.github.io/daggleR/reference/daggle_init_dag.md),
  `cli_version()` →
  [`daggle_cli_version()`](https://cynkra.github.io/daggleR/reference/daggle_cli_version.md).

Internal helpers
([`resolve_base_url()`](https://cynkra.github.io/daggleR/reference/resolve_base_url.md),
[`daggle_request()`](https://cynkra.github.io/daggleR/reference/daggle_request.md))
are unchanged and remain unexported.
