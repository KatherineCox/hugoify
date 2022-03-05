# regarding withr functions:
# outer `with_dir` temporarily sets with working directory to it's first arg
# - this means that when we exist the test, wd will be set back to normal
# inner `local_tempdir` creates a temporary directory (which is now the working directory)
# - because this is created inside the enclosing with_dir call, I believe it gets deleted as soon as the outer with_dir call completes
# - regardless, a new temptdir is being created for each test
# - so, this prevents the tests from interfering with each other


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

})


# test_that("make_page creates a single, properly named markdown file if bundle=FALSE", {
#
#   dir <- withr::local_tempdir()
#   withr::local_dir(dir)
#
#   make_page("home", bundle=FALSE)
#   expect_true( file.exists( file.path(dir, "home.md") ) )
#   #TODO: snapshot
#
# })
#
# test_that("make_page creates a directory with an index.md file", {
#
#   dir <- withr::local_tempdir()
#   withr::local_dir(dir)
#
#   make_page("home")
#   expect_true( dir.exists( file.path(dir, "home") ) )
#   expect_true( file.exists( file.path(dir, "home", "index.md") ) )
#   #TODO snapshot
#
# })
