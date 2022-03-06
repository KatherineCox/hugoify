#TODO: build_hugo_source - confirm that we can specify config_file

test_that("build_hugo_source generates a content directory", {

  withr::with_tempdir({
    config_file <- "hugoify.yml"
    yaml <- paste("---", "content:", "config: c", "theme: t", "---", sep="\n")
    writeLines(yaml, config_file)

    build_hugo_source(config_file)
    expect_true( dir.exists("content") )
  })

  # directory should still be named "content", even if hugoify.yml called it "home"
  withr::with_tempdir({
    config_file <- "hugoify.yml"
    yaml <- paste("---", "home:", "config: c", "theme: t", "---", sep="\n")
    writeLines(yaml, config_file)

    build_hugo_source(config_file)
    expect_true( dir.exists("content") )
  })

})
