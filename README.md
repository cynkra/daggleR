# daggleR

> **Note:** This package is experimental and under active development. The API may change without notice.

Companion R package for [daggle](https://github.com/cynkra/daggle), a lightweight DAG scheduler for R.

## Installation

```r
# install.packages("pak")
pak::pak("cynkra/daggleR")
```

## Usage

All exported functions are prefixed with `daggle_` to avoid masking common verbs (e.g. `plan()`, `trigger()`, `health()`) that other packages also export.

### In-step helpers (12 functions)

These functions are used inside R steps executed by daggle. They require no network access and no daggle binary.

```r
# Emit an output that downstream steps can read
daggleR::daggle_output("row_count", nrow(df))

# Read metadata about the current run
daggleR::daggle_run_id()
daggleR::daggle_dag_name()
daggleR::daggle_run_dir()

# Read an output from a completed upstream step
accuracy <- daggleR::daggle_get_output("fit-lda", "accuracy")

# Read a matrix parameter (for matrix steps)
region <- daggleR::daggle_get_matrix("region")

# Emit a markdown summary for the step
daggleR::daggle_summary_md("## Results\n- 1542 rows processed")

# Emit typed metadata
daggleR::daggle_meta_numeric("row_count", nrow(df))
daggleR::daggle_meta_text("model_type", "linear regression")
daggleR::daggle_meta_table("top5", head(results, 5))
daggleR::daggle_meta_image("residuals_plot", "output/residuals.png")

# Emit validation results
daggleR::daggle_validation("row_count", "pass", "Expected > 0, got 1542")
daggleR::daggle_validation("schema", "fail", "Column 'date' expected date, got character")
```

### API wrappers (31 functions)

These functions talk to a running daggle API server (`daggle serve`).

```r
# List all DAGs
daggleR::daggle_list_dags()

# Trigger a run
daggleR::daggle_trigger("etl", params = list(date = "2024-01-01"))

# Check run status
daggleR::daggle_get_run("etl", run_id = "latest")

# Get outputs from a run
daggleR::daggle_get_outputs("etl", run_id = "latest")

# View step logs
daggleR::daggle_get_step_log("etl", run_id = "run-001", step_id = "extract")

# Approval gates
daggleR::daggle_approve("etl", run_id = "run-001", step_id = "deploy")
daggleR::daggle_reject("etl", run_id = "run-001", step_id = "deploy")

# Show execution plan with cache status
daggleR::daggle_plan("etl")

# List artifacts, summaries, metadata, and validations
daggleR::daggle_list_artifacts("etl", run_id = "latest")
daggleR::daggle_get_summaries("etl", run_id = "latest")
daggleR::daggle_get_metadata("etl", run_id = "latest")
daggleR::daggle_get_validations("etl", run_id = "latest")

# Compare two runs
daggleR::daggle_compare_runs("etl", run1 = "run-001", run2 = "run-002")

# Filter DAGs by ownership metadata
daggleR::daggle_list_dags(tag = "etl", team = "data")

# See who depends on this DAG
impact <- daggleR::daggle_get_impact("etl")
impact$downstream_dags
impact$exposures

# Attach a post-mortem note to a run
daggleR::daggle_add_annotation("etl", "run-001", "DB was down - manual restart at 08:30")
daggleR::daggle_list_annotations("etl", "run-001")

# Schedules
daggleR::daggle_list_schedules("etl")
daggleR::daggle_add_schedule("etl", cron = "0 7 * * *")
daggleR::daggle_set_schedule_enabled("etl", schedule_id = "sch-001", enabled = FALSE)
daggleR::daggle_remove_schedule("etl", schedule_id = "sch-001")

# Tamper-evident run archives
daggleR::daggle_archive_info("etl", run_id = "run-001")
daggleR::daggle_archive_run("etl", run_id = "run-001", dest = "run-001.tar.gz")
daggleR::daggle_verify_archive("etl", run_id = "run-001")

# Health check
daggleR::daggle_health()
```

### Consuming a `database:` / `email:` step type from R

daggle's `database:`, `email:`, and `docker:` step types are authored in YAML
and executed by the daggle binary — no R code is needed to invoke them. Their
outputs can be read from downstream R steps with the usual `daggle_get_output()`:

```yaml
# .daggle/report.yaml
name: daily-report
steps:
  - id: pull_orders
    database:
      driver: postgres
      params:
        dbname: analytics
        host: ${env:PGHOST}
        user: ${env:PGUSER}
        password: ${env:PGPASSWORD}
      query: SELECT * FROM orders WHERE created_at >= now() - interval '1 day'
      output: data/orders.csv

  - id: analyze
    depends: [pull_orders]
    script: R/analyze.R

  - id: send_report
    depends: [analyze]
    email:
      channel: team_smtp
      subject: "Daily orders — {{.Today}}"
      body: "{{.Params.summary}}"
      attach: [data/orders.csv]
```

```r
# R/analyze.R — downstream of the database step
library(daggleR)

# The database step exported the row count as an output
row_count <- as.integer(daggle_get_output("pull_orders", "row_count"))
message("Upstream fetched ", row_count, " orders")

orders <- read.csv("data/orders.csv")
# ...analysis...
daggle_output("status", if (nrow(orders) > 0) "ok" else "empty")
```

### Lint a DAG from R

`daggle_lint()` shells out to `daggle lint --format json` and returns a
data.frame of diagnostics (missing scripts, unresolvable secrets, unknown
notification channels, …). Fits into CI or `goodpractice`-style composite
checks.

```r
diagnostics <- daggleR::daggle_lint("etl-pipeline")
stopifnot(nrow(diagnostics[diagnostics$severity == "error", ]) == 0)
```

### Project management

```r
# List registered projects
daggleR::daggle_list_projects()

# Register a project
daggleR::daggle_register_project("/path/to/my-project")

# Unregister a project
daggleR::daggle_unregister_project("my-project")
```

### Scaffold a new DAG

```r
# Create .daggle/demo.yaml from a built-in template
daggleR::daggle_init_dag("demo", template = "minimal")
```

### Base URL configuration

API functions resolve the base URL in this order:

1. Explicit `base_url` parameter
2. `DAGGLE_API_URL` environment variable
3. Default: `http://127.0.0.1:9090`

```r
# Use a custom URL
daggleR::daggle_list_dags(base_url = "http://daggle.internal:9090")

# Or set via environment variable
Sys.setenv(DAGGLE_API_URL = "http://daggle.internal:9090")
daggleR::daggle_list_dags()
```

## License

GPL-3
