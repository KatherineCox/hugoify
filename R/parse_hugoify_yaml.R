# TODO: parse_hugoify_yaml defaults to hugoify.yml or hugoify.yaml
# TODO: what should parse_hugoify_yaml

parse_hugoify_yaml <- function( yaml_file ) {

  y <- yaml::yaml.load_file(yaml_file)

  # needs a handler for images, but I haven't written it yet
  # should be something like:
  # y <- yaml::yaml.load(yaml, handlers = list(img = make_test_image(x)))

  # content can be under the "content" or "home" key
  content <- "content" %in% names(y)
  home <- "home" %in% names(y)

  if (content & home) {
    stop("found both 'content' and 'home' keys in hugoify yaml config.\n",
         "hugoify must have either 'content' or 'home' but not both.")
  } else if (content) {
    #return( construct_page_calls(y[["content"]]) )
  } else if (home) {
    #return( construct_page_calls(y[["home"]]) )
  } else {
    stop("no site content found.\n",
         "hugoify yaml config must have a 'content' or 'home' key.")
  }

}

construct_page_calls <- function() {

}
