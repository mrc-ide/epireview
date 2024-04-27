library(testthat)

# Test for assign_qa_score function
test_that("assign_qa_score correctly handles missing QA questions", {
  # Create a sample data frame with missing QA questions
  articles <- data.frame(
    qa_m1 = c(1, 2, NA),
    qa_m2 = c(NA, 3, 4),
    qa_a3 = c(5, NA, 6),
    qa_a4 = c(7, 8, NA),
    qa_d5 = c(NA, 9, 10),
    qa_d6 = c(11, NA, 12),
    qa_d7 = c(13, 14, NA)
  )
  
  # Call the assign_qa_score function
  result <- assign_qa_score(articles)
  
  # Check if the correct error message is thrown
  expect_error(result, "Not all QA questions are present in the data")
})

test_that("assign_qa_score correctly handles articles with all NAs for QA questions", {
  # Create a sample data frame with all NAs for QA questions
  articles <- data.frame(
    qa_m1 = c(NA, NA, NA),
    qa_m2 = c(NA, NA, NA),
    qa_a3 = c(NA, NA, NA),
    qa_a4 = c(NA, NA, NA),
    qa_d5 = c(NA, NA, NA),
    qa_d6 = c(NA, NA, NA),
    qa_d7 = c(NA, NA, NA)
  )
  
  # Call the assign_qa_score function
  result <- assign_qa_score(articles)
  
  # Check if the correct message is displayed
  expect_message(result, "articles have all NAs for QA questions.")
})