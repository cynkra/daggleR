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
