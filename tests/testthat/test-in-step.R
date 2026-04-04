test_that("output() writes correct marker to stdout", {
  out <- capture.output(output("foo", "bar"))
  expect_equal(out, "::daggle-output name=foo::bar")
})

test_that("output() coerces numeric values", {
  out <- capture.output(output("count", 42))
  expect_equal(out, "::daggle-output name=count::42")
})

test_that("output() returns value invisibly", {
  expect_invisible(output("x", "y"))
  out <- capture.output(val <- output("x", "y"))
  expect_equal(val, "y")
})

test_that("output() rejects invalid key names", {
  expect_error(output("123bad", "val"), "Invalid output name")
  expect_error(output("has space", "val"), "Invalid output name")
  expect_error(output("has-hyphen", "val"), "Invalid output name")
  expect_error(output("", "val"), "Invalid output name")
})

test_that("output() accepts valid key names", {
  out <- capture.output(output("_private", "val"))
  expect_equal(out, "::daggle-output name=_private::val")

  out <- capture.output(output("camelCase123", "val"))
  expect_equal(out, "::daggle-output name=camelCase123::val")
})

test_that("run_id() reads DAGGLE_RUN_ID", {
  withr::local_envvar(DAGGLE_RUN_ID = "abc-123")
  expect_equal(run_id(), "abc-123")
})

test_that("run_id() returns empty string when unset", {
  withr::local_envvar(DAGGLE_RUN_ID = NA)
  expect_equal(run_id(), "")
})

test_that("dag_name() reads DAGGLE_DAG_NAME", {
  withr::local_envvar(DAGGLE_DAG_NAME = "my-pipeline")
  expect_equal(dag_name(), "my-pipeline")
})

test_that("run_dir() reads DAGGLE_RUN_DIR", {
  withr::local_envvar(DAGGLE_RUN_DIR = "/tmp/runs/abc")
  expect_equal(run_dir(), "/tmp/runs/abc")
})

test_that("get_output() reads correct env var", {
  withr::local_envvar(DAGGLE_OUTPUT_FIT_LDA_ACCURACY = "0.95")
  expect_equal(get_output("fit-lda", "accuracy"), "0.95")
})

test_that("get_output() handles simple step names", {
  withr::local_envvar(DAGGLE_OUTPUT_EXTRACT_ROW_COUNT = "42")
  expect_equal(get_output("extract", "row_count"), "42")
})

test_that("get_output() returns empty string for missing output", {
  withr::local_envvar(DAGGLE_OUTPUT_MISSING_KEY = NA)
  expect_equal(get_output("missing", "key"), "")
})
