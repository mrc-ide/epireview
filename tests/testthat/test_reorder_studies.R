test_that("reorder_studies correctly reorders the data frame", {
  # Create a sample data frame; value is NA but bounds are provided
  df <- data.frame(
    parameter_value = c(10, 20, NA, 30, 15),
    parameter_lower_bound = c(5, 15, 20, 25, 10),
    parameter_upper_bound = c(15, 25, 30, 35, 20),
    population_country = c("c1", "c2", "c1", "c2", "c1"),
    article_label = letters[1:5]
  )
  df <- param_pm_uncertainty(df)
  df_reordered <- reorder_studies(df)
  expect_equal(
    levels(df_reordered$article_label), c("a", "e", "c", "b", "d"))

  ## Test with NAs present
  df <- data.frame(
    parameter_value = c(NA, 20, NA, 30, 15),
    parameter_lower_bound = c(NA, 15, 20, 25, 10),
    parameter_upper_bound = c(15, 25, 30, 35, 20),
    population_country = c("c1", "c2", "c1", "c2", "c1"),
    article_label = letters[1:5]
  )
  df <- param_pm_uncertainty(df)
  df_reordered <- reorder_studies(df)
  expect_equal(
    levels(df_reordered$article_label), c("e", "a", "c","b", "d")
  )

  ## Test with NAs present in the reorder_by column
  df <- data.frame(
    parameter_value = c(10, 20, NA, 30, 15),
    parameter_lower_bound = c(5, 15, 20, 25, 10),
    parameter_upper_bound = c(15, 25, 30, 35, 20),
    population_country = c("c1", "c2", NA, "c2", "c1"),
    article_label = c("a", "b", "c", "d", "e")
  )
  df <- param_pm_uncertainty(df)
  df_reordered <- reorder_studies(df)
  expect_equal(
    levels(df_reordered$article_label), c("a", "e", "b", "d", "c")
  )

  ## Reorder by a different column
  df$new_column <- c("A", "A", "B", "A", "A")
  df_reordered <- reorder_studies(df, "new_column")
  expect_equal(
    levels(df_reordered$article_label), c("a", "e", "b", "d", "c")
  )

})