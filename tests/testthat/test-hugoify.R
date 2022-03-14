# #TODO: build_hugo_source - confirm that we can specify config_file
#
# test_that("build_hugo_source generates a content directory", {
#
#   withr::with_tempdir({
#     config_file <- "hugoify.yml"
#     yaml <- paste("---", "content:", "config: c", "theme: t", "---", sep="\n")
#     writeLines(yaml, config_file)
#
#     build_hugo_source(config_file)
#     expect_true( dir.exists("content") )
#   })
#
#   # directory should still be named "content", even if hugoify.yml called it "home"
#   withr::with_tempdir({
#     config_file <- "hugoify.yml"
#     yaml <- paste("---", "home:", "config: c", "theme: t", "---", sep="\n")
#     writeLines(yaml, config_file)
#
#     build_hugo_source(config_file)
#     expect_true( dir.exists("content") )
#   })
#
# })
#
#
#
# # test_that("build_hugo_source generates the expected top-level index file", {
# #
# #   # hugo expects the home page to be list, so we expect an _index.md
# #   # for the home page this is true with or without children
# #   dir <- withr::local_tempdir()
# #   withr::with_dir(dir, {
# #     # set up config file
# #     config_file <- "hugoify.yml"
# #     yaml <- paste("---", "content:", "config: c", "theme: t", "---", sep="\n")
# #     writeLines(yaml, config_file)
# #     # run
# #     build_hugo_source(config_file)
# #   })
# #   expect_true( file.exists( file.path(dir, "content", "_index.md") ) )
# #   expect_snapshot_file(file.path(dir, "content", "_index.md"), name="home_empty.md")
# #
# #
# #   # if it's specified to not be a list page, expect an error
# #
# # })
