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

new_hugoify_site_content <- function(page, is_list_page=NULL, bundle=NULL, children=list()){

  # error if page isn't a hugoify_page
  if (!inherits(page, "hugoify_page")) {
    stop("page must be a hugoify_page object.")
  }

  # error if children is not a list
  if (!is.list(children)) {
    stop("children must be a list of hugoify_site_content objects.")
  }

  # error if children aren't hugoify_site_content objects
  for (c in children) {
    if (!inherits(c, "hugoify_site_content")) {
      stop("children must be hugoify_site_content objects.")
    }
  }

  # just pass these on, we'll check them in the validator
  # adding them this way means they only get added if they're not null
  build_opts <- list()
  build_opts[["is_list_page"]] <- is_list_page
  build_opts[["bundle"]] <- bundle

  site_content <- structure(list(page = page,
                                 build_opts = build_opts,
                                 children = children
  ),
  class = "hugoify_site_content")
  site_content
}

validate_hugoify_site_content <- function(site_content){

  # error if page isn't a hugoify_site_content object
  if (!inherits(site_content, "hugoify_site_content")) {
    stop("Object is not of class 'hugoify_site_content'.", call. = FALSE)
  }

  # Check that it has the correct fields
  fields <- c("page", "build_opts", "children")
  for (f in fields) {
    if (! (f %in% names(site_content))) {
      stop("Missing ", f, " for page '", site_content$page$page_name, "'.", call. = FALSE)
    }
  }
  #
  # # validate_hugoify_page_(site_content$page)
  #
  # # validate_site_content_build_opts(site_content$build_opts)
  #
  # # error if children is not a list
  # if (!is.list(children)) {
  #   stop("children must be a list of hugoify_site_content objects.", call. = FALSE)
  # }
  #
  # # validate children
  # for (c in children) {
  #   vailidate_hugoify_site_content(c)
  # }

  invisible(site_content)
}

hugoify_site_content <- function(){

}
