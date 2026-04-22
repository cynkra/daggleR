test_that("daggle_output() writes correct marker to stdout", {
  out <- capture.output(daggle_output("foo", "bar"))
  expect_equal(out, "::daggle-output name=foo::bar")
})

test_that("daggle_output() coerces numeric values", {
  out <- capture.output(daggle_output("count", 42))
  expect_equal(out, "::daggle-output name=count::42")
})

test_that("daggle_output() returns value invisibly", {
  expect_invisible(daggle_output("x", "y"))
  out <- capture.output(val <- daggle_output("x", "y"))
  expect_equal(val, "y")
})

test_that("daggle_output() rejects invalid key names", {
  expect_error(daggle_output("123bad", "val"), "Invalid output name")
  expect_error(daggle_output("has space", "val"), "Invalid output name")
  expect_error(daggle_output("has-hyphen", "val"), "Invalid output name")
  expect_error(daggle_output("", "val"), "Invalid output name")
})

test_that("daggle_output() accepts valid key names", {
  out <- capture.output(daggle_output("_private", "val"))
  expect_equal(out, "::daggle-output name=_private::val")

  out <- capture.output(daggle_output("camelCase123", "val"))
  expect_equal(out, "::daggle-output name=camelCase123::val")
})

test_that("daggle_run_id() reads DAGGLE_RUN_ID", {
  withr::local_envvar(DAGGLE_RUN_ID = "abc-123")
  expect_equal(daggle_run_id(), "abc-123")
})

test_that("daggle_run_id() returns empty string when unset", {
  withr::local_envvar(DAGGLE_RUN_ID = NA)
  expect_equal(daggle_run_id(), "")
})

test_that("daggle_dag_name() reads DAGGLE_DAG_NAME", {
  withr::local_envvar(DAGGLE_DAG_NAME = "my-pipeline")
  expect_equal(daggle_dag_name(), "my-pipeline")
})

test_that("daggle_run_dir() reads DAGGLE_RUN_DIR", {
  withr::local_envvar(DAGGLE_RUN_DIR = "/tmp/runs/abc")
  expect_equal(daggle_run_dir(), "/tmp/runs/abc")
})

test_that("daggle_get_matrix() reads correct env var", {
  withr::local_envvar(DAGGLE_MATRIX_REGION = "us-east-1")
  expect_equal(daggle_get_matrix("region"), "us-east-1")
  expect_equal(daggle_get_matrix("REGION"), "us-east-1")
})

test_that("daggle_get_matrix() returns empty string when unset", {
  withr::local_envvar(DAGGLE_MATRIX_MISSING = NA)
  expect_equal(daggle_get_matrix("missing"), "")
})

test_that("daggle_get_output() reads correct env var", {
  withr::local_envvar(DAGGLE_OUTPUT_FIT_LDA_ACCURACY = "0.95")
  expect_equal(daggle_get_output("fit-lda", "accuracy"), "0.95")
})

test_that("daggle_get_output() handles simple step names", {
  withr::local_envvar(DAGGLE_OUTPUT_EXTRACT_ROW_COUNT = "42")
  expect_equal(daggle_get_output("extract", "row_count"), "42")
})

test_that("daggle_get_output() returns empty string for missing output", {
  withr::local_envvar(DAGGLE_OUTPUT_MISSING_KEY = NA)
  expect_equal(daggle_get_output("missing", "key"), "")
})
