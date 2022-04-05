# TODO: think about whether empty fields should exist in the object
# - having them means a consistent object structure
# - not having them means we're not adding extra empty fields if we convert to yaml
# - having them means we can always add things to e.g. the empty list (we can't add things to NULL)
# - lean towards having them, and we can handle the yaml at write time
# - would a handler for lists that returns NULL for empty lists work?
# TODO: think about naming children

#### CONSTRUCTOR ####

test_that("new_hugoify_site_content raises error for invalid page", {

    # error for invalid page
  expect_error(new_hugoify_site_content(1), regexp="page must be a hugoify_page object")
  # no error for valid page
  p <- new_hugoify_page("my_page")
  expect_error(new_hugoify_site_content(p), regexp=NA)

})

test_that("new_hugoify_site_content raises error for invalid children", {

  # error if children is not a list
  p <- new_hugoify_page("my_page")
  expect_error(new_hugoify_site_content(p, children=1),
               regexp="children must be a list")

  # error for invalid child
  p <- new_hugoify_page("my_page")
  expect_error(new_hugoify_site_content(p, children=list(1)),
               regexp="children must be hugoify_site_content objects")

  # no error for valid child
  child <- new_hugoify_page("child_page")
  child <- new_hugoify_site_content(child)
  p <- new_hugoify_page("parent")
  expect_error(new_hugoify_site_content(p, children=list(child)), regexp=NA)

})

test_that("new_hugoify_site_content makes an object of class 'hugoify_site_content'", {
  p <- new_hugoify_page("my_page")
  s <- new_hugoify_site_content(p)
  expect_s3_class(s, "hugoify_site_content")
})

test_that("new_hugoify_site_content makes an object of type  'list'", {
  p <- new_hugoify_page("my_page")
  s <- new_hugoify_site_content(p)
  expect_type(s, "list" )
})

test_that("new_hugoify_site_content makes an object with the correct fields", {
  expected_names <- c("page", "build_opts", "children")
  p <- new_hugoify_page("my_page")
  s <- new_hugoify_site_content(p)
  expect_named(s, expected_names)
})

test_that("new_hugoify_site_content handles build_opts", {

  # no build_opts should have an empty build_opts list
  p <- new_hugoify_page("my_page")
  s <- new_hugoify_site_content(p)
  expect_identical(s$build_opts, list())

  # is_list_page is added
  p <- new_hugoify_page("my_page")
  s <- new_hugoify_site_content(p, is_list_page=TRUE)
  expect_type(s$build_opts, "list")
  expect_identical(s$build_opts$is_list_page, TRUE)

  # bundle is added
  p <- new_hugoify_page("my_page")
  s <- new_hugoify_site_content(p, bundle=FALSE)
  expect_type(s$build_opts, "list")
  expect_identical(s$build_opts$bundle, FALSE)

})

test_that("new_hugoify_site_content handles children", {

  # new_hugoify_site just checks that they're the right class and adds them
  # so we just need to test that they got added
  child <- new_hugoify_page("child_page")
  child <- new_hugoify_site_content(child)
  p <- new_hugoify_page("parent")
  p <- new_hugoify_site_content(p, children=list(child))
  expect_identical(p$children[[1]], child)

})


#### VALIDATORS ####

test_that("validate_hugoify_site_content raises error if not hugoify_site_content", {
  p <- new_hugoify_page("my_page")
  s <- new_hugoify_site_content(p)
  class(s) <- NULL
  expect_error(validate_hugoify_site_content(s), regexp="Object is not of class 'hugoify_site_content'")
})

test_that("validate_hugoify_site_content raises error for missing fields", {

  # no error if all fields are present
  p <- new_hugoify_page("my_page")
  s <- new_hugoify_site_content(p)
  expect_error(validate_hugoify_site_content(s), regexp=NA)

  p <- new_hugoify_page("my_page")
  s <- new_hugoify_site_content(p)
  s$page <- NULL
  expect_error(validate_hugoify_site_content(s), regexp="Missing page")

  p <- new_hugoify_page("my_page")
  s <- new_hugoify_site_content(p)
  s$build_opts <- NULL
  expect_error(validate_hugoify_site_content(s), regexp="Missing build_opts")

  p <- new_hugoify_page("my_page")
  s <- new_hugoify_site_content(p)
  s$children <- NULL
  expect_error(validate_hugoify_site_content(s), regexp="Missing children")

})


