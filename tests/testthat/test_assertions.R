test_that("test assert_pathogen",{
  expect_true(assert_pathogen("marburg"))
  expect_error(assert_pathogen("non-existent disease"))
})

test_that("test assert_table",{
  expect_true(assert_table("outbreak"))
  expect_error(assert_table("non-output"))
})

test_that("test assert_string",{
  expect_error(assert_string(5))
  expect_error(assert_string())
  expect_error(assert_string(NA))
  expect_error(assert_string(NULL))
})


