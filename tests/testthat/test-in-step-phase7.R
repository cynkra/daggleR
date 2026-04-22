test_that("daggle_summary_md emits correct marker", {
  out <- capture.output(daggle_summary_md("# Hello"))
  expect_match(out, "^::daggle-summary format=markdown::# Hello$")
})

test_that("daggle_meta_numeric emits correct marker", {
  out <- capture.output(daggle_meta_numeric("row_count", 42))
  expect_match(out, "^::daggle-meta type=numeric name=row_count::42$")
})

test_that("daggle_meta_text emits correct marker", {
  out <- capture.output(daggle_meta_text("model", "lm"))
  expect_match(out, "^::daggle-meta type=text name=model::lm$")
})

test_that("daggle_meta_table emits JSON", {
  skip_if_not_installed("jsonlite")
  df <- data.frame(x = 1:2, y = c("a", "b"))
  out <- capture.output(daggle_meta_table("top", df))
  expect_match(out, "^::daggle-meta type=table name=top::")
  # Verify JSON is parseable
  json_part <- sub("^::daggle-meta type=table name=top::", "", out)
  parsed <- jsonlite::fromJSON(json_part)
  expect_equal(nrow(parsed), 2)
})

test_that("daggle_meta_image emits correct marker", {
  out <- capture.output(daggle_meta_image("plot", "output/fig.png"))
  expect_match(out, "^::daggle-meta type=image name=plot::output/fig.png$")
})

test_that("daggle_validation emits correct marker", {
  out <- capture.output(daggle_validation("schema", "pass", "All columns valid"))
  expect_match(out, "^::daggle-validation status=pass name=schema::All columns valid$")
})

test_that("daggle_validation matches status argument", {
  expect_error(daggle_validation("x", "invalid"), "should be one of")
})

test_that("daggle_meta_numeric rejects invalid name", {
  expect_error(daggle_meta_numeric("123bad", 1), "Invalid metadata name")
})

test_that("daggle_validation rejects invalid name", {
  expect_error(daggle_validation("123bad", "pass", "msg"), "Invalid validation name")
})

test_that("daggle_summary_md returns invisibly", {
  expect_invisible(daggle_summary_md("test"))
})
