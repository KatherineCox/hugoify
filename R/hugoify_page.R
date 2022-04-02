new_hugoify_page <- function( params=list(), content="" ){
  page <- structure(list( params = params,
                          content = content
                        ),
                    class = "hugoify_page")
  page
}

validate_hugoify_page <- function(page){
  # Check that it has the correct fields
  fields <- c("params", "content")
  for (f in fields) {
    if (! (f %in% names(page))) {
      stop("Missing page ", f, call. = FALSE)
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
