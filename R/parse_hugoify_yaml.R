# TODO: parse_hugoify_yaml defaults to hugoify.yml or hugoify.yaml
# TODO: what exactly should parse_hugoify_yaml return?
#         - a collection of calls, but how should this be organized?
# TODO: should parse_hugoify_yaml accept an output_dir arg?
# TODO: should overwrite=FALSE (in e.g. file.copy)?
# TODO: construct_page_calls handles params
# TODO: construct_page_calls handles output_dir
# TODO: construct_page_calls checks args before building make_page call
#       - think more about what checks are needed
# TODO: test make_page before construct_page_calls
#       - test files are run alphabetically, so can rename e.g. test-1-make_page.R
#       - https://testthat.r-lib.org/articles/parallel.html#changing-the-order-of-the-test-files

# For construct_page_calls, would it be better to return a list that can be coerced to a call?
# - Then we could still see the name of the function that was called
# - But, we might catch some extra errors by doing the coercion
#
# parse_hugoify_yaml <- function( yaml_file, output_dir=NULL, quiet=FALSE ) {
#
#   y <- yaml::yaml.load_file(yaml_file)
#
#   # TODO: needs a handler for images, but I haven't written it yet
#   # should be something like:
#   # y <- yaml::yaml.load(yaml, handlers = list(img = make_test_image(x)))
#
#
#   # get output directory
#   # arg takes priority. if it's NULL, then check the yaml
#   if (is.null(output_dir)) {
#     output_dir <- y[["output_dir"]]
#   }
#   # if there was nothing in the yaml, use the working directory
#   if (is.null(output_dir)) {
#     output_dir <- "."
#   }
#
#   # content can be under the "content" or "home" key
#   content <- "content" %in% names(y)
#   home <- "home" %in% names(y)
#
#   if (content & home) {
#     stop("Found both 'content' and 'home' keys in hugoify yaml config.\n",
#          "hugoify must have either 'content' or 'home' but not both.")
#   } else if (content) {
#     # don't do anything, this is fine as is
#     content_yaml <- y["content"]
#   } else if (home) {
#     # rename it, so the hugo directory will have the correct name
#     content_yaml <- y["home"]
#     names(content_yaml) <- "content"
#     #names(y)[ names(y)=="home" ] <- "content"
#   } else {
#     stop("No site content found.\n",
#          "hugoify yaml config must have a 'content' or 'home' key.")
#   }
#
#   # if there's only a home page with nothing underneath, it will be NULL
#   # set it to be an empty list instead
#   if (is.null(content_yaml[["content"]])) {
#     content_yaml[["content"]] <- list()
#   }
#   # the top level page must be a list page, so force this
#   content_yaml[["content"]][["is_list_page"]] <- TRUE
#
#
#
#   calls <- construct_page_calls( content_yaml, output_dir = output_dir)
#
#   if ( is.null(y[["config"]]) ) {
#     # warning rather than error, in case someone just wants to build the content
#     if (quiet==FALSE) {
#       warning("No hugo config file specified.")
#     }
#   } else {
#     calls[[length(calls) + 1]] <- call( "file.copy",
#                                         from = y[["config"]],
#                                         to = output_dir,
#                                         recursive=TRUE)
#   }
#
#   if ( is.null(y[["theme"]]) ) {
#     # warning rather than error, in case someone just wants to build the content
#     if (quiet==FALSE) {
#       warning("No hugo theme directory specified.")
#     }
#   } else {
#     calls[[length(calls) + 1]] <- call( "file.copy",
#                                         from = y[["theme"]],
#                                         to = output_dir,
#                                         recursive=TRUE)
#   }
#
#   calls
# }
#
construct_page_calls <- function( yaml_list, output_dir = "." ) {

  # YAML handling should be done in parse_hugoify_yaml
  # construct_page_calls expects it to already be converted to a list
  if (!is.list(yaml_list)) {
    stop("yaml_list must be a list.",
         "YAML strings and files must be read in with parse_hugoify_yaml()")
  }

  # make an empty list to hold output
  page_calls <- list()

  for ( page in names(yaml_list) ) {

    call_args <- yaml_list[[page]]

    # verify the arguments are valid
    for (arg in names(call_args)) {
      if (! (arg %in% names(formals(make_page))) ) {
        stop("Cannot construct call for page '", page, "'\n",
             "'", arg, "' is not a valid argument to make_page.")
      }
    }

    # construct the call for this page by adding the function and page_name
    # to the front of the args list
    call_args <- c( list( make_page, page_name = page ), call_args)

    # add the call for this page to the end of the list of page calls
    page_calls[[length(page_calls) + 1]] <- as.call(call_args)

  }

  page_calls
}
