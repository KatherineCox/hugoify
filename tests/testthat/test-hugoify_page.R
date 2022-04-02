
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

#### VALIDATOR ####

#### USER FACING ####
