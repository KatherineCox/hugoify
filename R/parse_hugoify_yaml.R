# TODO: parse_hugoify_yaml defaults to hugoify.yml or hugoify.yaml
# TODO: what exactly should parse_hugoify_yaml return?
#         - a collection of calls, but how should this be organized?
# TODO: should parse_hugoify_yaml accept an output_dir arg?
# TODO: should overwrite=FALSE (in e.g. file.copy)?

parse_hugoify_yaml <- function( yaml_file, output_dir=NULL, quiet=FALSE ) {

  y <- yaml::yaml.load_file(yaml_file)

  # needs a handler for images, but I haven't written it yet
  # should be something like:
  # y <- yaml::yaml.load(yaml, handlers = list(img = make_test_image(x)))


  # get output directory
  # arg takes priority. if it's NULL, then check the yaml
  if (is.null(output_dir)) {
    output_dir <- y[["output_dir"]]
  }
  # if there was nothing in the yaml, use the working directory
  if (is.null(output_dir)) {
    output_dir <- "."
  }

  # content can be under the "content" or "home" key
  content <- "content" %in% names(y)
  home <- "home" %in% names(y)

  if (content & home) {
    stop("Found both 'content' and 'home' keys in hugoify yaml config.\n",
         "hugoify must have either 'content' or 'home' but not both.")
  } else if (content) {
    #calls <- construct_page_calls( y[["content"]],
    #                               output_dir=file.path(output_dir, "content"))
  } else if (home) {
    #calls <- construct_page_calls( y[["home"]],
    #                               output_dir=file.path(output_dir, "content"))
  } else {
    stop("No site content found.\n",
         "hugoify yaml config must have a 'content' or 'home' key.")
  }

  if ( is.null(y[["config"]]) ) {
    # warning rather than error, in case someone just wants to build the content
    if (quiet==FALSE) {
      warning("No hugo config file specified.")
    }
  } else {
  #   #calls[[length(calls) + 1]] <- file.copy(y[["config"]],
  #                                               #destination,
  #                                               #recursive=TRUE)
  }

  if ( is.null(y[["theme"]]) ) {
    # warning rather than error, in case someone just wants to build the content
    if (quiet==FALSE) {
      warning("No hugo theme directory specified.")
    }
  } else {
  #   #calls[[length(calls) + 1]] <- file.copy(y[["theme"]],
  #   #destination,
  #   #recursive=TRUE)
  }

  calls
}

construct_page_calls <- function() {

}
