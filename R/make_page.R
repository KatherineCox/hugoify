make_page <- function(page_name, bundle=TRUE) {

  # create the directory
  if (bundle) {
    dir.create(page_name)
  }

  invisible(page_name)

}


# make_page <- function(page_name, bundle=TRUE, output_dir=".") {
#   print(paste("making", page_name, "page"))
#
#   if (bundle) {
#
#     # make the directory
#     if (dir.exists(page_name)) {
#       #TODO: warning and/or have an overwrite argument
#     } else {
#       output_dir <= file.path(output_dir, page_name)
#       dir.create(output_dir)
#     }
#
#     # set the page name
#     output_file <- "index.md"
#
#
#   } else {
#     #TODO: error if list page, (or if has resources?)
#     output_file <- paste0( page_name, ".md")
#   }
#
#   write_md(filename = output_file, output_dir = output_dir)
#
# }
