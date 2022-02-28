test_that("parse_hugoify_yaml checks for site content", {

  yaml_file <- withr::local_file("hugoify.yml")

  # file with both "content" and "home" keys returns an error
  yaml <- "---\ncontent:\nhome:\n---"
  writeLines(yaml, yaml_file)
  expect_error(parse_hugoify_yaml(yaml_file), regexp="found both 'content' and 'home' keys")

  # file with neither "content" nor "home" keys returns an error
  yaml <- "---\n---"
  writeLines(yaml, yaml_file)
  expect_error(parse_hugoify_yaml(yaml_file), regexp="no site content found")

  # file with either a "content" or "home" key does not error
  yaml <- "---\ncontent:\n---"
  writeLines(yaml, yaml_file)
  expect_error(parse_hugoify_yaml(yaml_file), regexp=NA)

  yaml <- "---\nhome:\n---"
  writeLines(yaml, yaml_file)
  expect_error(parse_hugoify_yaml(yaml_file), regexp=NA)

})
