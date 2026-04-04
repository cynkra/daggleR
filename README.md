# daggle

Companion R package for [daggle](https://github.com/cynkra/daggle), a lightweight DAG scheduler for R.

## Installation

```r
# install.packages("pak")
pak::pak("cynkra/daggle-r")
```

## Usage

### In-step helpers

These functions are used inside R steps executed by daggle. They require no network access and no daggle binary.

```r
# Emit an output that downstream steps can read
daggle::output("row_count", nrow(df))

# Read metadata about the current run
daggle::run_id()
daggle::dag_name()
daggle::run_dir()

# Read an output from a completed upstream step
accuracy <- daggle::get_output("fit-lda", "accuracy")
```

### API wrappers

These functions talk to a running daggle API server (`daggle serve --port 8787`).

```r
# List all DAGs
daggle::list_dags()

# Trigger a run
daggle::trigger("etl", params = list(date = "2024-01-01"))

# Check run status
daggle::get_run("etl", run_id = "latest")

# Get outputs from a run
daggle::get_outputs("etl", run_id = "latest")

# View step logs
daggle::get_step_log("etl", run_id = "run-001", step_id = "extract")

# Approval gates
daggle::approve("etl", run_id = "run-001", step_id = "deploy")
daggle::reject("etl", run_id = "run-001", step_id = "deploy")

# Health check
daggle::health()
```

### Base URL configuration

API functions resolve the base URL in this order:

1. Explicit `base_url` parameter
2. `DAGGLE_API_URL` environment variable
3. Default: `http://127.0.0.1:8787`

```r
# Use a custom URL
daggle::list_dags(base_url = "http://daggle.internal:9090")

# Or set via environment variable
Sys.setenv(DAGGLE_API_URL = "http://daggle.internal:9090")
daggle::list_dags()
```

## License

GPL-3
