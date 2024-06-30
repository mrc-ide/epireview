# Tests
test_that("Function creates a new var called parameter_type_short", {
  result_raw <- load_epidata_raw('lassa', table = 'parameter')
  result_raw <- short_parameter_type(result_raw)
  result <- load_epidata(pathogen = 'lassa')$params

  param_name_ebola <- load_epidata_raw('ebola', table = 'param_name')
  param_name_lassa <- load_epidata_raw('lassa', table = 'param_name')

  expect_equal(param_name_ebola, param_name_lassa)
  expect_equal(result_raw$parameter_type_short, result$parameter_type_short)
})
