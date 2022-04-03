
#### CONSTRUCTOR ####

test_that("new_hugoify_page raises error for invalid page_name", {

  # error for invalid name
  expect_error(new_hugoify_page(1), regexp="page_name must be of type 'character'")
  # error for too many names
  expect_error(new_hugoify_page(c("page1", "page2")), regexp="page_name must be a character vector of length 1")
  # no error for good name
  expect_error(new_hugoify_page("my_page"), regexp=NA)

})

test_that("new_hugoify_page makes an object of class 'hugoify_page'", {
  p <- new_hugoify_page("my_page")
  expect_s3_class(p, "hugoify_page")
})

test_that("new_hugoify_page makes an object of type  'list'", {
  p <- new_hugoify_page("my_page")
  expect_type(p, "list" )
})

test_that("new_hugoify_page makes an object with the correct fields", {
  expected_names <- c("page_name", "params", "content")
  p <- new_hugoify_page("my_page")
  expect_named(p, expected_names)
})

test_that("new_hugoify_page handles page params", {

  # no params should have an empty params list
  p <- new_hugoify_page("my_page")
  expect_type(p$params, "list" )
  expect_length(p$params, 0)

  # params are added to the page
  test_params=list(param1="first param", param2="second param")
  p <- new_hugoify_page("my_page", params=test_params )
  expect_type(p$params, "list" )
  expect_mapequal(p$params, test_params)

  # nested params are handled correctly
  test_params=list(single_param="first param", param_list=list(item1="foo", item2="bar"))
  p <- new_hugoify_page("my_page", params=test_params )
  expect_type(p$params, "list" )
  expect_mapequal(p$params, test_params)
})

test_that("new_hugoify_page handles page content", {

  # no content should have an empty string
  p <- new_hugoify_page("my_page")
  expect_type(p$content, "character" )
  expect_equal(p$content, "")

  # content is added to the page
  test_content="This is a hugoify page"
  p <- new_hugoify_page("my_page", content=test_content)
  expect_type(p$content, "character" )
  expect_equal(p$content, test_content)
})

#### VALIDATORS ####

test_that("validate_hugoify_page raises error for missing fields", {

  p <- new_hugoify_page("my_page")
  p$page_name <- NULL
  expect_error(validate_hugoify_page(p), regexp="Missing page_name")

  p <- new_hugoify_page("my_page")
  p$params <- NULL
  expect_error(validate_hugoify_page(p), regexp="Missing params")

  p <- new_hugoify_page("my_page")
  p$content <- NULL
  expect_error(validate_hugoify_page(p), regexp="Missing content")
})

test_that("validate_hugoify_page raises error if content is not a string", {

  char_content <- "some content"
  num_content <- 1

  # test *content* validator (helper)
  # error for bad content
  expect_error(validate_hugoify_page_content(num_content), regexp="Page content must be")
  # no error for good content
  expect_error(validate_hugoify_page_content(char_content), regexp=NA)

  # test *page* validator
  # error for bad content
  p <- new_hugoify_page("my_page", content=num_content)
  expect_error(validate_hugoify_page(p), regexp="Page content must be")
  # no error for good content
  p <- new_hugoify_page("my_page", content=char_content)
  expect_error(validate_hugoify_page(p), regexp=NA)
})

test_that("validate_hugoify_page raises error for invalid params", {
})

#### USER FACING ####
