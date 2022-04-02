# #TODO: handle output_dir and overwritting all the way down the chain
#
# build_hugo_source <- function( config_file="hugoify.yml", output_dir="." ) {
#
#   # parse the config file
#   calls <- parse_hugoify_yaml(config_file, output_dir = output_dir)
#
#   # evaluate the calls
#   lapply(calls, eval)
#
#   invisible(config_file)
# }
