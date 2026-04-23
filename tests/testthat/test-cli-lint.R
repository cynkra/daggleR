daggle_lint_supported <- function() {
  if (Sys.which("daggle") == "") return(FALSE)
  status <- suppressWarnings(
    system2("daggle", c("lint", "--help"), stdout = FALSE, stderr = FALSE)
  )
  identical(status, 0L)
}

test_that("daggle_lint handles the clean-DAG case", {
  skip_on_cran()
  skip_if_not(daggle_lint_supported(), "daggle CLI does not support `lint`")

  tmp <- tempfile(fileext = ".yaml")
  writeLines(
    c("name: t", "steps:", "  - id: hello", "    command: echo hi"),
    tmp
  )
  on.exit(unlink(tmp), add = TRUE)

  res <- daggle_lint(tmp)
  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), 0L)
})

test_that("daggle_lint surfaces a missing script as an error diagnostic", {
  skip_on_cran()
  skip_if_not(daggle_lint_supported(), "daggle CLI does not support `lint`")

  tmp <- tempfile(fileext = ".yaml")
  writeLines(
    c("name: t", "steps:", "  - id: s", "    script: nope.R"),
    tmp
  )
  on.exit(unlink(tmp), add = TRUE)

  res <- daggle_lint(tmp)
  expect_s3_class(res, "data.frame")
  expect_true(any(res$severity == "error"))
  expect_true(any(grepl("missing-script", res$code)))
})

test_that("daggle_lint fails loudly when the binary is missing", {
  expect_error(
    daggle_lint("x", daggle_bin = "/nonexistent/daggle"),
    regexp = "daggle lint failed"
  )
})
