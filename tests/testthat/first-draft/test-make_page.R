# ** raises error for not bundling a list page **

# test_that("make_page raises error for not bundling resources", {
#   writeLines("Some other file", "other_file.txt")
#   expect_error(make_page("resource_no_bundle", resource="other_file.txt" , bundle=FALSE),
#                regexp = "A page cannot have resources if it is not a bundle")
# })
#
# test_that("make_page raises error if bundle or page already exists", {
#
#   # for page bundles (the default) check for the directory
#   withr::with_tempdir({
#     page_name <- "existing_page"
#     dir.create(page_name)
#     file.create(file.path(page_name, "index.md"))
#     expect_error(make_page(page_name), regexp = "already exists")
#   })
#
#   # no error if clean=TRUE
#   withr::with_tempdir({
#     page_name <- "existing_page"
#     dir.create(page_name)
#     file.create(file.path(page_name, "index.md"))
#     expect_error(make_page(page_name, clean=TRUE), regexp = NA)
#   })
#
#   # for non-bundle pages, check for the .md file
#   withr::with_tempdir({
#     page_name <- "existing_page"
#     file.create( paste0(page_name, ".md"))
#     expect_error(make_page(page_name, bundle=FALSE), regexp = "already exists")
#   })
#
#   # no error if clean=TRUE
#   withr::with_tempdir({
#     page_name <- "existing_page"
#     file.create( paste0(page_name, ".md"))
#     expect_error(make_page(page_name, bundle=FALSE, clean=TRUE), regexp = NA)
#   })
#
# })
#
# ** creates directory if needed **
# ** creates a file with the correct name and location **
# ** handles wonky page names **
#
# test_that("make_page replaces old pages if clean=TRUE", {
#
#   # bundle - it should wipe out everything in the old bundle
#   withr::with_tempdir({
#
#     # make the directory and put some stuff in it
#     page_name <- "existing_page"
#     dir.create(page_name)
#     writeLines("---\ntitle: old page\n---\n\nThis is the old page.",
#                file.path(page_name, "index.md"))
#     writeLines("Some other file", file.path(page_name, "other_file.txt"))
#
#     # sanity check, what's the state before make_page()
#     expect_true(file.exists(file.path(page_name, "other_file.txt")))
#     expect_true(grepl("old", readLines(file.path(page_name, "index.md"))[[2]] ))
#
#     # a new make_page call should replace everything
#     make_page(page_name, clean=TRUE)
#     expect_false(file.exists(file.path(page_name, "other_file.txt")))
#     expect_false(grepl("old", readLines(file.path(page_name, "index.md"))[[2]] ))
#
#   })
#
#   # no bundle - it should just delete the .md file but leave other files in place
#   withr::with_tempdir({
#
#     # make the page, plus another file that should not be deleted
#     page_name <- "existing_page"
#     writeLines("---\ntitle: old page\n---\n\nThis is the old page.",
#                paste0(page_name, ".md"))
#     writeLines("Some other file", "other_file.txt")
#
#     # sanity check, what's the state before make_page()
#     expect_true(file.exists("other_file.txt"))
#     expect_true(grepl("old", readLines(paste0(page_name, ".md"))[[2]] ))
#
#     # a new make_page call should replace only the page file
#     make_page(page_name, bundle=FALSE, clean=TRUE)
#     expect_true(file.exists("other_file.txt"))
#     expect_false(grepl("old", readLines(paste0(page_name, ".md"))[[2]] ))
#
#   })
#
# })
#
# ** respects output dir **
# ** creates non-existent output_dir **
#
# test_that("make_page handles page params", {
#
#   # no params should have empty yaml header
#   dir <- withr::local_tempdir()
#   withr::with_dir(dir, make_page("params_no"))
#   expect_snapshot_file(file.path(dir, "params_no", "index.md"), name="params_no.md")
#
#   # params are written to the yaml header
#   dir <- withr::local_tempdir()
#   withr::with_dir(dir, make_page("params_yes",params=list(param1="first param",
#                                                           param2="second param") ))
#   expect_snapshot_file(file.path(dir, "params_yes", "index.md"), name="params_yes.md")
# })
#
# test_that("make_page handles page content", {
#
#   # no content should have empty body
#   dir <- withr::local_tempdir()
#   withr::with_dir(dir, make_page("content_no"))
#   expect_snapshot_file(file.path(dir, "content_no", "index.md"), name="content_no.md")
#
#   # content is written to the body
#   dir <- withr::local_tempdir()
#   withr::with_dir(dir, make_page("content_yes",
#                                  content="This page was written by make_page()."))
#   expect_snapshot_file(file.path(dir, "content_yes", "index.md"), name="content_yes.md")
# })
#
# test_that("make_page copies file resources", {
#
#   # resources of type character should be handles as paths
#   # the file(s) should be copied over into the page bundle
#
#   # a single file
#   withr::with_tempdir({
#     writeLines("Some other file", "other_file.txt")
#     make_page("single_file", resources="other_file.txt")
#     expect_true(file.exists(file.path("single_file", "other_file.txt")))
#   })
#
#   # a file in a directory - should strip off all but the file name
#   withr::with_tempdir({
#     dir.create("foo")
#     writeLines("Some other file", file.path("foo", "other_file.txt"))
#     make_page("nested_file", resources=file.path("foo", "other_file.txt"))
#     expect_true(file.exists(file.path("nested_file", "other_file.txt")))
#   })
#
#   # multiple files
#   withr::with_tempdir({
#     writeLines("File 1", "file1.txt")
#     writeLines("File 2", "file2.txt")
#     make_page("multiple_files", resources=c("file1.txt", "file2.txt"))
#     expect_true(file.exists(file.path("multiple_files", "file1.txt")))
#     expect_true(file.exists(file.path("multiple_files", "file2.txt")))
#   })
#
#   # directory - should copy the whole directory
#   withr::with_tempdir({
#     dir.create("foo")
#     writeLines("File 1", file.path("foo", "file1.txt"))
#     writeLines("File 2", file.path("foo", "file2.txt"))
#     make_page("directory", resources="foo")
#     expect_true(file.exists(file.path("directory", "foo", "file1.txt")))
#     expect_true(file.exists(file.path("directory", "foo", "file2.txt")))
#   })
#
# })
#
# test_that("make_page evaluates expression resources", {
#
#   # expressions should be evaluated from within the page's output_dir
#   withr::with_tempdir({
#     resource_exp <- call("writeLines", "Some other file", "other_file.txt")
#     make_page("expression_resource", resources=resource_exp)
#     expect_true(file.exists(file.path("expression_resource", "other_file.txt")))
#   })
#
# })
#
# test_that("make_page handles mixed resources", {
#
#   # confirm we can handle a messy mix of resource types
#   withr::with_tempdir({
#     dir.create("foo")
#     writeLines("File 1", file.path("foo", "file1.txt"))
#     resource_exp <- call("writeLines", "File 2", "file2.txt")
#     writeLines("File 3", "file3.txt")
#
#     resources <- list( file.path("foo", "file1.txt"),
#                        resource_exp,
#                        "file3.txt")
#
#     make_page("mixed_resources", resources=resources)
#     expect_true(file.exists(file.path("mixed_resources", "file1.txt")))
#     expect_true(file.exists(file.path("mixed_resources", "file2.txt")))
#     expect_true(file.exists(file.path("mixed_resources", "file3.txt")))
#   })
#
# })
#
# test_that("make_test_page produces expected output", {
# #   # make_test_page is a wrapper for make_page
# #   # no need for extensive testing, just capture a snapshot
# #   dir <- withr::local_tempdir()
# #   make_test_page("default_test_page", output_dir = dir,)
# #   expect_snapshot_file(file.path(dir, "default_test_page", "index.md"), name="default_test_page.md")
# #
# })

