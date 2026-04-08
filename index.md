> **Note:** This package is experimental and under active development.
> The API may change without notice.

Companion R package for [daggle](https://github.com/cynkra/daggle), a
lightweight DAG scheduler for R.

## Installation

``` r
# install.packages("pak")
pak::pak("cynkra/daggleR")
```

## Usage

### In-step helpers

These functions are used inside R steps executed by daggle. They require
no network access and no daggle binary.

``` r
# Emit an output that downstream steps can read
daggleR::output("row_count", nrow(df))

# Read metadata about the current run
daggleR::run_id()
daggleR::dag_name()
daggleR::run_dir()

# Read an output from a completed upstream step
accuracy <- daggleR::get_output("fit-lda", "accuracy")

# Read a matrix parameter (for matrix steps)
region <- daggleR::get_matrix("region")
```

### API wrappers

These functions talk to a running daggle API server (`daggle serve`).

``` r
# List all DAGs
daggleR::list_dags()

# Trigger a run
daggleR::trigger("etl", params = list(date = "2024-01-01"))

# Check run status
daggleR::get_run("etl", run_id = "latest")

# Get outputs from a run
daggleR::get_outputs("etl", run_id = "latest")

# View step logs
daggleR::get_step_log("etl", run_id = "run-001", step_id = "extract")

# Approval gates
daggleR::approve("etl", run_id = "run-001", step_id = "deploy")
daggleR::reject("etl", run_id = "run-001", step_id = "deploy")

# Health check
daggleR::health()
```

### Project management

``` r
# List registered projects
daggleR::list_projects()

# Register a project
daggleR::register_project("/path/to/my-project")

# Unregister a project
daggleR::unregister_project("my-project")
```

### Base URL configuration

API functions resolve the base URL in this order:

1.  Explicit `base_url` parameter
2.  `DAGGLE_API_URL` environment variable
3.  Default: `http://127.0.0.1:9090`

``` r
# Use a custom URL
daggleR::list_dags(base_url = "http://daggle.internal:9090")

# Or set via environment variable
Sys.setenv(DAGGLE_API_URL = "http://daggle.internal:9090")
daggleR::list_dags()
```

## License

GPL-3
