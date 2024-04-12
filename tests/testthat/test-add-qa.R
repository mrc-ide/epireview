test_that("test that qa score is not assigned if all answers are NA",{
   articles <- load_epidata_raw('ebola', 'article')
   test_article <- articles[1, ]
   test_article[, c("qa_m1", "qa_m2", "qa_a3", "qa_a4", "qa_d5", "qa_d6", "qa_d7")] <- NA
   expect_warning(
     assign_qa_score(test_article, NULL, NULL)
   )
})