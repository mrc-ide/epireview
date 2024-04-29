test_that("test that qa score is not assigned if all answers are NA",{
   articles <- suppressWarnings((load_epidata('ebola')[[1]]))
   test_article <- articles[1, ]
   test_article[, c("qa_m1", "qa_m2", "qa_a3", "qa_a4", "qa_d5", "qa_d6", "qa_d7")] <- NA
   
   expect_message(assign_qa_score(test_article, TRUE))
   expect_error(assign_qa_score(test_article, FALSE))
   expect_error(
    assign_qa_score(subset(test_article, select = -c(qa_m1)), FALSE),
    "Not all QA questions are present in the data"
   )
  
  out <- suppressMessages(assign_qa_score(test_article, TRUE))
  expect_true(is.na(out$articles$qa_score))
  expect_equal(out$articles$qa_denominator, 0)
  expect_equal(out$articles$qa_numerator, 0)

  test_article <- rbind(test_article, articles[2, ])
  out <- suppressMessages(
    assign_qa_score(test_article, TRUE)
  )
  expect_true(is.na(out$articles$qa_score[1]))
  expect_equal(out$articles$qa_denominator[1], 0)
  expect_equal(out$articles$qa_numerator[1], 0)
  expect_equal(out$articles$qa_denominator[2], 3)
  expect_equal(out$articles$qa_numerator[2], 3)
  expect_identical(out$errors, test_article[1, ])

})