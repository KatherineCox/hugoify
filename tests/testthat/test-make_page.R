test_that("make_page raises error for not bundling a list page", {
  expect_error(make_page("list_no_bundle", is_list_page=TRUE, bundle=FALSE),
               regexp = "List pages must be bundles.")
})

test_that("make_page creates a bundle directory if needed", {

  withr::with_tempdir({
    make_page("yes_bundle")
    expect_true( dir.exists("yes_bundle") )
  })

  withr::with_tempdir({
    make_page("no_bundle", bundle=FALSE)
    expect_false( dir.exists("no_bundle") )
  })

})

test_that("make_page creates a file with the correct name and location", {

  # if it's a bundle, expect an index.md inside the bundle directory
  withr::with_tempdir({
    make_page("yes_bundle")
    expect_true( file.exists( file.path("yes_bundle", "index.md") ) )
  })

  # if it's not a bundle, expect a named md file
  withr::with_tempdir({
    make_page("no_bundle", bundle=FALSE)
    expect_true( file.exists("no_bundle.md") )
  })

  # if it's a list page, expect an _index.md inside the bundle directory
  withr::with_tempdir({
    make_page("list", is_list_page=TRUE)
    expect_true( file.exists( file.path("list", "_index.md") ) )
  })

})

test_that("make_page respects output_dir", {

})

test_that("make_page handles page params", {

  # no params should have empty yaml header
  dir <- withr::local_tempdir()
  make_page("params_no", output_dir = dir)
  expect_snapshot_file(file.path(dir, "params_no", "index.md"), name="params_no.md")

  # params are written to the yaml header
  dir <- withr::local_tempdir()
  make_page("params_yes", output_dir = dir,
            params=list(param1="first param", param2="second param") )
  expect_snapshot_file(file.path(dir, "params_yes", "index.md"), name="params_yes.md")
})

test_that("make_page handles page content", {

  # no content should have empty body
  dir <- withr::local_tempdir()
  make_page("content_no", output_dir = dir)
  expect_snapshot_file(file.path(dir, "content_no", "index.md"), name="content_no.md")

  # content is written to the body
  dir <- withr::local_tempdir()
  make_page("content_yes", output_dir = dir,
            content="This page was written by make_page()." )
  expect_snapshot_file(file.path(dir, "content_yes", "index.md"), name="content_yes.md")
})

test_that("make_test_page produces expected output", {
#   # make_test_page is a wrapper for make_page
#   # no need for extensive testing, just capture a snapshot
#   dir <- withr::local_tempdir()
#   make_test_page("default_test_page", output_dir = dir,)
#   expect_snapshot_file(file.path(dir, "default_test_page", "index.md"), name="default_test_page.md")
#
})

