test_that("resolve_base_url() uses explicit parameter first", {
  withr::local_envvar(DAGGLE_API_URL = "http://from-env:9999")
  expect_equal(resolve_base_url("http://explicit:1234"), "http://explicit:1234")
})

test_that("resolve_base_url() falls back to env var", {
  withr::local_envvar(DAGGLE_API_URL = "http://from-env:9999")
  expect_equal(resolve_base_url(), "http://from-env:9999")
})

test_that("resolve_base_url() uses default when nothing set", {
  withr::local_envvar(DAGGLE_API_URL = NA)
  expect_equal(resolve_base_url(), "http://127.0.0.1:9090")
})

test_that("resolve_base_url() strips trailing slashes", {
  expect_equal(resolve_base_url("http://example.com/"), "http://example.com")
  expect_equal(resolve_base_url("http://example.com///"), "http://example.com")

  withr::local_envvar(DAGGLE_API_URL = "http://from-env:9999/")
  expect_equal(resolve_base_url(), "http://from-env:9999")
})

test_that("cli_version() errors when daggle is not on PATH", {
  withr::local_path("/nonexistent", action = "replace")
  expect_error(cli_version(), "daggle CLI not found")
})

test_that("daggle_request() GET with simplify returns data.frame", {
  httptest2::with_mock_dir("dags", {
    res <- daggle_request(
      c("api", "v1", "dags"),
      simplify = TRUE,
      base_url = "http://127.0.0.1:8787"
    )
    expect_s3_class(res, "data.frame")
    expect_equal(nrow(res), 2)
  })
})

test_that("daggle_request() GET without simplify returns list", {
  httptest2::with_mock_dir("dag-detail", {
    res <- daggle_request(
      c("api", "v1", "dags", "etl"),
      base_url = "http://127.0.0.1:8787"
    )
    expect_type(res, "list")
    expect_equal(res$name, "etl")
  })
})

test_that("daggle_request() POST with body serialises JSON and returns response", {
  httptest2::with_mock_dir("cleanup", {
    res <- daggle_request(
      c("api", "v1", "runs", "cleanup"),
      method = "POST",
      body = list(older_than = "30d"),
      base_url = "http://127.0.0.1:8787"
    )
    expect_type(res, "list")
    expect_equal(res$removed, 5)
  })
})

test_that("daggle_request() DELETE hits the right endpoint", {
  httptest2::with_mock_dir("unregister-project", {
    res <- daggle_request(
      c("api", "v1", "projects", "old-project"),
      method = "DELETE",
      base_url = "http://127.0.0.1:8787"
    )
    expect_type(res, "list")
    expect_equal(res$name, "old-project")
  })
})

test_that("daggle_request() drops NULL query params", {
  httptest2::with_mock_dir("phase8-api", {
    res <- daggle_request(
      c("api", "v1", "dags"),
      query = list(tag = "etl", team = "data", owner = NULL),
      simplify = TRUE,
      base_url = "http://127.0.0.1:8787"
    )
    expect_s3_class(res, "data.frame")
    expect_equal(nrow(res), 2)
  })
})

test_that("daggle_request() validates method", {
  expect_error(
    daggle_request(c("api", "v1", "dags"), method = "PUT"),
    "should be one of"
  )
})
