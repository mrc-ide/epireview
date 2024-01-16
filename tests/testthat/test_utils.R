test_that("filter_cols fails when wrong arguments are supplied", {

  ## Fails if columns are character and function
  ## is numeric
  x <- load_epidata('marburg')
  p <- x$params
  expect_error(filter_cols(p, "parameter_type", ">", 21))
  expect_error(filter_cols(p, "parameter_type", "<", 21))

  ## Non-existent column
  expect_error(filter_cols(p, "parameter_xyz", "<", 21))
})

test_that("filter_cols works as expected", {

  ## Fails if columns are character and function
  ## is numeric
  x <- load_epidata('marburg')
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


test_that("shape_palette returns NULL when shape_by is not 'value_type'", {
  actual_palette <- shape_palette(shape_by = "other_type")
  expect_null(actual_palette)
})

test_that("value_type_palette returns the correct values", {
  # Test case 1: Missing argument
  expect_equal(value_type_palette(), list(
    Mean = 16,
    mean = 16,
    average = 16,
    Median = 15,
    median = 15,
    `Std Dev` = 17,
    `std dev` = 17,
    sd = 17,
    other = 18,
    Other = 18
  ))

  # Test case 2: Single value
  expect_equal(value_type_palette("Mean"), list(
    Mean = 16
  ))

  # Test case 3: Multiple values
  expect_equal(value_type_palette(c("Mean", "Median")), list(
    Mean = 16,
    Median = 15
  ))

  # Test case 4: Invalid length of input vector
  expect_error(value_type_palette(letters))
})