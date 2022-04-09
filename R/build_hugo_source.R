# TODO: I am unclear on where I should specify the output_dir arg
# - it seems to be least complicated for the S3 generic to only take x and ...
# https://stackoverflow.com/questions/43717794/best-practice-for-defining-s3-methods-with-different-arguments
# - but DRY - aren't all methods going to want an output_dir?
# - also this fails to catch e.g. misspelled arguments - https://adv-r.hadley.nz/s3.html#s3-arguments

# TODO: think about organization
# - should build_hugo_source.site_content be a wrapper for build_hugo_source.page, or vice versa

build_hugo_source <- function(x, ...) {
  UseMethod("build_hugo_source")
}

build_hugo_source.hugoify_page <- function(page, output_dir=".",
                                           is_list_page=FALSE, bundle=TRUE){

  # list pages must be bundles
  if (is_list_page==TRUE & bundle==FALSE) {
    stop("List pages must be bundles.\n",
         "'bundle' must not be FALSE if 'is_list_page' is TRUE")
  }

  validate_hugoify_page(page)

  # make a site content object and validate it
  # this will validate the page object itself, plus the build options
  # page_build_opts <- gather_page_build_opts(match.call())
  # site_content <- new_hugoify_site_content(page, page_build_opts)
  # validate_hugoify_site_content(site_content)

  # if we get past the validators we can build it

  # create output directory if necessary
  if (! dir.exists(output_dir) ) {
    dir.create(output_dir, recursive=TRUE)
  }

  # sanitize page name
  page_name <- sanitize_name(page$page_name)

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

sanitize_name <- function(name) {
  # yaml allows spaces in key names
  # replace spaces with underscores
  name <- gsub(" ", "-", name)
  name
}
