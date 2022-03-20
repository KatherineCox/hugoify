test_that("make_page raises error for not bundling a list page", {
  expect_error(make_page("list_no_bundle", is_list_page=TRUE, bundle=FALSE),
               regexp = "List pages must be bundles.")
})

test_that("make_page raises error if bundle or page already exists", {

  # for page bundles (the default) check for the directory
  withr::with_tempdir({
    page_name <- "existing_page"
    dir.create(page_name)
    file.create(file.path(page_name, "index.md"))
    expect_error(make_page(page_name), regexp = "already exists")
  })

  # no error if clean=TRUE
  withr::with_tempdir({
    page_name <- "existing_page"
    dir.create(page_name)
    file.create(file.path(page_name, "index.md"))
    expect_error(make_page(page_name, clean=TRUE), regexp = NA)
  })

  # for non-bundle pages, check for the .md file
  withr::with_tempdir({
    page_name <- "existing_page"
    file.create( paste0(page_name, ".md"))
    expect_error(make_page(page_name, bundle=FALSE), regexp = "already exists")
  })

  # no error if clean=TRUE
  withr::with_tempdir({
    page_name <- "existing_page"
    file.create( paste0(page_name, ".md"))
    expect_error(make_page(page_name, bundle=FALSE, clean=TRUE), regexp = NA)
  })

})

test_that("make_page creates a bundle directory if needed", {

  withr::with_tempdir({
    make_page("yes_bundle")
    expect_true( dir.exists("yes_bundle") )
  })

  withr::with_tempdir({
    make_page("no_bundle", bundle=FALSE)
    expect_false( dir.exists("no_bundle") )
  })

})

test_that("make_page creates a file with the correct name and location", {

  # if it's a bundle, expect an index.md inside the bundle directory
  withr::with_tempdir({
    make_page("yes_bundle")
    expect_true( file.exists( file.path("yes_bundle", "index.md") ) )
  })

  # if it's not a bundle, expect a named md file
  withr::with_tempdir({
    make_page("no_bundle", bundle=FALSE)
    expect_true( file.exists("no_bundle.md") )
  })

  # if it's a list page, expect an _index.md inside the bundle directory
  withr::with_tempdir({
    make_page("list", is_list_page=TRUE)
    expect_true( file.exists( file.path("list", "_index.md") ) )
  })

})

test_that("make_page handles wonky page names", {

  # spaces in name
  withr::with_tempdir({
    make_page("yes bundle")
    expect_true( file.exists( file.path("yes-bundle", "index.md") ) )
  })

})

test_that("make_page replaces old pages if clean=TRUE", {

  # bundle - it should wipe out everything in the old bundle
  withr::with_tempdir({

    # make the directory and put some stuff in it
    page_name <- "existing_page"
    dir.create(page_name)
    writeLines("---\ntitle: old page\n---\n\nThis is the old page.",
               file.path(page_name, "index.md"))
    writeLines("Some other file", file.path(page_name, "other_file.txt"))

    # sanity check, what's the state before make_page()
    expect_true(file.exists(file.path(page_name, "other_file.txt")))
    expect_true(grepl("old", readLines(file.path(page_name, "index.md"))[[2]] ))

    # a new make_page call should replace everything
    make_page(page_name, clean=TRUE)
    expect_false(file.exists(file.path(page_name, "other_file.txt")))
    expect_false(grepl("old", readLines(file.path(page_name, "index.md"))[[2]] ))

  })

  # no bundle - it should just delete the .md file but leave other files in place
  withr::with_tempdir({

    # make the page, plus another file that should not be deleted
    page_name <- "existing_page"
    writeLines("---\ntitle: old page\n---\n\nThis is the old page.",
               paste0(page_name, ".md"))
    writeLines("Some other file", "other_file.txt")

    # sanity check, what's the state before make_page()
    expect_true(file.exists("other_file.txt"))
    expect_true(grepl("old", readLines(paste0(page_name, ".md"))[[2]] ))

    # a new make_page call should replace only the page file
    make_page(page_name, bundle=FALSE, clean=TRUE)
    expect_true(file.exists("other_file.txt"))
    expect_false(grepl("old", readLines(paste0(page_name, ".md"))[[2]] ))

  })

})

