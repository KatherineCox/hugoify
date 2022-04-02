# # TODO: should write_md create directories if they don't exist?
# # TODO: should it complain about missing yaml or content?
#
# write_md <- function( yaml=NULL, content=NULL, filename, output_dir="." ) {
#
#   text <- "---"
#
#   # by checking length, we cover yaml=NULL as well as yaml=list()
#   if (length(yaml) > 0) {
#     # convert R object to yaml string
#     yaml_string <- yaml::as.yaml(yaml)
#     text <- c(text, yaml_string)
#   }
#
#   text <- c(text, "---\n")
#
#   if (length(content) > 0) {
#     text <- c(text, content)
#   }
#
#   writeLines(text, con = file.path(output_dir, filename))
# }
