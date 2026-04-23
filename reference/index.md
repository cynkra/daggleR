# Package index

## In-step helpers

Functions for use inside R steps executed by daggle. No network access
or daggle binary needed.

- [`daggle_output()`](https://cynkra.github.io/daggleR/reference/daggle_output.md)
  : Emit a daggle output marker
- [`daggle_run_id()`](https://cynkra.github.io/daggleR/reference/daggle_run_id.md)
  : Get the current daggle run ID
- [`daggle_dag_name()`](https://cynkra.github.io/daggleR/reference/daggle_dag_name.md)
  : Get the current DAG name
- [`daggle_run_dir()`](https://cynkra.github.io/daggleR/reference/daggle_run_dir.md)
  : Get the current run directory
- [`daggle_get_matrix()`](https://cynkra.github.io/daggleR/reference/daggle_get_matrix.md)
  : Get a matrix parameter value
- [`daggle_get_output()`](https://cynkra.github.io/daggleR/reference/daggle_get_output.md)
  : Read an output from a completed upstream step
- [`daggle_summary_md()`](https://cynkra.github.io/daggleR/reference/daggle_summary_md.md)
  : Emit a markdown summary for the current step
- [`daggle_meta_numeric()`](https://cynkra.github.io/daggleR/reference/daggle_meta_numeric.md)
  : Emit a numeric metadata value
- [`daggle_meta_text()`](https://cynkra.github.io/daggleR/reference/daggle_meta_text.md)
  : Emit a text metadata value
- [`daggle_meta_table()`](https://cynkra.github.io/daggleR/reference/daggle_meta_table.md)
  : Emit a table metadata value
- [`daggle_meta_image()`](https://cynkra.github.io/daggleR/reference/daggle_meta_image.md)
  : Emit an image metadata reference
- [`daggle_validation()`](https://cynkra.github.io/daggleR/reference/daggle_validation.md)
  : Emit a validation result

## DAG management

List and inspect DAGs.

- [`daggle_list_dags()`](https://cynkra.github.io/daggleR/reference/daggle_list_dags.md)
  : List all DAGs

- [`daggle_get_dag()`](https://cynkra.github.io/daggleR/reference/daggle_get_dag.md)
  : Get details for a single DAG

- [`daggle_plan()`](https://cynkra.github.io/daggleR/reference/daggle_plan.md)
  : Show execution plan with cache status

- [`daggle_get_impact()`](https://cynkra.github.io/daggleR/reference/daggle_get_impact.md)
  : Get downstream impact of a DAG

- [`daggle_init_dag()`](https://cynkra.github.io/daggleR/reference/daggle_init_dag.md)
  :

  Scaffold a new DAG YAML under `.daggle/`

## Run management

Trigger, inspect, and cancel DAG runs.

- [`daggle_trigger()`](https://cynkra.github.io/daggleR/reference/daggle_trigger.md)
  : Trigger a new DAG run
- [`daggle_list_runs()`](https://cynkra.github.io/daggleR/reference/daggle_list_runs.md)
  : List runs for a DAG
- [`daggle_get_run()`](https://cynkra.github.io/daggleR/reference/daggle_get_run.md)
  : Get details for a specific run
- [`daggle_get_outputs()`](https://cynkra.github.io/daggleR/reference/daggle_get_outputs.md)
  : Get outputs for a run
- [`daggle_get_step_log()`](https://cynkra.github.io/daggleR/reference/daggle_get_step_log.md)
  : Get log output for a step
- [`daggle_cancel_run()`](https://cynkra.github.io/daggleR/reference/daggle_cancel_run.md)
  : Cancel a running DAG run
- [`daggle_compare_runs()`](https://cynkra.github.io/daggleR/reference/daggle_compare_runs.md)
  : Compare two runs
- [`daggle_list_artifacts()`](https://cynkra.github.io/daggleR/reference/daggle_list_artifacts.md)
  : List artifacts for a run
- [`daggle_get_summaries()`](https://cynkra.github.io/daggleR/reference/daggle_get_summaries.md)
  : Get step summaries for a run
- [`daggle_get_metadata()`](https://cynkra.github.io/daggleR/reference/daggle_get_metadata.md)
  : Get step metadata for a run
- [`daggle_get_validations()`](https://cynkra.github.io/daggleR/reference/daggle_get_validations.md)
  : Get validation results for a run
- [`daggle_list_annotations()`](https://cynkra.github.io/daggleR/reference/daggle_list_annotations.md)
  : List annotations for a run
- [`daggle_add_annotation()`](https://cynkra.github.io/daggleR/reference/daggle_add_annotation.md)
  : Add an annotation to a run

## Approval gates

Approve or reject waiting steps.

- [`daggle_approve()`](https://cynkra.github.io/daggleR/reference/daggle_approve.md)
  : Approve a waiting step
- [`daggle_reject()`](https://cynkra.github.io/daggleR/reference/daggle_reject.md)
  : Reject a waiting step

## Schedules

List and manage runtime schedules.

- [`daggle_list_schedules()`](https://cynkra.github.io/daggleR/reference/daggle_list_schedules.md)
  : List schedules for a DAG
- [`daggle_add_schedule()`](https://cynkra.github.io/daggleR/reference/daggle_add_schedule.md)
  : Add a runtime schedule to a DAG
- [`daggle_remove_schedule()`](https://cynkra.github.io/daggleR/reference/daggle_remove_schedule.md)
  : Remove a runtime schedule from a DAG
- [`daggle_set_schedule_enabled()`](https://cynkra.github.io/daggleR/reference/daggle_set_schedule_enabled.md)
  : Enable or disable a schedule

## Archives

Create, verify, and download tamper-evident run archives.

- [`daggle_archive_info()`](https://cynkra.github.io/daggleR/reference/daggle_archive_info.md)
  : Create and describe a tamper-evident run archive
- [`daggle_verify_archive()`](https://cynkra.github.io/daggleR/reference/daggle_verify_archive.md)
  : Verify integrity of a run archive
- [`daggle_archive_run()`](https://cynkra.github.io/daggleR/reference/daggle_archive_run.md)
  : Download a tamper-evident run archive

## Project management

Register and unregister projects.

- [`daggle_list_projects()`](https://cynkra.github.io/daggleR/reference/daggle_list_projects.md)
  : List registered projects
- [`daggle_register_project()`](https://cynkra.github.io/daggleR/reference/daggle_register_project.md)
  : Register a project
- [`daggle_unregister_project()`](https://cynkra.github.io/daggleR/reference/daggle_unregister_project.md)
  : Unregister a project

## System

Health checks, cleanup, and diagnostics.

- [`daggle_health()`](https://cynkra.github.io/daggleR/reference/daggle_health.md)
  : Check API health

- [`daggle_cleanup()`](https://cynkra.github.io/daggleR/reference/daggle_cleanup.md)
  : Clean up old runs

- [`daggle_cli_version()`](https://cynkra.github.io/daggleR/reference/daggle_cli_version.md)
  : Get the daggle CLI version

- [`daggle_lint()`](https://cynkra.github.io/daggleR/reference/daggle_lint.md)
  :

  Run `daggle lint` on a DAG
