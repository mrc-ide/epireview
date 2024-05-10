# Create mock data
mock_data <- data.frame(
  parameter_type = c("Human delay - serial interval",
                     "Attack rate",
                     "Reproduction number (Basic R0)"),
  parameter_value = c(1, 2, 2.5),
  stringsAsFactors = FALSE
)

# Missing 'parameter_type' column data
mock_incomplete_data <- data.frame(
  parameter_value = c(1, 2, 2.5),
  stringsAsFactors = FALSE
)

# Tests
test_that("Function errors with incorrect 'data' type", {
  expect_error(get_parameter("not_a_dataframe", "Human delay - serial interval"))
})

test_that("Function errors with empty 'parameter_name'", {
  expect_error(get_parameter(mock_data, ""))
})

test_that("Function errors when 'parameter_type' column is missing", {
  expect_error(get_parameter(mock_incomplete_data, "Human delay - serial interval"))
})

test_that("Function handles non-existent 'parameter_name'", {
  expect_error(get_parameter(mock_data, "Nonexistent parameter"))
})

test_that("Function returns correct subset of data", {
  result <- get_parameter(mock_data, "Human delay - serial interval")
  expect_equal(nrow(result), 1)
  expect_equal(result$parameter_value, 1)
})
