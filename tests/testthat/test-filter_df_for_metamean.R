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

  msg1 <- paste(
    "df must have columns named:", 
    paste(required_cols, collapse = ", ")
  )
  for(i in required_cols){
    df1 <- df[, -grep(i, colnames(df))]
    msg2 <- paste(". Columns missing:", i)
    expected_err_msg <- paste0(msg1, msg2)
    expect_error(filter_df_for_metamean(df1), expected_err_msg)
  }

  df1 <- df
  df1$parameter_unit[1] <- "Weeks"
  expect_error(filter_df_for_metamean(df1))

  ## The test data.frame has rows with NA values for parameter_value
  ## and non-na parameter_unit. Expect warning.
  expect_warning(filter_df_for_metamean(df))
  ## Check that the resulting df has as many or fewer rows
  df2 <- filter_df_for_metamean(df)
  expect_true(dim(df2)[1] <= dim(df)[1])

  ## Check that the resulting df has the same columns
  ## + additional ones as expected
  expect_true(all(names(df) %in% names(df2)))
  extra_cols <- names(df2)[which(!(names(df2) %in% names(df)))]
  expect_true(all(extra_cols == c("xbar", "median", "q1", "q3", "min", "max")))

  ## Mess up the data.frame and check that 
  ## there are no rows that should have been filtered out
  df$population_sample_size[1] <- NA
  ## Already 1 row with NA population_value that should be filtered out
  ## Find the first row with non-na value and set its unit to NA
  df$parameter_unit[which(!is.na(df$parameter_value))[1]] <- NA
  out <- filter_df_for_metamean(df)
  expect_true(all(!is.na(out$population_sample_size)))
  expect_true(all(!is.na(out$parameter_value)))
  expect_true(all(!is.na(out$parameter_unit)))
})