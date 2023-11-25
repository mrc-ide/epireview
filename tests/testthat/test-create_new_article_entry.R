old_articles <- as_tibble(load_epidata_raw(pathogen = 'marburg', 'article'))
                                       
                                       
article_columns <- colnames(old_articles)
dummy_article = c(list("first_author_first_name" = 'Jane'),
                  list("first_author_surname"    = 'Doe'),
                  list("article_title"           = 'Title'),
                  list("doi"                     = '9999.1'),
                  list("journal"                 = 'Journal'),
                  list("year_publication"        = 1999),
                  list("volume"                  = 1),
                  list("issue"                   = 1),
                  list("page_first"              = 1),
                  list("page_last"               = 2),
                  list("paper_copy_only"         = FALSE),
                  list("notes"                   = 'None'),
                  list("qa_m1"                   = 1),
                  list("qa_m2"                   = 1),
                  list("qa_a3"                   = 1),
                  list("qa_a4"                   = 1),
                  list("qa_d5"                   = 1),
                  list("qa_d6"                   = 1),
                  list("qa_d7"                   = 1))

test_that("new article entry matches old article structure", {
  blank <- create_new_article_entry(pathogen='marburg')
  expect_named(blank, article_columns)

  dummy <- create_new_article_entry(pathogen = 'marburg', new_article = dummy_article)
  expect_named(dummy,article_columns)
  expect_s3_class(dummy,'data.frame',exact = FALSE)
  expect_identical(sapply(dummy, class),sapply(old_articles, class))

  check_score <- mean(c(dummy$qa_m1, dummy$qa_m2, dummy$qa_a3, dummy$qa_a4, dummy$qa_d5, dummy$qa_d6, dummy$qa_d7),
                      na.rm = TRUE)
  expect_equal(dummy$score,check_score)
})
