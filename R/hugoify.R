build_hugo_source <- function( config_file="hugoify.yml" ) {

  # parse the config file
  calls <- parse_hugoify_yaml(config_file)

  # evaluate the calls
  lapply(calls, eval)

  invisible(config_file)
}
