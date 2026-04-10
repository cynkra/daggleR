test_that("summary_md emits correct marker", {
  out <- capture.output(summary_md("# Hello"))
  expect_match(out, "^::daggle-summary format=markdown::# Hello$")
})

test_that("meta_numeric emits correct marker", {
  out <- capture.output(meta_numeric("row_count", 42))
  expect_match(out, "^::daggle-meta type=numeric name=row_count::42$")
})

test_that("meta_text emits correct marker", {
  out <- capture.output(meta_text("model", "lm"))
  expect_match(out, "^::daggle-meta type=text name=model::lm$")
})

test_that("meta_table emits JSON", {
  skip_if_not_installed("jsonlite")
  df <- data.frame(x = 1:2, y = c("a", "b"))
  out <- capture.output(meta_table("top", df))
  expect_match(out, "^::daggle-meta type=table name=top::")
  # Verify JSON is parseable
  json_part <- sub("^::daggle-meta type=table name=top::", "", out)
  parsed <- jsonlite::fromJSON(json_part)
  expect_equal(nrow(parsed), 2)
})

test_that("meta_image emits correct marker", {
  out <- capture.output(meta_image("plot", "output/fig.png"))
  expect_match(out, "^::daggle-meta type=image name=plot::output/fig.png$")
})

test_that("validation emits correct marker", {
  out <- capture.output(validation("schema", "pass", "All columns valid"))
  expect_match(out, "^::daggle-validation status=pass name=schema::All columns valid$")
})

test_that("validation matches status argument", {
  expect_error(validation("x", "invalid"), "should be one of")
})

test_that("meta_numeric rejects invalid name", {
  expect_error(meta_numeric("123bad", 1), "Invalid metadata name")
})

test_that("validation rejects invalid name", {
  expect_error(validation("123bad", "pass", "msg"), "Invalid validation name")
})

test_that("summary_md returns invisibly", {
  expect_invisible(summary_md("test"))
})
