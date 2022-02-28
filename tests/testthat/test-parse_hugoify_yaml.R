test_that("parse_hugoify_yaml checks for required keys", {

  yaml_file <- withr::local_file("hugoify.yml")

  # file with both "content" and "home" keys returns an error
  yaml <- paste("---", "content:", "home:", "config:", "theme:", "---", sep="\n")
  writeLines(yaml, yaml_file)
  expect_error(parse_hugoify_yaml(yaml_file), regexp="found both 'content' and 'home' keys")

  # file with neither "content" nor "home" keys returns an error
  yaml <- paste("---", "config:", "theme:", "---", sep="\n")
  writeLines(yaml, yaml_file)
  expect_error(parse_hugoify_yaml(yaml_file), regexp="no site content found")

  # file with no config key returns an error
  yaml <- paste("---", "content:", "theme:", "---", sep="\n")
  writeLines(yaml, yaml_file)
  expect_error(parse_hugoify_yaml(yaml_file), regexp="fix me")

  # file with no theme key returns an error
  yaml <- paste("---", "content:", "config:", "---", sep="\n")
  writeLines(yaml, yaml_file)
  expect_error(parse_hugoify_yaml(yaml_file), regexp="fix me")

  # file with all required keys does not error
  # - "content" or "home"
  # - "config"
  # - "theme"
  yaml <- paste("---", "content:", "config:", "theme:", "---", sep="\n")
  writeLines(yaml, yaml_file)
  expect_error(parse_hugoify_yaml(yaml_file), regexp=NA)

  yaml <- paste("---", "home:", "config:", "theme:", "---", sep="\n")
  writeLines(yaml, yaml_file)
  expect_error(parse_hugoify_yaml(yaml_file), regexp=NA)

})
