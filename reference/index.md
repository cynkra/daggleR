# Package index

## In-step helpers

Functions for use inside R steps executed by daggle. No network access
or daggle binary needed.

- [`output()`](https://cynkra.github.io/daggleR/reference/output.md) :
  Emit a daggle output marker
- [`run_id()`](https://cynkra.github.io/daggleR/reference/run_id.md) :
  Get the current daggle run ID
- [`dag_name()`](https://cynkra.github.io/daggleR/reference/dag_name.md)
  : Get the current DAG name
- [`run_dir()`](https://cynkra.github.io/daggleR/reference/run_dir.md) :
  Get the current run directory
- [`get_matrix()`](https://cynkra.github.io/daggleR/reference/get_matrix.md)
  : Get a matrix parameter value
- [`get_output()`](https://cynkra.github.io/daggleR/reference/get_output.md)
  : Read an output from a completed upstream step

## DAG management

List and inspect DAGs.

- [`list_dags()`](https://cynkra.github.io/daggleR/reference/list_dags.md)
  : List all DAGs
- [`get_dag()`](https://cynkra.github.io/daggleR/reference/get_dag.md) :
  Get details for a single DAG

## Run management

Trigger, inspect, and cancel DAG runs.

- [`trigger()`](https://cynkra.github.io/daggleR/reference/trigger.md) :
  Trigger a new DAG run
- [`list_runs()`](https://cynkra.github.io/daggleR/reference/list_runs.md)
  : List runs for a DAG
- [`get_run()`](https://cynkra.github.io/daggleR/reference/get_run.md) :
  Get details for a specific run
- [`get_outputs()`](https://cynkra.github.io/daggleR/reference/get_outputs.md)
  : Get outputs for a run
- [`get_step_log()`](https://cynkra.github.io/daggleR/reference/get_step_log.md)
  : Get log output for a step
- [`cancel_run()`](https://cynkra.github.io/daggleR/reference/cancel_run.md)
  : Cancel a running DAG run

## Approval gates

Approve or reject waiting steps.

- [`approve()`](https://cynkra.github.io/daggleR/reference/approve.md) :
  Approve a waiting step
- [`reject()`](https://cynkra.github.io/daggleR/reference/reject.md) :
  Reject a waiting step

## Project management

Register and unregister projects.

- [`list_projects()`](https://cynkra.github.io/daggleR/reference/list_projects.md)
  : List registered projects
- [`register_project()`](https://cynkra.github.io/daggleR/reference/register_project.md)
  : Register a project
- [`unregister_project()`](https://cynkra.github.io/daggleR/reference/unregister_project.md)
  : Unregister a project

## System

Health checks, cleanup, and diagnostics.

- [`health()`](https://cynkra.github.io/daggleR/reference/health.md) :
  Check API health
- [`cleanup()`](https://cynkra.github.io/daggleR/reference/cleanup.md) :
  Clean up old runs
- [`cli_version()`](https://cynkra.github.io/daggleR/reference/cli_version.md)
  : Get the daggle CLI version
