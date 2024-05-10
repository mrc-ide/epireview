test_that("load_epidata loads data as expected", {

  out <- suppressWarnings(suppressMessages(load_epidata("marburg")))
  expect_equal(length(out), 4)
  expect_equal(names(out), c("articles", "params", "models", "outbreaks"))
  expect_equal(nrow(out$params), 70)
  expect_equal(nrow(out$models), 1)
  expect_equal(nrow(out$outbreaks), 23)
})
