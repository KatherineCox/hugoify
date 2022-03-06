test_that("make_page raises error for not bundling a list page", {
  expect_error(make_page("list_no_bundle", is_list_page=TRUE, bundle=FALSE),
               regexp = "List pages must be bundles.")
})

test_that("make_page creates a directory if needed", {

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
  print(dir)
  make_page("no_params", output_dir = dir)
  expect_snapshot_file(file.path(dir, "no_params", "index.md"), name="no_params.md")

  # params sare written to the yaml header
  dir <- withr::local_tempdir()
  print(dir)
  make_page("yes_params", output_dir = dir,
            params=list(param1="first param", param2="second param") )
  expect_snapshot_file(file.path(dir, "yes_params", "index.md"), name="yes_params.md")
})

