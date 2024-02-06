test_that("reorder_studies correctly reorders the data frame", {
  # Create a sample data frame; value is NA bit bounds are provided
  df <- data.frame(
    parameter_value = c(10, 20, NA, 30, 15),
    parameter_lower_bound = c(5, 15, 20, 25, 10),
    parameter_upper_bound = c(15, 25, 30, 35, 20),
    population_country = c("c1", "c2", "c1", "c2", "c1"),
    article_label = letters[1:5]
  )
  df_reordered <- reorder_studies(df)
  expect_equal(
    levels(df_reordered$y), c("a", "e", "c", "b", "d"))

  ## Test with NAs present
  df <- data.frame(
    parameter_value = c(NA, 20, NA, 30, 15),
    parameter_lower_bound = c(NA, 15, 20, 25, 10),
    parameter_upper_bound = c(15, 25, 30, 35, 20),
    population_country = c("c1", "c2", "c1", "c2", "c1"),
    article_label = letters[1:5]
  )
  df_reordered <- reorder_studies(df)
  expect_equal(
    levels(df_reordered$y), c("e", "c", "a","b", "d"))

})