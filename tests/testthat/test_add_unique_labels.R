test_that("pretty article labels work", {
  mark_multiple <- TRUE
  # Test case 1: articles with all information available
  articles1 <- data.frame(
    first_author_first_name = "John",
    first_author_surname = "Smith",
    year_publication = 2022,
    covidence_id = 123,
    stringsAsFactors = FALSE
  )
  result1 <- pretty_article_label(articles1, mark_multiple = mark_multiple)
  expect_equal(result1$article_label, "Smith 2022")

  # Test case 2: articles with missing author information
  articles2 <- data.frame(
    first_author_first_name = "John",
    first_author_surname = NA,
    year_publication = 2022,
    covidence_id = 123,
    stringsAsFactors = FALSE
  )
  
  expect_warning(
    pretty_article_label(articles2, mark_multiple = mark_multiple), 
    "There are 1 articles with missing first author surname."
  )
  result <- pretty_article_label(articles2, mark_multiple = mark_multiple)
  expect_equal(result$article_label, "John 2022")

 articles2 <- data.frame(
    first_author_first_name = NA,
    first_author_surname = NA,
    year_publication = 2022,
    covidence_id = 123,
    stringsAsFactors = FALSE
  )
  expect_warning(pretty_article_label(articles2, mark_multiple = mark_multiple))
  
  result <- pretty_article_label(articles2, mark_multiple = mark_multiple)
  expect_equal(result$article_label, "123 2022")

 articles2 <- data.frame(
    first_author_first_name = NA,
    first_author_surname = NA,
    year_publication = NA,
    covidence_id = 123,
    stringsAsFactors = FALSE
  )
  expect_warning(pretty_article_label(articles2, mark_multiple = mark_multiple))
  result <- pretty_article_label(articles2, mark_multiple = mark_multiple)
  expect_equal(result$article_label, "123 123")

  # Test case 3: articles with multiple studies from the same author in the same year
  articles3 <- data.frame(
    first_author_first_name = c("John", "John", "Alice"),
    first_author_surname = c("Smith", "Smith", "Johnson"),
    year_publication = c(2022, 2022, 2022),
    covidence_id = c(123, 456, 789),
    stringsAsFactors = FALSE
  )

  result <- pretty_article_label(articles3, mark_multiple = mark_multiple)
  expect_equal(
    result$article_label, c("Smith 2022 (a)", "Smith 2022 (b)", "Johnson 2022")
  )
  
  result <- pretty_article_label(articles3, mark_multiple = FALSE)
  expect_equal(
    result$article_label, c("Smith 2022", "Smith 2022", "Johnson 2022")
  )
})

