# daggleR 0.4.0

## Breaking changes

All exported functions are now prefixed with `daggle_` to avoid namespace
collisions with popular packages (e.g. `future::plan()`, generic verbs like
`trigger()`, `health()`, `validation()`, `cleanup()`). This mirrors the
`targets::tar_*` convention.

Rename map:

- In-step helpers: `output()` → `daggle_output()`, `run_id()` → `daggle_run_id()`,
  `dag_name()` → `daggle_dag_name()`, `run_dir()` → `daggle_run_dir()`,
  `get_matrix()` → `daggle_get_matrix()`, `get_output()` → `daggle_get_output()`,
  `summary_md()` → `daggle_summary_md()`, `meta_numeric()` → `daggle_meta_numeric()`,
  `meta_text()` → `daggle_meta_text()`, `meta_table()` → `daggle_meta_table()`,
  `meta_image()` → `daggle_meta_image()`, `validation()` → `daggle_validation()`.
- API wrappers: `list_dags()` → `daggle_list_dags()`, `get_dag()` → `daggle_get_dag()`,
  `trigger()` → `daggle_trigger()`, `list_runs()` → `daggle_list_runs()`,
  `get_run()` → `daggle_get_run()`, `get_outputs()` → `daggle_get_outputs()`,
  `get_step_log()` → `daggle_get_step_log()`, `cancel_run()` → `daggle_cancel_run()`,
  `approve()` → `daggle_approve()`, `reject()` → `daggle_reject()`,
  `list_projects()` → `daggle_list_projects()`,
  `register_project()` → `daggle_register_project()`,
  `unregister_project()` → `daggle_unregister_project()`,
  `health()` → `daggle_health()`, `cleanup()` → `daggle_cleanup()`,
  `list_artifacts()` → `daggle_list_artifacts()`, `plan()` → `daggle_plan()`,
  `get_summaries()` → `daggle_get_summaries()`,
  `get_metadata()` → `daggle_get_metadata()`,
  `get_validations()` → `daggle_get_validations()`,
  `compare_runs()` → `daggle_compare_runs()`,
  `list_annotations()` → `daggle_list_annotations()`,
  `add_annotation()` → `daggle_add_annotation()`,
  `get_impact()` → `daggle_get_impact()`,
  `list_schedules()` → `daggle_list_schedules()`,
  `add_schedule()` → `daggle_add_schedule()`,
  `remove_schedule()` → `daggle_remove_schedule()`,
  `set_schedule_enabled()` → `daggle_set_schedule_enabled()`,
  `archive_info()` → `daggle_archive_info()`,
  `verify_archive()` → `daggle_verify_archive()`,
  `archive_run()` → `daggle_archive_run()`.
- Other: `init_dag()` → `daggle_init_dag()`, `cli_version()` → `daggle_cli_version()`.

Internal helpers (`resolve_base_url()`, `daggle_request()`) are unchanged and
remain unexported.
