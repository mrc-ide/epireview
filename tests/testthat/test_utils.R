test_that("filter_cols fails when wrong functions are supplied", {

  ## Fails if columns are character and function
  ## is numeric
  x <- fetch_data('marburg')
  p <- x$params
  expect_error(filter_cols(p, "parameter_type", ">", 21))
  expect_error(filter_cols(p, "parameter_type", "<", 21))

  ## This should work
  ## filter_cols(p, "parameter_value", "%in%", list(pval = c(20, 21)))
  ## filter_cols(p, "parameter_value", ">", list(pval = c(20, 21)))
})
