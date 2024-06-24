test_that("Each covidence id is assigned a unique id across all tables", {
  articles <- load_epidata_raw("lassa", "article")
  params <- load_epidata_raw("lassa", "parameter")
  ## Check that there are duplicate ids in this dataset
  nids <- length(unique(params$id[params$covidence_id == 18]))
  fixed <- make_unique_id(articles, params)
  n_fixed_ids <- length(unique(fixed$id[fixed$covidence_id == 18]))
  expect_true(n_fixed_ids == 1L)

  ## Check that there is no id in fixed that is not in articles
  missing_ids <- setdiff(fixed$id, articles$id)
  expect_true(length(missing_ids) == 0L)

  ## Check that the downstream issue is resolved 
  ## i.e. article labels are not NA. This is how the issue was identified.
  lassa <- load_epidata("lassa")
  expect_true(all(!is.na(lassa[[2]]$article_label)))

})