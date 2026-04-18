httptest2::with_mock_dir("phase8-api", {
  test_that("list_annotations returns data.frame", {
    res <- list_annotations("test-dag", "latest", base_url = "http://127.0.0.1:8787")
    expect_s3_class(res, "data.frame")
    expect_true(all(c("timestamp", "author", "note") %in% names(res)))
  })

  test_that("add_annotation POSTs JSON body and returns response", {
    res <- add_annotation(
      "test-dag", "run123",
      note = "restarted manually",
      author = "alice",
      base_url = "http://127.0.0.1:8787"
    )
    expect_type(res, "list")
    expect_equal(res$status, "ok")
  })

  test_that("add_annotation falls back to Sys.getenv('USER') when author missing", {
    withr::with_envvar(list(USER = "bob"), {
      res <- add_annotation(
        "test-dag", "run123",
        note = "no author given",
        base_url = "http://127.0.0.1:8787"
      )
      expect_type(res, "list")
      expect_equal(res$author, "bob")
    })
  })

  test_that("get_impact returns list with downstream_dags and exposures", {
    res <- get_impact("test-dag", base_url = "http://127.0.0.1:8787")
    expect_type(res, "list")
    expect_true(all(c("dag", "downstream_dags", "exposures") %in% names(res)))
    expect_s3_class(res$downstream_dags, "data.frame")
    expect_s3_class(res$exposures, "data.frame")
  })

  test_that("list_dags passes filter params as query string", {
    res <- list_dags(tag = "etl", team = "data", base_url = "http://127.0.0.1:8787")
    expect_s3_class(res, "data.frame")
    expect_true(all(c("name", "owner", "team") %in% names(res)))
  })
})
