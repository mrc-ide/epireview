test_that('Ebola articles, models, and parameters are ok', {


  articles <- load_epidata_raw("ebola", "article")
  models <- load_epidata_raw("ebola", "model")
  params <- load_epidata_raw("ebola", "parameter")

  ## 520 articles for Ebola
  expect_equal(nrow(articles), 520)
  expect_equal(
    length(unique(articles$covidence_id)), 520
  )


  expect_equal(nrow(models), 296)
  expect_equal(ncol(models), 13)
  expect_equal(
    length(unique(models$covidence_id)), 278
  )


  expect_equal(nrow(params), 1226)
  expect_equal(ncol(params), 61)
  expect_equal(
    length(unique(params$covidence_id)), 356
  )

  expect_snapshot(head(articles))
  expect_snapshot(tail(articles))

  expect_snapshot(head(models))
  expect_snapshot(tail(models))

  expect_snapshot(head(params))
  expect_snapshot(tail(params))

})
