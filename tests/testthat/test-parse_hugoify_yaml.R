# TODO: test parse_hugoify_yaml puts things in the right directory


test_that("parse_hugoify_yaml checks for expected keys", {

  yaml_file <- withr::local_file("hugoify.yml")

  # file with both "content" and "home" keys returns an error
  yaml <- paste("---", "content:", "home:", "config: c", "theme: t", "---", sep="\n")
  writeLines(yaml, yaml_file)
  expect_error(parse_hugoify_yaml(yaml_file), regexp="Found both 'content' and 'home' keys")

  # file with neither "content" nor "home" keys returns an error
  yaml <- paste("---", "config: c", "theme: t", "---", sep="\n")
  writeLines(yaml, yaml_file)
  expect_error(parse_hugoify_yaml(yaml_file), regexp="No site content found")

  # file with no config key returns a warning
  # and this warning is suppressed by 'quiet=TRUE'
  yaml <- paste("---", "content:", "theme: t", "---", sep="\n")
  writeLines(yaml, yaml_file)
  expect_warning(parse_hugoify_yaml(yaml_file), regexp="No hugo config file specified.")
  expect_warning(parse_hugoify_yaml(yaml_file, quiet=TRUE), regexp=NA)


  # file with no theme key returns a warning
  yaml <- paste("---", "content:", "config: c", "---", sep="\n")
  writeLines(yaml, yaml_file)
  expect_warning(parse_hugoify_yaml(yaml_file), regexp="No hugo theme directory specified.")
  expect_warning(parse_hugoify_yaml(yaml_file, quiet=TRUE), regexp=NA)

  # no theme warning is suppressed by 'quiet=TRUE' arg

  # file with all expected keys does not generate error or warning
  # - "content" or "home"
  # - "config"
  # - "theme"
  yaml <- paste("---", "content:", "config: c", "theme: t", "---", sep="\n")
  writeLines(yaml, yaml_file)
  expect_error(parse_hugoify_yaml(yaml_file), regexp=NA)

  yaml <- paste("---", "home:", "config: c", "theme: t", "---", sep="\n")
  writeLines(yaml, yaml_file)
  expect_error(parse_hugoify_yaml(yaml_file), regexp=NA)

})

