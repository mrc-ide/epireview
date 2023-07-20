# Check that data exists and has minimum size

marburg_article_data <- load_epidata("article", "marburg")

test_that("Marburg articles have at least 58 lines",{
  expect_gte(dim(marburg_article_data)[1], 58)})
