# TODO: check for overwriting existing md file
# TODO: check for overwriting existing bundle directory
# TODO: should we confirm that boolean args are, in fact, bools?
# TODO: actually think about output_dir
#       - I'm tossing it in right now so I can do snapshot testing in a tempdir
#       - need to come back and do tests / figure out handling of overwriting
# TODO: handle spaces in page_name. YAML permits spaces in keys
# TODO: add markdown to default make_test_page content?

make_page <- function(page_name, params=list(), output_dir = ".", content=NULL,
                      is_list_page=FALSE, bundle=TRUE) {

  # list pages must be bundles
  if (is_list_page==TRUE & bundle==FALSE) {
    stop("List pages must be bundles.\n",
         "'bundle' must not be FALSE if 'is_list_page' is TRUE")
  }

  # determine name of output file
  if (bundle==FALSE) {
    output_file <- paste0(page_name, ".md")
  } else if (is_list_page) {
    output_file <- "_index.md"
  } else {
    output_file <- "index.md"
  }

  # create the page directory
  if (bundle) {
    output_dir <- file.path(output_dir, page_name)
    dir.create(output_dir)
  }

  # write file
  write_md( yaml = params, content=content,
            filename = output_file, output_dir = output_dir)

  invisible(page_name)

}

make_test_page <- function(page_name, params=list(title=page_name), content=NULL, ...) {
  lorum <- "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

  if (is.null(content)) {
    content <- paste0("This is the **", page_name, "** page.\n\n", lorum)
  }

  make_page(page_name, params=params, content=content, ...)
}
