#test that doi is included in params, outbreaks and models df using load_epidata function

testhat("doi included as column in params, outbreaks and models dfs",{

  lassa <- load_epidata("lassa")
  ebola <- load_epidata("ebola")
  marburg <- load_epidata("marburg")

  expect_true("doi" %in% colnames(lassa$params))
  expect_true("doi" %in% colnames(lassa$models))
  expect_true("doi" %in% colnames(lassa$outbreaks))

  expect_true("doi" %in% colnames(ebola$params))
  expect_true("doi" %in% colnames(ebola$models))

  expect_true("doi" %in% colnames(marburg$params))
  expect_true("doi" %in% colnames(marburg$models))
  expect_true("doi" %in% colnames(marburg$outbreaks))

}

)
