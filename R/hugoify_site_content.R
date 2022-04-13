# hugoify_site_content holds the structure of the site
# hugoify_site_content objects can be nested to represent a list page's children
# each node represents a page, and contains
# - page content (a hugoify_page object)
# - build options - whether the page is a list, whether it's a bundle
# - children - a list of hugoify_site objects representing child pages
#
# hugoify_site is:
# - a single hugoify_site_content object, containing all the site's content (nested)
# - hugo config file (or list)
# - pointer to theme directory
# - pointers to other hugo files, if needed
# TODO: do we need to worry about preventing site_content objects from being children of themselves?
# - is it possible to make a loop?  or will it always eventually terminate?

# TODO: move gather_page_build_opts call into user helper function
# - and have constructor accept a build_opts list
# TODO: pages are also acceptable children?

new_hugoify_site_content <- function(page, page_build_opts=list(), children=list()){

  # error if page isn't a hugoify_page
  if (!inherits(page, "hugoify_page")) {
    stop("page must be a hugoify_page object.")
  }

  # error if page_build_opts is not a list
  # otherwise, just pass them along, we'll check them in the validator
  if (!is.list(page_build_opts)) {
    stop("page_build_opts must be a list.")
  }

  # error if children is not a list
  if (!is.list(children)) {
    stop("children must be a list of hugoify_site_content objects.")
  }

  # error if children aren't hugoify_site_content objects
  for (child in children) {
    if (!inherits(child, "hugoify_site_content")) {
      stop("children must be hugoify_site_content objects.")
    }
  }

  site_content <- structure(list(page = page,
                                 page_build_opts = page_build_opts,
                                 children = children
  ),
  class = "hugoify_site_content")
  site_content
}

validate_hugoify_site_content <- function(site_content){

  # error if it isn't a hugoify_site_content object
  if (!inherits(site_content, "hugoify_site_content")) {
    stop("Object is not of class 'hugoify_site_content'.", call. = FALSE)
  }

  # Check that it has the correct fields
  fields <- c("page", "page_build_opts", "children")
  for (f in fields) {
    if (! (f %in% names(site_content))) {
      stop("Missing ", f, " for page '", site_content$page$page_name, "'.", call. = FALSE)
    }
  }

  validate_hugoify_page(site_content$page)

  # # validate_page_build_opts(site_content)
  #
  # # error if children is not a list
  # if (!is.list(children)) {
  #   stop("children must be a list of hugoify_site_content objects.", call. = FALSE)
  # }
  #
  # # validate children
  # for (c in children) {
  #   validate_hugoify_site_content(c)
  # }

  invisible(site_content)
}

hugoify_site_content <- function(page, is_list_page=NULL, bundle=NULL){

  page_build_opts <- gather_page_build_opts(match.call())

  site_content <- new_hugoify_site_content(page, page_build_opts)

  site_content

}

gather_page_build_opts <- function(args_list){
  # expect a list or call
  if (! (is.list(args_list) | is.call(args_list)) ) {
    stop("args_list should be a list or call")
  }

  # list the possible build options (args to build_hugo_source)
  # remove "page" argument - we only want the build options, not the page itself
  opts <- names(formals(build_hugo_source.hugoify_page))
  opts <- opts[-match("page", opts)]

  page_build_opts <- list()
  for (o in opts) {
    page_build_opts[[o]] <- args_list[[o]]
  }

  page_build_opts
}

validate_page_build_opts <- function(site_content){

  # error if it isn't a hugoify_site_content object
  if (!inherits(site_content, "hugoify_site_content")) {
    stop("Object is not of class 'hugoify_site_content'.", call. = FALSE)
  }

}
