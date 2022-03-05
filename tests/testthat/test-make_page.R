# regarding withr functions:
# outer `with_dir` temporarily sets with working directory to it's first arg
# - this means that when we exist the test, wd will be set back to normal
# inner `local_tempdir` creates a temporary directory (which is now the working directory)
# - because this is created inside the enclosing with_dir call, I believe it gets deleted as soon as the outer with_dir call completes
# - regardless, a new temptdir is being created for each test
# - so, this prevents the tests from interfering with each other


test_that("make_page raises error for not bundling a list page", {
  expect_error(make_page("list_no_bundle", is_list_page=TRUE, bundle=FALSE),
               regexp = "List pages must be bundles.")
})

test_that("make_page creates a directory if needed", {

  withr::with_dir( withr::local_tempdir(), {
    make_page("yes_bundle")
    expect_true( dir.exists("yes_bundle") )
  })

  withr::with_dir( withr::local_tempdir(), {
    make_page("no_bundle", bundle=FALSE)
    expect_false( dir.exists("no_bundle") )
  })

})

test_that("make_page creates a file with the correct name and location", {

  # if it's a bundle, expect an index.md inside the bundle directory
  withr::with_dir( withr::local_tempdir(), {
    make_page("yes_bundle")
    expect_true( file.exists( file.path("yes_bundle", "index.md") ) )
  })

  # if it's not a bundle, expect a named md file
  withr::with_dir( withr::local_tempdir(), {
    make_page("no_bundle", bundle=FALSE)
    expect_true( file.exists("no_bundle.md") )
  })

  # if it's a list page, expect an _index.md inside the bundle directory
  withr::with_dir( withr::local_tempdir(), {
    make_page("list", is_list_page=TRUE)
    expect_true( file.exists( file.path("list", "_index.md") ) )
  })

})

test_that("make_page handles page params", {

  withr::with_dir( withr::local_tempdir(), {
    make_page("no_params")
    #TODO: snapshot
  })

  withr::with_dir( withr::local_tempdir(), {
    make_page("params", params=list(param1="first param", param2="second param"))
    #TODO: snapshot
  })

})

