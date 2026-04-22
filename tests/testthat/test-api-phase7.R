httptest2::with_mock_dir("phase7-api", {
  test_that("daggle_list_artifacts returns data.frame", {
    res <- daggle_list_artifacts("test-dag", "latest", base_url = "http://127.0.0.1:8787")
    expect_s3_class(res, "data.frame")
    expect_true(all(c("step_id", "name", "path", "hash", "size") %in% names(res)))
  })

  test_that("daggle_plan returns data.frame", {
    res <- daggle_plan("test-dag", base_url = "http://127.0.0.1:8787")
    expect_s3_class(res, "data.frame")
    expect_true(all(c("step_id", "status", "reason") %in% names(res)))
  })

  test_that("daggle_get_summaries returns data.frame", {
    res <- daggle_get_summaries("test-dag", "latest", base_url = "http://127.0.0.1:8787")
    expect_s3_class(res, "data.frame")
    expect_true(all(c("step_id", "format", "content") %in% names(res)))
  })

  test_that("daggle_get_metadata returns data.frame", {
    res <- daggle_get_metadata("test-dag", "latest", base_url = "http://127.0.0.1:8787")
    expect_s3_class(res, "data.frame")
    expect_true(all(c("step_id", "name", "type", "value") %in% names(res)))
  })

  test_that("daggle_get_validations returns data.frame", {
    res <- daggle_get_validations("test-dag", "latest", base_url = "http://127.0.0.1:8787")
    expect_s3_class(res, "data.frame")
    expect_true(all(c("step_id", "name", "status", "message") %in% names(res)))
  })

  test_that("daggle_compare_runs returns list", {
    res <- daggle_compare_runs("test-dag", "run1", "run2", base_url = "http://127.0.0.1:8787")
    expect_type(res, "list")
    expect_true(all(c("outputs_diff", "duration_diff", "meta_diff") %in% names(res)))
  })
})
