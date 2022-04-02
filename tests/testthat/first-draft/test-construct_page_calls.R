# test_that("construct_page_calls returns a list of calls", {
#
#   # single page, no additional args
#   yaml <- paste("---", "page1:", "---", sep="\n")
#   num_pages <- 1
#
#   yaml_list <- yaml::yaml.load(yaml)
#   page_calls <- construct_page_calls(yaml_list)
#
#   expect_type(page_calls, "list")
#   expect_length(page_calls, num_pages)
#   expect_equal(vapply(page_calls, is.call, TRUE),
#                rep( TRUE, length(page_calls) ))
#
#   # two pages
#   yaml <- paste("---", "page1:", "page2:", "---", sep="\n")
#   num_pages <- 2
#
#   yaml_list <- yaml::yaml.load(yaml)
#   page_calls <- construct_page_calls(yaml_list)
#
#   expect_type(page_calls, "list")
#   expect_length(page_calls, num_pages)
#   expect_equal(vapply(page_calls, is.call, TRUE),
#                rep( TRUE, length(page_calls) ))
# })
#
# test_that("construct_page_calls returns calls with expected functions and args", {
#   # this should probably get split up into multiple tests as I figure out how to break it down
#
#   # empty content - should just make a single page
#   yaml <- paste("---", "page1:", "---", sep="\n")
#   yaml_list <- yaml::yaml.load(yaml)
#   page_calls <- construct_page_calls(yaml_list)
#
#   single_call <- page_calls[[1]]
#   expect_identical(single_call[[1]], make_page)
#   expect_identical(single_call[["page_name"]], "page1")
#
#   # snapshot the eval result
#   dir <- withr::local_tempdir()
#   withr::with_dir(dir, eval(single_call))
#   expect_snapshot_file(file.path(dir, "page1", "index.md"), name="base.md")
# })
#
# test_that("construct_page_calls handles non-key pages", {
#
#   # no colon after page name means it gets read in as a character vector rather than a list
#   yaml <- paste("---", "page1", "---", sep="\n")
#   yaml_list <- yaml::yaml.load(yaml)
#   page_calls <- construct_page_calls(yaml_list)
#
#   single_call <- page_calls[[1]]
#   expect_identical(single_call[[1]], make_page)
#   expect_identical(single_call[["page_name"]], "page1")
#
#   # snapshot the eval result
#   dir <- withr::local_tempdir()
#   withr::with_dir(dir, eval(single_call))
#   expect_snapshot_file(file.path(dir, "page1", "index.md"), name="character.md")
# })
#
# test_that("construct_page_calls handles multiple pages", {
#
#   yaml <- paste("---", "page1:", "page2:", "---", sep="\n")
#   yaml_list <- yaml::yaml.load(yaml)
#   page_calls <- construct_page_calls(yaml_list)
#
#   single_call <- page_calls[[1]]
#   expect_identical(single_call[[1]], make_page)
#   expect_identical(single_call[["page_name"]], "page1")
#
#   single_call <- page_calls[[2]]
#   expect_identical(single_call[[1]], make_page)
#   expect_identical(single_call[["page_name"]], "page2")
#
#   # snapshot the eval result
#   dir <- withr::local_tempdir()
#   withr::with_dir(dir, lapply(page_calls, eval) )
#   expect_snapshot_file(file.path(dir, "page1", "index.md"), name="multi_page1.md")
#   expect_snapshot_file(file.path(dir, "page2", "index.md"), name="multi_page2.md")
#
#   # character vector rather than a list
#   yaml <- paste("---", "- page1", "- page2", "---", sep="\n")
#   yaml_list <- yaml::yaml.load(yaml)
#   page_calls <- construct_page_calls(yaml_list)
#
#   single_call <- page_calls[[1]]
#   expect_identical(single_call[[1]], make_page)
#   expect_identical(single_call[["page_name"]], "page1")
#
#   single_call <- page_calls[[2]]
#   expect_identical(single_call[[1]], make_page)
#   expect_identical(single_call[["page_name"]], "page2")
#
#   # snapshot the eval result
#   dir <- withr::local_tempdir()
#   withr::with_dir(dir, lapply(page_calls, eval) )
#   expect_snapshot_file(file.path(dir, "page1", "index.md"), name="multi_char_page1.md")
#   expect_snapshot_file(file.path(dir, "page2", "index.md"), name="multi_char_page2.md")
#
# })
#
# test_that("construct_page_calls passes output_dir to make_page", {
#
#   # construct_page_calls should always pass on output_dir
#   # even if it was not provided
#   yaml <- paste("---", "page1:", "---", sep="\n")
#   yaml_list <- yaml::yaml.load(yaml)
#   page_calls <- construct_page_calls(yaml_list)
#
#   single_call <- page_calls[[1]]
#   expect_identical(single_call[[1]], make_page)
#   expect_identical(single_call[["output_dir"]],".")
#
#   # check the eval result
#   withr::with_tempdir({
#     eval(single_call)
#     expect_true( file.exists( file.path("page1", "index.md") ) )
#   })
#
#   # pass on an user-specified output_dir
#   yaml <- paste("---", "page1:", "---", sep="\n")
#   yaml_list <- yaml::yaml.load(yaml)
#   page_calls <- construct_page_calls(yaml_list, output_dir="foo")
#
#   single_call <- page_calls[[1]]
#   expect_identical(single_call[[1]], make_page)
#   expect_identical(single_call[["output_dir"]],"foo")
#
#   # check the eval result
#   withr::with_tempdir({
#     eval(single_call)
#     expect_true( file.exists( file.path("foo", "page1", "index.md") ) )
#   })
#
# })
#
# test_that("construct_page_calls passes clean to make_page", {
#
#   yaml <- paste("---", "page1:", "---", sep="\n")
#   yaml_list <- yaml::yaml.load(yaml)
#   page_calls <- construct_page_calls(yaml_list, clean=TRUE)
#
#   single_call <- page_calls[[1]]
#   expect_identical(single_call[[1]], make_page)
#   expect_identical(single_call[["clean"]], TRUE)
#
#   # check the eval result
#   withr::with_tempdir({
#
#     # make the directory and put some stuff in it
#     page_name <- "page1"
#     dir.create(page_name)
#     writeLines("---\ntitle: old page\n---\n\nThis is the old page.",
#                file.path(page_name, "index.md"))
#     writeLines("Some other file", file.path(page_name, "other_file.txt"))
#
#     # sanity check, what's the state before evaluating the make_page call
#     expect_true(file.exists(file.path(page_name, "other_file.txt")))
#     expect_true(grepl("old", readLines(file.path(page_name, "index.md"))[[2]] ))
#
#     # evaluating the make_page call should replace everything
#     eval(single_call)
#     expect_false(file.exists(file.path(page_name, "other_file.txt")))
#     expect_false(grepl("old", readLines(file.path(page_name, "index.md"))[[2]] ))
#   })
#
# })
#
# test_that("construct_page_calls raises error for incorrect make_page arg names", {
#
#   yaml <- paste("---",
#                 "page1:",
#                 "  foo: 'Your argument is invalid.'",
#                 "---", sep="\n")
#   yaml_list <- yaml::yaml.load(yaml)
#   expect_error(construct_page_calls(yaml_list), regexp = "is not a valid argument to make_page.")
# })
#
# test_that("construct_page_calls only adds args that are in the yaml", {
#
#   # an arg should be not be present if it's not specified in the yaml
#   # check that each arg is absent by default
#
#   # mainly this makes sure that we're not accidentally setting an arg to NULL
#   # and overriding make_page defaults
#   # this can happen if we try to access an arg by name from the yaml list
#   # if it's not there, it returns NULL
#   yaml <- paste("---", "page1:", "---", sep="\n")
#   yaml_list <- yaml::yaml.load(yaml)
#   page_calls <- construct_page_calls(yaml_list)
#
#   single_call <- page_calls[[1]]
#
#   absent_args <- names(formals(make_page))
#   # page_name and output_dir *should* be present, so take them off this list
#   absent_args <- absent_args[ - match(c("page_name", "output_dir"), absent_args) ]
#
#   for (arg in  absent_args) {
#     expect_false( arg %in% names(single_call) )
#   }
#
#   # snapshot the eval result
#   dir <- withr::local_tempdir()
#   withr::with_dir(dir, eval(single_call))
#   expect_snapshot_file(file.path(dir, "page1", "index.md"), name="no_args.md")
#
# })
#
# test_that("construct_page_calls passes is_list_page and bundle args to make_page", {
#
#   # is_list_page
#   yaml <- paste("---",
#                 "page1:",
#                 "  is_list_page: true",
#                 "---", sep="\n")
#   yaml_list <- yaml::yaml.load(yaml)
#   page_calls <- construct_page_calls(yaml_list)
#
#   single_call <- page_calls[[1]]
#   expect_identical(single_call[[1]], make_page)
#   expect_identical(single_call[["is_list_page"]], TRUE)
#
#   dir <- withr::local_tempdir()
#   withr::with_dir(dir, eval(single_call))
#   expect_true( file.exists( file.path(dir, "page1", "_index.md") ) )
#
#   # bundle
#   yaml <- paste("---",
#                 "page1:",
#                 "  bundle: false",
#                 "---", sep="\n")
#   yaml_list <- yaml::yaml.load(yaml)
#   page_calls <- construct_page_calls(yaml_list)
#
#   single_call <- page_calls[[1]]
#   expect_identical(single_call[[1]], make_page)
#   expect_identical(single_call[["bundle"]], FALSE)
#
#   dir <- withr::local_tempdir()
#   withr::with_dir(dir, eval(single_call))
#   expect_true( file.exists( file.path(dir, "page1.md") ) )
#
# })
#
# test_that("construct_page_calls passes params to make_page", {
#
#   yaml <- paste("---",
#                 "page1:",
#                 "  params:",
#                 "    param1: first param",
#                 "    param2: second param",
#                 "---", sep="\n")
#   yaml_list <- yaml::yaml.load(yaml)
#   page_calls <- construct_page_calls(yaml_list)
#
#   single_call <- page_calls[[1]]
#   expect_identical(single_call[[1]], make_page)
#   expect_identical(single_call[["params"]], list(param1="first param", param2="second param"))
#
#   # snapshot the eval result
#   dir <- withr::local_tempdir()
#   withr::with_dir(dir, eval(single_call))
#   expect_snapshot_file(file.path(dir, "page1", "index.md"), name="params.md")
#
# })
#
# test_that("construct_page_calls passes content to make_page", {
#
#   yaml <- paste("---",
#                 "page1:",
#                 "  content: 'Here is some content.'",
#                 "---", sep="\n")
#   yaml_list <- yaml::yaml.load(yaml)
#   page_calls <- construct_page_calls(yaml_list)
#
#   single_call <- page_calls[[1]]
#   expect_identical(single_call[[1]], make_page)
#   expect_identical(single_call[["content"]],"Here is some content.")
#
#   # snapshot the eval result
#   dir <- withr::local_tempdir()
#   withr::with_dir(dir, eval(single_call))
#   expect_snapshot_file(file.path(dir, "page1", "index.md"), name="content.md")
#
# })
#
# test_that("construct_page_calls passes all args to make_page", {
#
#   # double check that nothing goes wonky when we have multiple arguments
#   # just a snapshot so we don't have to update expect_identical() tests
#   # of individual elements in multiple places
#
#   yaml <- paste("---",
#                 "page1:",
#                 "  params:",
#                 "    param1: first param",
#                 "    param2: second param",
#                 "  content: 'Here is some content.'",
#                 "---", sep="\n")
#   yaml_list <- yaml::yaml.load(yaml)
#   page_calls <- construct_page_calls(yaml_list)
#   single_call <- page_calls[[1]]
#
#   # snapshot the eval result
#   dir <- withr::local_tempdir()
#   withr::with_dir(dir, eval(single_call))
#   expect_snapshot_file(file.path(dir, "page1", "index.md"), name="multiple_args.md")
#
# })
#
# test_that("construct_page_calls passes on args when there are multiple pages", {
#
#   # double check that nothing goes wonky when we have multiple pages
#   # just a snapshot so we don't have to update expect_identical() tests
#   # of individual elements in multiple places
#   # also confirms that output_dir is respected when there are multiple pages
#
#   yaml <- paste("---",
#                 "page1:",
#                 "  params:",
#                 "    param1: first param",
#                 "    param2: second param",
#                 "  content: 'Here is some content.'",
#                 "page2:",
#                 "  params:",
#                 "    param1: foo",
#                 "    param2: bar",
#                 "  content: 'Content for page2.'",
#                 "---", sep="\n")
#   yaml_list <- yaml::yaml.load(yaml)
#   page_calls <- construct_page_calls(yaml_list, output_dir="baz")
#
#   # snapshot the eval result
#   dir <- withr::local_tempdir()
#   withr::with_dir(dir, lapply(page_calls, eval) )
#   expect_snapshot_file(file.path(dir, "baz", "page1", "index.md"), name="multi_page_multi_args1.md")
#   expect_snapshot_file(file.path(dir, "baz", "page2", "index.md"), name="multi_page_multi_args2.md")
#
# })
#
