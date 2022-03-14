# TODO: test parse_hugoify_yaml puts things in the right directory if given output_dir
# TODO: revisit config and theme
# TODO: if things have already been converted to calls, it's hard to test what function they're calling
#       - is it better to keep them in list form, and convert with as.call() later?

test_that("construct_page_calls raises error if passed a yaml string or file", {
  yaml <- paste("---", "home:", "---", sep="\n")
  expect_error(construct_page_calls(yaml), regexp = "yaml_list must be a list")
})

test_that("construct_page_calls returns a list of calls", {

  # empty content - should just make the home page
  yaml <- paste("---", "home:", "---", sep="\n")
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

  # empty content - should just make the home page
  yaml <- paste("---", "home:", "---", sep="\n")
  yaml_list <- yaml::yaml.load(yaml)
  page_calls <- construct_page_calls(yaml_list)

  single_call <- page_calls[[1]]
  expect_identical(single_call[[1]], make_page)
  expect_identical(single_call[["page_name"]], "home")
})

test_that("construct_page_calls passes args to make_page", {

  # an arg should be not be present if it's not specified in the yaml
  # check that each arg is absent by default
  yaml <- paste("---", "home:", "---", sep="\n")
  yaml_list <- yaml::yaml.load(yaml)
  page_calls <- construct_page_calls(yaml_list)

  single_call <- page_calls[[1]]
  expect_false( "params" %in% names(single_call) )
  expect_false( "content" %in% names(single_call) )
  expect_false( "is_list_page" %in% names(single_call) )
  expect_false( "is_bundle" %in% names(single_call) )

  # now check that each arg is added appropriately if specified in the yaml

  # content
  yaml <- paste("---",
                "home:",
                "  content: 'Here is some content'",
                "---", sep="\n")
  yaml_list <- yaml::yaml.load(yaml)
  page_calls <- construct_page_calls(yaml_list)

  single_call <- page_calls[[1]]
  expect_identical(single_call[[1]], make_page)
  expect_identical(single_call[["content"]],"Here is some content")

  # is_list_page
  yaml <- paste("---",
                "home:",
                "  is_list_page: true",
                "---", sep="\n")
  yaml_list <- yaml::yaml.load(yaml)
  page_calls <- construct_page_calls(yaml_list)

  single_call <- page_calls[[1]]
  expect_identical(single_call[[1]], make_page)
  expect_identical(single_call[["is_list_page"]], TRUE)

  # is_bundle
  yaml <- paste("---",
                "home:",
                "  is_bundle: false",
                "---", sep="\n")
  yaml_list <- yaml::yaml.load(yaml)
  page_calls <- construct_page_calls(yaml_list)

  single_call <- page_calls[[1]]
  expect_identical(single_call[[1]], make_page)
  expect_identical(single_call[["is_bundle"]], FALSE)

})

test_that("parse_hugoify_yaml checks for expected keys", {
#
#   yaml_file <- withr::local_file("hugoify.yml")
#
#   # file with both "content" and "home" keys returns an error
#   yaml <- paste("---", "content:", "home:", "config: c", "theme: t", "---", sep="\n")
#   writeLines(yaml, yaml_file)
#   expect_error(parse_hugoify_yaml(yaml_file), regexp="Found both 'content' and 'home' keys")
#
#   # file with neither "content" nor "home" keys returns an error
#   yaml <- paste("---", "config: c", "theme: t", "---", sep="\n")
#   writeLines(yaml, yaml_file)
#   expect_error(parse_hugoify_yaml(yaml_file), regexp="No site content found")
#
#   # file with no config key returns a warning
#   # and this warning is suppressed by 'quiet=TRUE'
#   yaml <- paste("---", "content:", "theme: t", "---", sep="\n")
#   writeLines(yaml, yaml_file)
#   expect_warning(parse_hugoify_yaml(yaml_file), regexp="No hugo config file specified.")
#   expect_warning(parse_hugoify_yaml(yaml_file, quiet=TRUE), regexp=NA)
#
#   # file with no theme key returns a warning
#   # and this warning is suppressed by 'quiet=TRUE'
#   yaml <- paste("---", "content:", "config: c", "---", sep="\n")
#   writeLines(yaml, yaml_file)
#   expect_warning(parse_hugoify_yaml(yaml_file), regexp="No hugo theme directory specified.")
#   expect_warning(parse_hugoify_yaml(yaml_file, quiet=TRUE), regexp=NA)
#
#   # file with all expected keys does not generate error or warning
#   # - "content" or "home"
#   # - "config"
#   # - "theme"
#   yaml <- paste("---", "content:", "config: c", "theme: t", "---", sep="\n")
#   writeLines(yaml, yaml_file)
#   expect_error(parse_hugoify_yaml(yaml_file), regexp=NA)
#   expect_warning(parse_hugoify_yaml(yaml_file), regexp=NA)
#
#   yaml <- paste("---", "home:", "config: c", "theme: t", "---", sep="\n")
#   writeLines(yaml, yaml_file)
#   expect_error(parse_hugoify_yaml(yaml_file), regexp=NA)
#   expect_warning(parse_hugoify_yaml(yaml_file), regexp=NA)
#
})

test_that("parse_hugoify_yaml returns a list of calls", {
#
#   yaml_file <- withr::local_file("hugoify.yml")
#
#   # empty content - should just make the home page
#   yaml <- paste("---", "content:", "config: c", "theme: t", "---", sep="\n")
#   num_pages <- 1
#
#   writeLines(yaml, yaml_file)
#   parse_results <- parse_hugoify_yaml(yaml_file)
#
#   expect_type(parse_results, "list")
#   expect_length(parse_results, num_pages + 2)
#   expect_equal(vapply(parse_results, is.call, TRUE),
#                rep( TRUE, length(parse_results) ))
})

