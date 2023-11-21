testthat("load_epidata loads data as expected", {

  out <- load_epidata("marburg")
  expect_equal(length(out), 3)
  expect_equal(names(out), c("params", "models", "outbreaks"))
  expect_equal(nrow(out$params), 70)
  expect_equal(nrow(out$models), 1)
  expect_equal(nrow(out$outbreaks), 23)
})
