x <- suppressWarnings(suppressMessages(load_epidata('marburg')))
p <- x$params
test_that("filter_cols fails when wrong arguments are supplied", {

  ## Fails if columns are character and function
  ## is numeric

  expect_error(filter_cols(p, "parameter_type", ">", 21))
  expect_error(filter_cols(p, "parameter_type", "<", 21))

  ## Non-existent column
  expect_error(filter_cols(p, "parameter_xyz", "<", 21))
})

test_that("filter_cols works as expected", {

  ## Fails if columns are character and function
  ## is numeric
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
  expect_equal(nrow(out), 0)

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
    Other = 18,
    Unspecified = 5,
    unspecified = 5
  ))

  # Test case 2: Single value
  expect_equal(value_type_palette("Mean"), list(Mean = 16))

  # Test case 3: Multiple values
  expect_equal(value_type_palette(c("A", "B")), list(A = 16, B = 15))

  # Test case 4: Invalid length of input vector
  expect_error(value_type_palette(letters))
})


test_that("country_palette returns the correct palette", {

  # Test case 1: No argument provided.
  # Check for a named vector of length 35
  out <- country_palette()
  expect_equal(length(out), 35)
  expect_named(out)

  # Test case 2: Single country
  expect_equal(country_palette("Liberia"), c(Liberia = "#5A5156FF"))

  # Test case 3: Multiple countries
  expect_equal(country_palette(c("A", "B")), c(
    A = "#5A5156FF",
    B = "#E4E1E3FF"
  ))

  # Test case 4: More than 36 countries provided
  expect_error(country_palette(rep("Country", 37)))
})

test_that("reparam_gamma correctly reparameterizes the data frame", {
  # Create a sample data frame
  df <- data.frame(
    parameter_value = NA,
    distribution_type = "Gamma",
    distribution_par1_type = "Shape",
    distribution_par2_type = "Scale",
    distribution_par1_value = 1,
    distribution_par2_value = 10,
    parameter_value_type = NA,
    parameter_uncertainty_singe_type = NA,
    parameter_uncertainty_single_value = NA
  )

  # Call the reparam_gamma function
  df <- reparam_gamma(df)

  # Check if the reparameterization is correct
  expect_equal(df$parameter_value_type, "Mean")
  expect_equal(df$parameter_uncertainty_singe_type, "Standard Deviation")
  expect_equal(df$parameter_uncertainty_single_value, 10)
  expect_equal(df$parameter_value, 10)

  ## Run ebola parameters through this; we should expect
  ## to see Mean and Standard Deviation whereever distribution_type
  ## is Gamma and Shape and Scale are provided.
  x <- load_epidata('ebola')
  p <- x$params
  p <- reparam_gamma(p)
  idx <- which(
    p$distribution_type == "Gamma" &
    p$distribution_par1_type == "Shape" &
    p$distribution_par2_type == "Scale" &
    !is.na(p$distribution_par1_value) &
    !is.na(p$distribution_par2_value))

  g <- p[idx, ]

  expect_equal(unique(g$parameter_value_type), "Mean")
  expect_equal(unique(g$parameter_uncertainty_singe_type), "Standard Deviation")

})

test_that("reparam_gamma handles gamma distribution with Mean sd", {
  # Create a sample data frame
  df <- data.frame(
    parameter_value = NA,
    distribution_type = "Gamma",
    distribution_par1_type = "Shape",
    distribution_par2_type = "Mean sd",
    distribution_par1_value = 2,
    distribution_par2_value = 3,
    parameter_value_type = NA,
    parameter_uncertainty_singe_type = NA,
    parameter_uncertainty_single_value = NA
  )

  # Call the reparam_gamma function
  df <- reparam_gamma(df)

  # Check if the reparameterization is correct
  expect_equal(df$parameter_uncertainty_singe_type, "Standard Deviation")
  expect_equal(df$parameter_uncertainty_single_value, 3)
})