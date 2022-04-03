# # TODO: should we confirm that boolean args are, in fact, bools?
# # TODO: add markdown to default make_test_page content?
#
# make_page <- function(page_name, output_dir = ".", clean=FALSE,
#                       params=list(),  content=NULL, resources=NULL,
#                       is_list_page=FALSE, bundle=TRUE) {
#
#   # list pages must be bundles
#   if (is_list_page==TRUE & bundle==FALSE) {
#     stop("List pages must be bundles.\n",
#          "'bundle' must not be FALSE if 'is_list_page' is TRUE")
#   }
#
#   # if a page has resources, it must be a bundle
#   if ( !is.null(resources) & bundle==FALSE) {
#     stop("A page cannot have resources if it is not a bundle.\n",
#          "'resources' must not be NULL if 'bundle' is FALSE")
#   }
#
#   # check if the output directory exists
#   if (! dir.exists(output_dir) ) {
#     dir.create(output_dir, recursive=TRUE)
#   }
#
#   # clean up the page name
#
#   # create the page directory
#
#   # determine name of output file
#
#   # confirm that this file doesn't already exist (unless clean=TRUE)
#   f <- file.path(output_dir, output_file)
#   if (file.exists(f)) {
#     if (clean) {
#       unlink(f)
#     } else {
#       stop("' ", f, "' already exists.\n",
#            "To overwrite existing pages, set 'clean=TRUE'")
#     }
#   }
#
#   # write index file
#
#   # copy or create page resources
#
#   # if we were passed a single expression (rather than a list of expressions)
#   # wrap it in a list
#   # otherwise it will try to iterate over the expression and break
#   if (is.language(resources)) {
#     resources <- list(resources)
#   }
#
#   for (r in resources) {
#
#     # if it's a path, copy over the contents
#     if (typeof(r) == "character") {
#       file.copy(r, file.path(output_dir), recursive=TRUE)
#     }
#
#     # if it's an expression, evaluate it from the page's directory
#     else if (is.language(r)) {
#       withr::with_dir(output_dir, eval(r))
#     }
#
#   }
#
#   invisible(page_name)
#
# }
#
# # make_test_page <- function(page_name, params=list(title=page_name), content=NULL, ...) {
# #   lorum <- "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
# #
# #   if (is.null(content)) {
# #     content <- paste0("This is the **", page_name, "** page.\n\n", lorum)
# #   }
# #
# #   make_page(page_name, params=params, content=content, ...)
# # }
