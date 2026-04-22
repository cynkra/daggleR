test_that("archive_info() returns archive metadata", {
  httptest2::with_mock_dir("archive-info", {
    result <- archive_info("etl", run_id = "latest",
                           base_url = "http://127.0.0.1:8787")
    expect_type(result, "list")
    expect_named(result, c("path", "files", "bytes", "created_at"))
    expect_true(is.numeric(result$files))
    expect_true(is.numeric(result$bytes))
  })
})

test_that("verify_archive() surfaces all Report fields", {
  httptest2::with_mock_dir("archive-verify", {
    result <- verify_archive("etl", run_id = "latest",
                             base_url = "http://127.0.0.1:8787")
    expect_type(result, "list")
    expect_true(all(c("ok", "files", "mismatched", "missing", "extra") %in% names(result)))
    expect_true(result$ok)
  })
})

test_that("archive_run() streams a gzip file to dest", {
  fixture <- test_path("fixtures", "run.tar.gz")
  gz_bytes <- readBin(fixture, "raw", n = file.info(fixture)$size)

  info_resp <- httr2::response(
    status_code = 200L,
    headers = list("Content-Type" = "application/json"),
    body = charToRaw(jsonlite::toJSON(list(
      path = "/var/lib/daggle/archives/etl_run-abc123.tar.gz",
      files = 2L,
      bytes = length(gz_bytes),
      created_at = "2026-04-22T10:30:00Z"
    ), auto_unbox = TRUE))
  )
  archive_resp <- httr2::response(
    status_code = 200L,
    headers = list("Content-Type" = "application/gzip"),
    body = gz_bytes
  )

  responses <- list(info_resp, archive_resp)
  i <- 0L
  dest <- tempfile(fileext = ".tar.gz")
  on.exit(unlink(dest))

  httr2::with_mocked_responses(
    function(req) {
      i <<- i + 1L
      responses[[i]]
    },
    {
      path <- archive_run("etl", run_id = "latest", dest = dest,
                          base_url = "http://127.0.0.1:8787")
      expect_true(file.exists(path))
      expect_gt(file.info(path)$size, 0)
      expect_identical(readBin(path, "raw", n = 2L),
                       as.raw(c(0x1f, 0x8b)))
      expect_equal(i, 2L)
    }
  )
})
