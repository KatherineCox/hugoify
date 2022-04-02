
#### CONSTRUCTOR ####

test_that("new_hugoify_page makes an object of class 'hugoify_page'", {
  p <- new_hugoify_page()
  expect_s3_class(p, "hugoify_page")
})

test_that("new_hugoify_page makes an object of type  'list'", {
  p <- new_hugoify_page()
  expect_type(p, "list" )
})

test_that("new_hugoify_page makes an object with the correct fields", {
  expected_names <- c("params", "content")
  p <- new_hugoify_page()
  expect_named(p, expected_names)
})

test_that("new_hugoify_page handles page params", {

  # no params should have an empty params list
  p <- new_hugoify_page()
  expect_type(p$params, "list" )
  expect_length(p$params, 0)

  # params are added to the page
  test_params=list(param1="first param", param2="second param")
  p <- new_hugoify_page( params=test_params )
  expect_type(p$params, "list" )
  expect_mapequal(p$params, test_params)

  # nested params are handled correctly
  test_params=list(single_param="first param", param_list=list(item1="foo", item2="bar"))
  p <- new_hugoify_page( params=test_params )
  expect_type(p$params, "list" )
  expect_mapequal(p$params, test_params)
})

test_that("new_hugoify_page handles page content", {

  # no content should have an empty string
  p <- new_hugoify_page()
  expect_type(p$content, "character" )
  expect_equal(p$content, "")

  # content is added to the page
  test_content="This is a hugoify page"
  p <- new_hugoify_page(content=test_content)
  expect_type(p$content, "character" )
  expect_equal(p$content, test_content)
})

#### VALIDATOR ####

#### USER FACING ####
