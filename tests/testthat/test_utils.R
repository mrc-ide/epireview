test_that("filter_cols fails when wrong arguments are supplied", {

  ## Fails if columns are character and function
  ## is numeric
  x <- fetch_data('marburg')
  p <- x$params
  expect_error(filter_cols(p, "parameter_type", ">", 21))
  expect_error(filter_cols(p, "parameter_type", "<", 21))

  ## Non-existent column
  expect_error(filter_cols(p, "parameter_xyz", "<", 21))
})

test_that("filter_cols works as expected", {

  ## Fails if columns are character and function
  ## is numeric
  x <- fetch_data('marburg')
  p <- x$params
  ## Test column of each type: numeric, factor, and character
  out <- filter_cols(p, "parameter_value", "in", list(pval = c(20, 21)))
  expect_in(unique(out$parameter_value), c(20, 21))

  out <- filter_cols(p, "parameter_value", ">", 20)
  vals <- all(out$parameter_value > 20, na.rm = TRUE)
  expect_true(vals)

  out <- filter_cols(
    p, "population_country", "in", list(pc = c("South Africa", "Germany"))
  )
  vals <- unique(out$population_country)
  expect_in(vals, c("South Africa", "Germany"))

  out <- filter_cols(p, "population_country", "==", "xyz")
  ## Fails because NA is matched.
  ## TODO check why we have rows with all NAs and whether they need
  ## to be removed.
  expect_equal(nrow(out), 0)

})


