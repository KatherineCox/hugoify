# TODO: should we confirm that boolean args are, in fact, bools?
# TODO: actually think about output_dir
#       - I'm tossing it in right now so I can do snapshot testing in a tempdir
#       - need to come back and do tests / figure out handling of overwriting
# TODO: handle spaces in page_name. YAML permits spaces in keys
# TODO: add markdown to default make_test_page content?

make_page <- function(page_name, output_dir = ".", clean=FALSE,
                      params=list(),  content=NULL, resources=NULL,
                      is_list_page=FALSE, bundle=TRUE) {

  # list pages must be bundles
  if (is_list_page==TRUE & bundle==FALSE) {
    stop("List pages must be bundles.\n",
         "'bundle' must not be FALSE if 'is_list_page' is TRUE")
  }

  # check if the output directory exists
  if (! dir.exists(output_dir) ) {
    dir.create(output_dir, recursive=TRUE)
  }

  # clean up the page name
  page_name <- sanitize_page_name(page_name)

  # create the page directory
  if (bundle) {
    output_dir <- file.path(output_dir, page_name)

    # check if it already exists
    if ( dir.exists(output_dir) ) {
      if (clean) {
        unlink(output_dir, recursive = TRUE)
      } else {
        stop("' ", output_dir, "' already exists.\n",
             "To overwrite existing pages, set 'clean=TRUE'")
      }
    }

    dir.create(output_dir)
  }

  # determine name of output file
  if (bundle==FALSE) {
    output_file <- paste0(page_name, ".md")
  } else if (is_list_page) {
    output_file <- "_index.md"
  } else {
    output_file <- "index.md"
  }

  # confirm that this file doesn't already exist (unless clean=TRUE)
  f <- file.path(output_dir, output_file)
  if (file.exists(f)) {
    if (clean) {
      unlink(f)
    } else {
      stop("' ", f, "' already exists.\n",
           "To overwrite existing pages, set 'clean=TRUE'")
    }
  }

  # write index file
  write_md( yaml = params, content=content,
            filename = output_file, output_dir = output_dir)

  # copy or create page resources

  # if we were passed a single expression (rather than a list of expressions)
  # wrap it in a list
  # otherwise it will try to iterate over the expression and break
  if (is.language(resources)) {
    resources <- list(resources)
  }

  for (r in resources) {

    # if it's a path, copy over the contents
    if (typeof(r) == "character") {
      file.copy(r, file.path(output_dir), recursive=TRUE)
    }

    # if it's an expression, evaluate it from the page's directory
    else if (is.language(r)) {
      withr::with_dir(output_dir, eval(r))
    }

  }

  invisible(page_name)

}

# make_test_page <- function(page_name, params=list(title=page_name), content=NULL, ...) {
#   lorum <- "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
#
#   if (is.null(content)) {
#     content <- paste0("This is the **", page_name, "** page.\n\n", lorum)
#   }
#
#   make_page(page_name, params=params, content=content, ...)
# }

sanitize_page_name <- function(page_name) {
  # yaml allows spaces in key names
  # replace spaces with underscores
  page_name <- gsub(" ", "-", page_name)
  page_name
}
