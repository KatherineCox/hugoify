# TODO: test output_dir

test_that("construct_page_calls raises error if passed a yaml string or file", {
  yaml <- paste("---", "page1:", "---", sep="\n")
  expect_error(construct_page_calls(yaml), regexp = "yaml_list must be a list")
})

test_that("construct_page_calls returns a list of calls", {

  # empty content - should just make the home page
  yaml <- paste("---", "page1:", "---", sep="\n")
  num_pages <- 1

  yaml_list <- yaml::yaml.load(yaml)
  page_calls <- construct_page_calls(yaml_list)

  expect_type(page_calls, "list")
  expect_length(page_calls, num_pages)
  expect_equal(vapply(page_calls, is.call, TRUE),
               rep( TRUE, length(page_calls) ))
})

test_that("construct_page_calls returns calls with expected functions and args", {
  # this should probably get split up into multiple tests as I figure out how to break it down

  # empty content - should just make a single page
  yaml <- paste("---", "page1:", "---", sep="\n")
  yaml_list <- yaml::yaml.load(yaml)
  page_calls <- construct_page_calls(yaml_list)

  single_call <- page_calls[[1]]
  expect_identical(single_call[[1]], make_page)
  expect_identical(single_call[["page_name"]], "page1")
})

test_that("construct_page_calls raises error for incorrect make_page arg names", {

  yaml <- paste("---",
                "page1:",
                "  foo: 'Your argument is invalid.'",
                "---", sep="\n")
  yaml_list <- yaml::yaml.load(yaml)
  expect_error(construct_page_calls(yaml_list), regexp = "is not a valid argument to make_page.")
})

test_that("construct_page_calls only adds args that are in the yaml", {

  # an arg should be not be present if it's not specified in the yaml
  # check that each arg is absent by default

  # mainly this makes sure that we're not accidentally setting an arg to NULL
  # and overriding make_page defaults
  # this can happen if we try to access an arg by name from the yaml list
  # if it's not there, it returns NULL
  yaml <- paste("---", "page1:", "---", sep="\n")
  yaml_list <- yaml::yaml.load(yaml)
  page_calls <- construct_page_calls(yaml_list)

  single_call <- page_calls[[1]]

  absent_args <- names(formals(make_page))
  # page_name *should* be present, so take it off this list
  absent_args <- absent_args[ - match("page_name", absent_args) ]

  for (arg in  absent_args) {
    expect_false( arg %in% names(single_call) )
  }

  # snapshot the eval result
  dir <- withr::local_tempdir()
  withr::with_dir(dir, eval(single_call))
  expect_snapshot_file(file.path(dir, "page1", "index.md"), name="no_args.md")

})

test_that("construct_page_calls passes is_list_page and bundle args to make_page", {

  # is_list_page
  yaml <- paste("---",
                "page1:",
                "  is_list_page: true",
                "---", sep="\n")
  yaml_list <- yaml::yaml.load(yaml)
  page_calls <- construct_page_calls(yaml_list)

  single_call <- page_calls[[1]]
  expect_identical(single_call[[1]], make_page)
  expect_identical(single_call[["is_list_page"]], TRUE)

  dir <- withr::local_tempdir()
  withr::with_dir(dir, eval(single_call))
  expect_true( file.exists( file.path(dir, "page1", "_index.md") ) )

  # bundle
  yaml <- paste("---",
                "page1:",
                "  bundle: false",
                "---", sep="\n")
  yaml_list <- yaml::yaml.load(yaml)
  page_calls <- construct_page_calls(yaml_list)

  single_call <- page_calls[[1]]
  expect_identical(single_call[[1]], make_page)
  expect_identical(single_call[["bundle"]], FALSE)

  dir <- withr::local_tempdir()
  withr::with_dir(dir, eval(single_call))
  expect_true( file.exists( file.path(dir, "page1.md") ) )

})

test_that("construct_page_calls passes params to make_page", {

  yaml <- paste("---",
                "page1:",
                "  params:",
                "    param1: first param",
                "    param2: second param",
                "---", sep="\n")
  yaml_list <- yaml::yaml.load(yaml)
  page_calls <- construct_page_calls(yaml_list)

  single_call <- page_calls[[1]]
  expect_identical(single_call[[1]], make_page)
  expect_identical(single_call[["params"]], list(param1="first param", param2="second param"))

  # snapshot the eval result
  dir <- withr::local_tempdir()
  withr::with_dir(dir, eval(single_call))
  expect_snapshot_file(file.path(dir, "page1", "index.md"), name="params.md")

})

test_that("construct_page_calls passes content to make_page", {

  yaml <- paste("---",
                "page1:",
                "  content: 'Here is some content.'",
                "---", sep="\n")
  yaml_list <- yaml::yaml.load(yaml)
  page_calls <- construct_page_calls(yaml_list)

  single_call <- page_calls[[1]]
  expect_identical(single_call[[1]], make_page)
  expect_identical(single_call[["content"]],"Here is some content.")

  # snapshot the eval result
  dir <- withr::local_tempdir()
  withr::with_dir(dir, eval(single_call))
  expect_snapshot_file(file.path(dir, "page1", "index.md"), name="content.md")

})

test_that("construct_page_calls passes all args to make_page", {

  # double check that nothing goes wonky when we have multiple arguments
  # just a snapshot so we don't have to update expect_identical() tests
  # of individual elements in two places

  yaml <- paste("---",
                "page1:",
                "  params:",
                "    param1: first param",
                "    param2: second param",
                "  content: 'Here is some content.'",
                "---", sep="\n")
  yaml_list <- yaml::yaml.load(yaml)
  page_calls <- construct_page_calls(yaml_list)
  single_call <- page_calls[[1]]

  # snapshot the eval result
  dir <- withr::local_tempdir()
  withr::with_dir(dir, eval(single_call))
  expect_snapshot_file(file.path(dir, "page1", "index.md"), name="multiple_args.md")

})

