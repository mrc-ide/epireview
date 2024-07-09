test_that("load_epidata loads data as expected", {

  # Check that the data loads without error
  expect_no_error(suppressMessages(suppressWarnings(load_epidata("marburg"))))

  # Check that the dimensions of the data loaded are correct
  out <- suppressWarnings(suppressMessages(load_epidata("marburg")))
  expect_equal(length(out), 4)
  expect_equal(names(out), c("articles", "params", "models", "outbreaks"))
  expect_equal(nrow(out$params), 70)
  expect_equal(nrow(out$models), 1)
  expect_equal(nrow(out$outbreaks), 23)

  # TODO: Add similar checks for ebola and lassa
  # Check that the data loads without error
  expect_no_error(suppressMessages(suppressWarnings(load_epidata("ebola"))))
  expect_no_error(suppressMessages(suppressWarnings(load_epidata("lassa"))))
})
