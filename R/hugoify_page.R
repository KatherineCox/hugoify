# a hugoify_page holds the content for the page (including its resources)
# it doesn't care about the site directory structure

new_hugoify_page <- function( page_name, params=list(), content="" ){

  # error if page_name isn't character
  if (!is.character(page_name)) {
    stop("page_name must be of type 'character'.")
  }
  if ( !( length(page_name)==1 ) ) {
    stop("page_name must be a character vector of length 1.")
  }

  page <- structure(list( page_name = page_name,
                          params = params,
                          content = content
                        ),
                    class = "hugoify_page")
  page
}

validate_hugoify_page <- function(page){

  # error if page isn't a hugoify_page
  if (!inherits(page, "hugoify_page")) {
    stop("Object is not of class 'hugoify_page'.", call. = FALSE)
  }

  # Check that it has the correct fields
  fields <- c("page_name", "params", "content")
  for (f in fields) {
    if (! (f %in% names(page))) {
      stop("Missing ", f, " for page '", page$page_name, "'.", call. = FALSE)
    }
  }

  # validate_hugoify_page_params(page$params)

  validate_hugoify_page_content(page$content)

  invisible(page)
}

validate_hugoify_page_content <- function(page_content) {
  if (!is.character(page_content)) {
    stop("Page content must be of type 'character'", call. = FALSE)
  }
}

hugoify_page <- function(){
  # hugoify_page(, build=FALSE, ... passed to build_hugo_source)

  #provides a convenient way for others to create objects of your class.

  # page <- new_hugoify_page()
  #
  # validate_hugoify_page(page)
  #
  # if (build) {
  #   return(build_hugo_source(page, ...))
  # }
  #
  # page
}
