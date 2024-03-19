test_mark_multiple_estimates <- function() {
  # Create a sample data frame
  df <- data.frame(
    article_label = c("A", "A", "B", "C", "C"),
    parameter_type = c("X", "X", "Y", "Z", "Z")
  )
  
  # Call the function
  result <- mark_multiple_estimates(df, "parameter_type")
  
  # Check if the article_label is modified correctly
  expect_equal(result$article_label, c("A 1", "A 2", "B", "C 1", "C 2"))
  
  # Check if the number of rows is unchanged
  expect_equal(nrow(result), nrow(df))

  ## If we now load Ebola data and check for studies with multiple estimates
  ## for the same parameter_type, we should find none.
  ebola <- load_epidata('ebola')
  params <- ebola$params
  dups <- as.data.frame(
    table(article_label = params[["article_label"]], 
    params = params[["parameter_type"]])
  ) 
 dups <- dups[dups$Freq > 1, ]
 expect_equal(nrow(dups), 0)

}

