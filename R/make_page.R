# TODO: check for overwriting existing md file
# TODO: check for overwriting existing bundle directory
# TODO: should we confirm that boolean args are, in fact, bools?

make_page <- function(page_name, params=list(), output_dir = ".",
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
    dir.create(page_name)
    output_dir <- file.path(output_dir, page_name)
  }

  # write file
  write_md( yaml = params,
            filename = output_file, output_dir = output_dir)

  invisible(page_name)

}
