#test that doi is included in params, outbreaks and models df using load_epidata function

test_that("article_info included as column in params, outbreaks and models dfs",{

  lassa <- load_epidata("lassa")
  expect_true("article_info" %in% colnames(lassa$params))
  expect_true("article_info" %in% colnames(lassa$models))
  expect_true("article_info" %in% colnames(lassa$outbreaks))


}

)
