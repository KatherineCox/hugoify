# TODO: should write_md create directories if they don't exist?
# TODO: How should write_md handle missing yaml or content? And should it complain?

write_md <- function( yaml=NULL, content=NULL, filename, output_dir="." ) {

  # convert R list to yaml string and add the yaml delimiters
  yaml_string <- yaml::as.yaml(yaml)
  writeLines(text = c("---", yaml_string, "---\n", content),
             con = file.path(output_dir, filename))
}
