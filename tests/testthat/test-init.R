test_that("init_dag() writes .daggle/<name>.yaml and creates .daggle/ if missing", {
  skip_if_not_installed("yaml")
  withr::with_tempdir({
    path <- init_dag("demo", template = "minimal")
    expect_true(file.exists(path))
    expect_true(dir.exists(".daggle"))
    expect_equal(basename(path), "demo.yaml")
    parsed <- yaml::read_yaml(path)
    expect_equal(parsed$name, "demo")
  })
})

test_that("init_dag() all four templates produce parseable YAML", {
  skip_if_not_installed("yaml")
  withr::with_tempdir({
    for (tpl in c("minimal", "data-pipeline", "pkg-check", "pkg-release")) {
      name <- paste0("t-", tpl)
      path <- init_dag(name, template = tpl)
      parsed <- yaml::read_yaml(path)
      expect_equal(parsed$name, name, info = tpl)
    }
  })
})

test_that("init_dag() errors when file exists and overwrite = FALSE", {
  withr::with_tempdir({
    init_dag("demo", template = "minimal")
    expect_error(
      init_dag("demo", template = "minimal"),
      "already exists"
    )
  })
})

test_that("init_dag(overwrite = TRUE) replaces an existing file", {
  skip_if_not_installed("yaml")
  withr::with_tempdir({
    init_dag("demo", template = "minimal")
    path <- init_dag("demo", template = "pkg-check", overwrite = TRUE)
    parsed <- yaml::read_yaml(path)
    expect_true("steps" %in% names(parsed))
    step_ids <- vapply(parsed$steps, function(s) s$id, character(1))
    expect_true("document" %in% step_ids)
  })
})

test_that("init_dag() rejects invalid names", {
  withr::with_tempdir({
    expect_error(init_dag("", template = "minimal"), "non-empty")
    expect_error(init_dag("foo/bar", template = "minimal"), "must not contain")
    expect_error(init_dag(".hidden", template = "minimal"), "start with")
    expect_error(init_dag(c("a", "b"), template = "minimal"), "non-empty")
  })
})

test_that("init_dag() returns an absolute path invisibly", {
  withr::with_tempdir({
    path <- init_dag("demo", template = "minimal")
    expect_true(length(path) == 1L)
    expect_true(startsWith(path, normalizePath(getwd())))
  })
})
