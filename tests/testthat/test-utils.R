# TODO: test write_md writing in other directories?
# TODO: test write_md with a more complicated yaml?  Or just assume as.yaml does it's job?

test_that("write_md outputs the expected markdown file", {
  yaml <- list(title="A Test Page")
  content <- "This test file was written by write_md()."
  filename <- "write_md_test.md"
  output_dir <- withr::local_tempdir(pattern = "write-utf8-nonproject")

  write_md(yaml=yaml, content=content, filename=filename, output_dir=output_dir)
  expect_true(file.exists(file.path(output_dir, filename)))
  expect_snapshot_file(file.path(output_dir, filename))
})

