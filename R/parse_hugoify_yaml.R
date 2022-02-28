# TODO: parse_hugoify_yaml defaults to hugoify.yml or hugoify.yaml
# TODO: what exactly should parse_hugoify_yaml return?
#         - a collection of calls, but how should this be organized?
# TODO: should parse_hugoify_yaml accept an output_dir arg?

parse_hugoify_yaml <- function( yaml_file ) {

  y <- yaml::yaml.load_file(yaml_file)

  # needs a handler for images, but I haven't written it yet
  # should be something like:
  # y <- yaml::yaml.load(yaml, handlers = list(img = make_test_image(x)))

  # get output directory
  output_dir <- y[["output_dir"]]
  if ( is.null(output_dir) ) {
    output_dir <- "."
  }

  # content can be under the "content" or "home" key
  content <- "content" %in% names(y)
  home <- "home" %in% names(y)

  if (content & home) {
    stop("found both 'content' and 'home' keys in hugoify yaml config.\n",
         "hugoify must have either 'content' or 'home' but not both.")
  } else if (content) {
    #calls <- construct_page_calls(y[["content"]]
  } else if (home) {
    #calls <- construct_page_calls(y[["home"]])
  } else {
    stop("no site content found.\n",
         "hugoify yaml config must have a 'content' or 'home' key.")
  }

  # if ( is.null(y[["config"]]) ) {
  #   # error
  # } else {
  #   #calls[[length(calls) + 1]] <- file.copy(y[["config"]],
  #                                               #destination,
  #                                               #recursive=TRUE)
  # }
  #
  # if ( is.null(y[["theme"]]) ) {
  #   # error
  # } else {
  #   #calls[[length(calls) + 1]] <- file.copy(y[["theme"]],
  #   #destination,
  #   #recursive=TRUE)
  # }

}

construct_page_calls <- function() {

}
