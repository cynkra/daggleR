test_that("list_dags() returns a data.frame", {
  httptest2::with_mock_dir("dags", {
    result <- list_dags(base_url = "http://127.0.0.1:8787")
    expect_s3_class(result, "data.frame")
    expect_named(result, c("name", "steps", "project", "schedule", "last_status", "last_run"))
    expect_equal(nrow(result), 2)
    expect_equal(result$project, c("my-project", "(global)"))
  })
})

test_that("get_dag() returns a list", {
  httptest2::with_mock_dir("dag-detail", {
    result <- get_dag("etl", base_url = "http://127.0.0.1:8787")
    expect_type(result, "list")
    expect_equal(result$name, "etl")
  })
})

test_that("trigger() returns run info", {
  httptest2::with_mock_dir("trigger", {
    result <- trigger("etl", params = list(date = "2024-01-01"),
                      base_url = "http://127.0.0.1:8787")
    expect_type(result, "list")
    expect_true("run_id" %in% names(result))
    expect_true("status" %in% names(result))
  })
})

test_that("list_runs() returns a data.frame", {
  httptest2::with_mock_dir("runs", {
    result <- list_runs("etl", base_url = "http://127.0.0.1:8787")
    expect_s3_class(result, "data.frame")
    expect_named(result, c("run_id", "started", "status", "duration_seconds", "dag_hash"))
  })
})

test_that("get_run() returns a list", {
  httptest2::with_mock_dir("run-detail", {
    result <- get_run("etl", run_id = "latest",
                      base_url = "http://127.0.0.1:8787")
    expect_type(result, "list")
    expect_true("run_id" %in% names(result))
    expect_true("status" %in% names(result))
  })
})

test_that("get_outputs() returns a data.frame", {
  httptest2::with_mock_dir("outputs", {
    result <- get_outputs("etl", run_id = "latest",
                          base_url = "http://127.0.0.1:8787")
    expect_s3_class(result, "data.frame")
    expect_named(result, c("step_id", "key", "value"))
  })
})

test_that("health() returns a list", {
  httptest2::with_mock_dir("health", {
    result <- health(base_url = "http://127.0.0.1:8787")
    expect_type(result, "list")
    expect_equal(result$status, "ok")
  })
})

test_that("cancel_run() returns a list", {
  httptest2::with_mock_dir("cancel", {
    result <- cancel_run("etl", run_id = "run-123",
                         base_url = "http://127.0.0.1:8787")
    expect_type(result, "list")
    expect_true("status" %in% names(result))
  })
})

test_that("list_projects() returns a data.frame", {
  httptest2::with_mock_dir("projects", {
    result <- list_projects(base_url = "http://127.0.0.1:8787")
    expect_s3_class(result, "data.frame")
    expect_named(result, c("name", "path", "status", "dags"))
    expect_equal(nrow(result), 2)
    expect_equal(result$name[1], "(global)")
  })
})

test_that("register_project() returns a list", {
  httptest2::with_mock_dir("register-project", {
    result <- register_project(
      path = "/home/user/new-project",
      base_url = "http://127.0.0.1:8787"
    )
    expect_type(result, "list")
    expect_equal(result$name, "new-project")
    expect_equal(result$path, "/home/user/new-project")
  })
})

test_that("unregister_project() returns a list", {
  httptest2::with_mock_dir("unregister-project", {
    result <- unregister_project("old-project",
                                 base_url = "http://127.0.0.1:8787")
    expect_type(result, "list")
    expect_equal(result$name, "old-project")
  })
})

test_that("cleanup() returns a list", {
  httptest2::with_mock_dir("cleanup", {
    result <- cleanup(older_than = "30d",
                      base_url = "http://127.0.0.1:8787")
    expect_type(result, "list")
    expect_true("removed" %in% names(result))
  })
})
