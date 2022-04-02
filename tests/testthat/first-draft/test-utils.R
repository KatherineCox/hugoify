# # TODO: test write_md writing in other directories? Or just assume file.path does its job?
#
# test_that("write_md outputs the expected markdown file", {
#   yaml <- list(title="A Test Page")
#   content <- "This test file was written by write_md()."
#   filename <- "write_md_test.md"
#   output_dir <- withr::local_tempdir()
#
#   write_md(yaml=yaml, content=content, filename=filename, output_dir=output_dir)
#   expect_true(file.exists(file.path(output_dir, filename)))
#   expect_snapshot_file(file.path(output_dir, filename))
# })
#
# test_that("write_md handles empty yaml", {
#
#   # no yaml provided
#   content <- "This test file was written by write_md()."
#   filename <- "write_md_no_yaml.md"
#   output_dir <- withr::local_tempdir()
#
#   write_md(content=content, filename=filename, output_dir=output_dir)
#   expect_snapshot_file(file.path(output_dir, filename))
#
#   # provided yaml is empty list
#   yaml <- list()
#   content <- "This test file was written by write_md()."
#   filename <- "write_md_empty_yaml.md"
#   output_dir <- withr::local_tempdir()
#
#   write_md(yaml=yaml, content=content, filename=filename, output_dir=output_dir)
#   expect_snapshot_file(file.path(output_dir, filename))
# })
#
# test_that("write_md handles empty content", {
#
# })
#
