test_that("get_table_field_options returns expected output for 'model' table", {
  options <- get_table_field_options("marburg", table = "model")
  expect_equal(nrow(options), 11)
  expect_equal(ncol(options), 6)
})

test_that("get_table_field_options returns expected output for 'parameter' table", {
  options <- get_table_field_options("marburg", table = "parameter")
  expect_equal(nrow(options), 219)
  expect_equal(ncol(options), 22)

})

test_that("get_table_field_options returns expected output for 'outbreak' table", {
  options <- get_table_field_options("marburg", table = "outbreak")
  expect_equal(nrow(options), 219)
  expect_equal(ncol(options), 2)
  
})



test_that("get_table_field_options returns expected output for 'all' fields", {
  options <- get_table_field_options("marburg", "outbreak", field = "Outbreak country")
  expect_equal(nrow(options), 219)
  expect_equal(ncol(options), 1)
})