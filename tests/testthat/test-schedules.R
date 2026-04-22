test_that("daggle_list_schedules() returns a data.frame", {
  httptest2::with_mock_dir("schedules", {
    result <- daggle_list_schedules("etl", base_url = "http://127.0.0.1:8787")
    expect_s3_class(result, "data.frame")
    expect_true(all(c("id", "cron", "source", "enabled", "next_run") %in% names(result)))
    expect_equal(nrow(result), 2)
  })
})

test_that("daggle_add_schedule() returns the created schedule", {
  httptest2::with_mock_dir("schedules-create", {
    result <- daggle_add_schedule(
      "etl",
      cron = "0 7 * * *",
      params = list(date = "2024-01-01"),
      base_url = "http://127.0.0.1:8787"
    )
    expect_type(result, "list")
    expect_equal(result$cron, "0 7 * * *")
    expect_equal(result$source, "runtime")
    expect_true(result$enabled)
  })
})

test_that("daggle_remove_schedule() returns TRUE invisibly", {
  httptest2::with_mock_dir("schedules-delete", {
    result <- daggle_remove_schedule(
      "etl",
      schedule_id = "sch-123",
      base_url = "http://127.0.0.1:8787"
    )
    expect_true(result)
  })
})

test_that("daggle_set_schedule_enabled() returns the updated schedule", {
  httptest2::with_mock_dir("schedules-patch", {
    result <- daggle_set_schedule_enabled(
      "etl",
      schedule_id = "sch-123",
      enabled = FALSE,
      base_url = "http://127.0.0.1:8787"
    )
    expect_type(result, "list")
    expect_equal(result$id, "sch-123")
    expect_false(result$enabled)
  })
})
