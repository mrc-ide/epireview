# Tests
test_that("Function creates a new var called parameter_type_short", {
  result_raw <- load_epidata_raw('lassa', table = 'parameter')
  result_raw <- short_parameter_type(result_raw)
  result <- load_epidata(pathogen = 'lassa')$params

  expect_true('parameter_type_short' %in% colnames(result))
  expect_true(all(! is.na(result$parameter_type_short)))

  chk1 <- unique(
    result$parameter_type_short[result$parameter_type %in% "Seroprevalence - PRNT"]
  )
  expect_equal(chk1, "seroprevalence_prnt")
})
