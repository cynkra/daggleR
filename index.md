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

### In-step helpers (12 functions)

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

# Emit a markdown summary for the step
daggleR::summary_md("## Results\n- 1542 rows processed")

# Emit typed metadata
daggleR::meta_numeric("row_count", nrow(df))
daggleR::meta_text("model_type", "linear regression")
daggleR::meta_table("top5", head(results, 5))
daggleR::meta_image("residuals_plot", "output/residuals.png")

# Emit validation results
daggleR::validation("row_count", "pass", "Expected > 0, got 1542")
daggleR::validation("schema", "fail", "Column 'date' expected date, got character")
```

### API wrappers (26 functions)

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

# Show execution plan with cache status
daggleR::plan("etl")

# List artifacts, summaries, metadata, and validations
daggleR::list_artifacts("etl", run_id = "latest")
daggleR::get_summaries("etl", run_id = "latest")
daggleR::get_metadata("etl", run_id = "latest")
daggleR::get_validations("etl", run_id = "latest")

# Compare two runs
daggleR::compare_runs("etl", run1 = "run-001", run2 = "run-002")

# Filter DAGs by ownership metadata
daggleR::list_dags(tag = "etl", team = "data")

# See who depends on this DAG
impact <- daggleR::get_impact("etl")
impact$downstream_dags
impact$exposures

# Attach a post-mortem note to a run
daggleR::add_annotation("etl", "run-001", "DB was down - manual restart at 08:30")
daggleR::list_annotations("etl", "run-001")

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
