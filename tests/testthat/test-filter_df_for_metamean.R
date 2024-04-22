df <- readRDS("tests/testthat/data/example_param_df.RDS")

test_that("filtering parameter dataframe for meta mean works",{

  ## Check that error messages are as expected
  required_cols <- c("parameter_value",
                     "parameter_unit",
                     "population_sample_size",
                     "parameter_value_type",
                     "parameter_uncertainty_singe_type",
                     "parameter_uncertainty_type",
                     "parameter_uncertainty_lower_value",
                     "parameter_uncertainty_upper_value")

  for(i in required_cols){
    df1 <- df[, -grep(i, colnames(df))]
    expected_err_msg <- paste0("df must have a column ",i,".")
    expect_error(filter_df_for_metamean(df1),expected_err_msg)
  }

  df1 <- df
  df1$parameter_unit[1] <- "Weeks"
  expect_error(filter_df_for_metamean(df1),
               "parameter_unit must be the same across all values.")

  ## Check that the resulting df has as many or fewer rows
  df2 <- filter_df_for_metamean(df)
  expect_true(dim(df2)[1] <= dim(df)[1])

  ## Check that the resulting df has the same columns
  ## + additional ones as expected
  expect_true(all(names(df) %in% names(df2)))
  extra_cols <- names(df2)[which(!(names(df2) %in% names(df)))]
  expect_true(all(extra_cols == c("xbar", "median", "q1", "q3", "min", "max")))
})
