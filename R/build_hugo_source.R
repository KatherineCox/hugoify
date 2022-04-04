build_hugo_source <- function(page, output_dir=".",
                              is_list_page=FALSE, bundle=TRUE){

  if(!inherits(page, "hugoify_page")) {
    stop("'page' must be a 'hugoify_page' object.")
  }

  # list pages must be bundles
  if (is_list_page==TRUE & bundle==FALSE) {
    stop("List pages must be bundles.\n",
         "'bundle' must not be FALSE if 'is_list_page' is TRUE")
  }

  validate_hugoify_page(page)

  # if we get past the validator, it's a valid page, so we can build it

  # create output directory if necessary
  if (! dir.exists(output_dir) ) {
    dir.create(output_dir, recursive=TRUE)
  }

  # sanitize page name
  page_name <- sanitize_page_name(page$page_name)

  # create the page bundle directory
  if (bundle) {
    output_dir <- file.path(output_dir, page_name)

  #   # check if it already exists
  #   if ( dir.exists(output_dir) ) {
  #     if (clean) {
  #       unlink(output_dir, recursive = TRUE)
  #     } else {
  #       stop("' ", output_dir, "' already exists.\n",
  #            "To overwrite existing pages, set 'clean=TRUE'")
  #     }
  #   }

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

  # write index file
  write_md( yaml = page$params, content=page$content,
            filename = output_file, output_dir = output_dir)

  invisible(page)
}

sanitize_page_name <- function(page_name) {
  # yaml allows spaces in key names
  # replace spaces with underscores
  page_name <- gsub(" ", "-", page_name)
  page_name
}
