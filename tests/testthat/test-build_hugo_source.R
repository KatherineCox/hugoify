test_that("build_hugo_source raises error if 'page' is not a hugoify_page", {
  # error if not a page
  withr::with_tempdir({
    expect_error(build_hugo_source(1), regexp="'page' must be a 'hugoify_page' object")
  })

  # no error if it is a page
  withr::with_tempdir({
    p <- new_hugoify_page("my_page")
    expect_error(build_hugo_source(p), regexp=NA)
  })
})

test_that("build_hugo_source raises error for not bundling a list page", {
  withr::with_tempdir({
    p <- new_hugoify_page("my_page")
    expect_error(build_hugo_source(p, is_list_page=TRUE, bundle=FALSE),
                 regexp="List pages must be bundles.")
  })
})


test_that("build_hugo_source creates a bundle directory if needed", {

  withr::with_tempdir({
    p <- new_hugoify_page("yes_bundle")
    build_hugo_source(p)
    expect_true( dir.exists("yes_bundle") )
  })

  withr::with_tempdir({
    p <- new_hugoify_page("no_bundle")
    build_hugo_source(p, bundle=FALSE)
    expect_false( dir.exists("no_bundle") )
  })

})

test_that("build_hugo_source creates a file with the correct name and location", {

  # if it's a bundle, expect an index.md inside the bundle directory
  withr::with_tempdir({
    p <- new_hugoify_page("yes_bundle")
    build_hugo_source(p)
    expect_true( file.exists( file.path("yes_bundle", "index.md") ) )
  })

  # if it's not a bundle, expect a named md file
  withr::with_tempdir({
    p <- new_hugoify_page("no_bundle")
    build_hugo_source(p, bundle=FALSE)
    expect_true( file.exists("no_bundle.md") )
  })

  # if it's a list page, expect an _index.md inside the bundle directory
  withr::with_tempdir({
    p <- new_hugoify_page("list")
    build_hugo_source(p, is_list_page=TRUE)
    expect_true( file.exists( file.path("list", "_index.md") ) )
  })

})

test_that("build_hugo_source sanitizes page names", {

  # spaces
  withr::with_tempdir({
    p <- new_hugoify_page("name with spaces")
    build_hugo_source(p)
    expect_true( dir.exists("name-with-spaces") )
  })

})

test_that("sanitize_page_name replaces spaces", {
  expect_identical("no-spaces-here", sanitize_page_name("no spaces here") )
})
