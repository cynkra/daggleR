httptest2::with_mock_dir("phase7-api", {
  test_that("list_artifacts returns data.frame", {
    res <- list_artifacts("test-dag", "latest", base_url = "http://127.0.0.1:8787")
    expect_s3_class(res, "data.frame")
    expect_true(all(c("step_id", "name", "path", "hash", "size") %in% names(res)))
  })

  test_that("plan returns data.frame", {
    res <- plan("test-dag", base_url = "http://127.0.0.1:8787")
    expect_s3_class(res, "data.frame")
    expect_true(all(c("step_id", "status", "reason") %in% names(res)))
  })

  test_that("get_summaries returns data.frame", {
    res <- get_summaries("test-dag", "latest", base_url = "http://127.0.0.1:8787")
    expect_s3_class(res, "data.frame")
    expect_true(all(c("step_id", "format", "content") %in% names(res)))
  })

  test_that("get_metadata returns data.frame", {
    res <- get_metadata("test-dag", "latest", base_url = "http://127.0.0.1:8787")
    expect_s3_class(res, "data.frame")
    expect_true(all(c("step_id", "name", "type", "value") %in% names(res)))
  })

  test_that("get_validations returns data.frame", {
    res <- get_validations("test-dag", "latest", base_url = "http://127.0.0.1:8787")
    expect_s3_class(res, "data.frame")
    expect_true(all(c("step_id", "name", "status", "message") %in% names(res)))
  })

  test_that("compare_runs returns list", {
    res <- compare_runs("test-dag", "run1", "run2", base_url = "http://127.0.0.1:8787")
    expect_type(res, "list")
    expect_true(all(c("outputs_diff", "duration_diff", "meta_diff") %in% names(res)))
  })
})
