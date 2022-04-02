new_hugoify_page <- function(){
  #efficiently creates new objects with the correct structure
  page <- structure(list( params = list(),
                          content = ""
                        ),
                    class = "hugoify_page")
  page
}

validate_hugoify_page <- function(){
  # performs more computationally expensive checks to ensure that the object has correct values.
  # TODO: validate that it has the correct class? is this necessary?
}

hugoify_page <- function(){
  # that provides a convenient way for others to create objects of your class.
}