test_that("make_page respects output_dir", {

  # if it's a bundle, expect an index.md inside the bundle directory
  withr::with_tempdir({
    dir.create("foo")
    make_page("yes_bundle", output_dir="foo")
    expect_true( file.exists( file.path("foo", "yes_bundle", "index.md") ) )
  })

  # if it's not a bundle, expect a named md file
  withr::with_tempdir({
    dir.create("foo")
    make_page("no_bundle", output_dir="foo", bundle=FALSE)
    expect_true( file.exists( file.path("foo", "no_bundle.md") ) )
  })

})

test_that("make_page creates non-existent output_dir", {

  withr::with_tempdir({
    make_page("yes_bundle", output_dir="foo")
    expect_true( dir.exists("foo") )
    expect_true( dir.exists( file.path("foo", "yes_bundle") ) )
    expect_true( file.exists( file.path("foo", "yes_bundle", "index.md") ) )
  })

  # recursive
  withr::with_tempdir({
    make_page("yes_bundle", output_dir=file.path("foo", "bar"))
    expect_true( dir.exists("foo") )
    expect_true( dir.exists( file.path("foo", "bar") ) )
    expect_true( dir.exists( file.path("foo", "bar", "yes_bundle") ) )
    expect_true( file.exists( file.path("foo", "bar", "yes_bundle", "index.md") ) )
  })

})

test_that("make_page handles page params", {

  # no params should have empty yaml header
  dir <- withr::local_tempdir()
  withr::with_dir(dir, make_page("params_no"))
  expect_snapshot_file(file.path(dir, "params_no", "index.md"), name="params_no.md")

  # params are written to the yaml header
  dir <- withr::local_tempdir()
  withr::with_dir(dir, make_page("params_yes",params=list(param1="first param",
                                                          param2="second param") ))
  expect_snapshot_file(file.path(dir, "params_yes", "index.md"), name="params_yes.md")
})

test_that("make_page handles page content", {

  # no content should have empty body
  dir <- withr::local_tempdir()
  withr::with_dir(dir, make_page("content_no"))
  expect_snapshot_file(file.path(dir, "content_no", "index.md"), name="content_no.md")

  # content is written to the body
  dir <- withr::local_tempdir()
  withr::with_dir(dir, make_page("content_yes",
                                 content="This page was written by make_page()."))
  expect_snapshot_file(file.path(dir, "content_yes", "index.md"), name="content_yes.md")
})

test_that("make_page copies character resources", {

  # resources of type character should be handles as paths
  # the file(s) should be copied over into the page bundle

  # a single file
  withr::with_tempdir({
    writeLines("Some other file", "other_file.txt")
    make_page("single_file", resources="other_file.txt")
    expect_true(file.exists(file.path("single_file", "other_file.txt")))
  })

  # a file in a directory - should strip off all but the file name
  withr::with_tempdir({
    dir.create("foo")
    writeLines("Some other file", file.path("foo", "other_file.txt"))
    make_page("nested_file", resources=file.path("foo", "other_file.txt"))
    expect_true(file.exists(file.path("nested_file", "other_file.txt")))
  })

  # multiple files
  withr::with_tempdir({
    writeLines("File 1", "file1.txt")
    writeLines("File 2", "file2.txt")
    make_page("multiple_files", resources=c("file1.txt", "file2.txt"))
    expect_true(file.exists(file.path("multiple_files", "file1.txt")))
    expect_true(file.exists(file.path("multiple_files", "file2.txt")))
  })

  # directory - should copy the whole directory
  withr::with_tempdir({
    dir.create("foo")
    writeLines("File 1", file.path("foo", "file1.txt"))
    writeLines("File 2", file.path("foo", "file2.txt"))
    make_page("directory", resources="foo")
    expect_true(file.exists(file.path("directory", "foo", "file1.txt")))
    expect_true(file.exists(file.path("directory", "foo", "file2.txt")))
  })

  # expressions should be called from within the page's output_dir

})

test_that("make_test_page produces expected output", {
#   # make_test_page is a wrapper for make_page
#   # no need for extensive testing, just capture a snapshot
#   dir <- withr::local_tempdir()
#   make_test_page("default_test_page", output_dir = dir,)
#   expect_snapshot_file(file.path(dir, "default_test_page", "index.md"), name="default_test_page.md")
#
})

test_that("sanitize_page_name replaces spaces", {
  expect_identical("no-spaces-here", sanitize_page_name("no spaces here") )
})

