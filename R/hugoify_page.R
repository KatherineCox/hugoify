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
  # Check that it has the correct fields
  fields <- c("page_name", "params", "content")
  for (f in fields) {
    if (! (f %in% names(page))) {
      stop("Missing ", f, " for page '", page$page_name, "'.", call. = FALSE)
    }
  }
  #
  # validate_hugoify_page_params(page$params)

  validate_hugoify_page_content(page$content)

  invisible(page)
}

validate_hugoify_page_content <- function(page_content) {
  if (!is.character(page_content)) {
    stop("Page content must be of type 'character'")
  }
}

hugoify_page <- function(){
  # that provides a convenient way for others to create objects of your class.
}
