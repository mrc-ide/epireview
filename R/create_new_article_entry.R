#' Create new article entry
#'
#' @param pathogen name of pathogen
#' @param new_article all the required details for the new article
#'  
#' @return return new row of data to be added to the article data set using the
#' append_new_entry_to_table() function
#' @importFrom tibble as_tibble as_tibble_row
#' @importFrom validate validator confront summary
#' @importFrom dplyr rowwise mutate select filter
#' @importFrom stats na.omit
#' @importFrom utils globalVariables
#' @examples
#' create_new_article_entry(
#'   pathogen = "marburg",
#'   new_article = list(
#'     first_author_first_name = as.character("Joe"),
#'     first_author_surname = as.character("Blocks"),
#'     article_title = as.character("hello"),
#'     doi = as.character("NA"),
#'     journal = as.character("ABC"),
#'     year_publication = as.integer(2000),
#'     volume = as.integer(NA),
#'     issue = as.integer(NA),
#'     page_first = as.integer(NA),
#'     page_last = as.integer(NA),
#'     paper_copy_only = as.logical(NA),
#'     notes = as.character(NA),
#'     qa_m1 = as.integer(1),
#'     qa_m2 = as.integer(0),
#'     qa_a3 = as.integer(NA),
#'     qa_a4 = as.integer(1),
#'     qa_d5 = as.integer(0),
#'     qa_d6 = as.integer(NA),
#'     qa_d7 = as.integer(1)
#'   )
#' 
#' )
#' @export
create_new_article_entry <-
  function(pathogen = NA,
           new_article = list(
             first_author_first_name = as.character(NA),
             first_author_surname = as.character(NA),
             article_title = as.character(NA),
             doi = as.character(NA),
             journal = as.character(NA),
             year_publication = as.integer(NA),
             volume = as.integer(NA),
             issue = as.integer(NA),
             page_first = as.integer(NA),
             page_last = as.integer(NA),
             paper_copy_only = as.logical(NA),
             notes = as.character(NA),
             qa_m1 = as.integer(NA),
             qa_m2 = as.integer(NA),
             qa_a3 = as.integer(NA),
             qa_a4 = as.integer(NA),
             qa_d5 = as.integer(NA),
             qa_d6 = as.integer(NA),
             qa_d7 = as.integer(NA)
           )) {
    # assertions
  assert_pathogen(pathogen)

  #  read current article data for pathogen
    old_articles <- load_epidata_raw(
      pathogen = pathogen,
      "article"
    )

    new_row <- as_tibble_row(as.list(new_article))

    # generate the below quantities
    new_row$article_id <- max(old_articles$article_id) + 1
    new_row$covidence_id <- if (max(old_articles$covidence_id) > 1000000) {
      max(old_articles$covidence_id) + 1
    } else {
      max(old_articles$covidence_id) + 1000000
    }

    # Deal with R CMD Check "no visible binding for global variable"
    first_author_first_name <- first_author_surname <- article_title <-
      journal <- doi <- transmission_route <- assumptions <- code_available <-
      outbreak_date_year <- qa_m1 <- qa_m2 <- qa_a3 <- qa_a4 <- qa_d5 <- qa_d6 <-
      qa_d7 <- fails <- NULL

    # update this as new pathogens are added
    new_row$pathogen <- switch(pathogen,
      "marburg" = "Marburg virus",
      "ebola" = "Ebola virus",
      NA
    )
    
    ## Look for any additional columns that in the old data set
    ## and set them to NA with the same class as the corresponding
    ## column in the old data set.
    for (col in colnames(old_articles)) {
      if (!(col %in% colnames(new_row))) {
        old_class <- class(old_articles[[col]])
        new_row[[col]] <- as(NA, old_class)
      }
    }

    new_row <- new_row %>%
      rowwise() %>%
      mutate(score = mean(c(qa_m1, qa_m2, qa_a3, qa_a4, qa_d5, qa_d6, qa_d7),
        na.rm = TRUE
      )) %>%
      select(colnames(old_articles))

    sprintf("%s", colnames(old_articles))
    sprintf("%s", colnames(new_row))

    # check if article already exists in data by looking for doi
    if (is.character(new_row$doi) && new_row$doi %in% na.omit(old_articles$doi)) {
      stop("doi exists in data already!")
    }

    # validate that the entries make sense
    rules <- validator(
      author_first_name_is_character = is.character(first_author_first_name),
      author_surname_is_character = is.character(first_author_surname),
      article_title_is_character = is.character(article_title),
      journal_is_character = is.character(journal),
      doi_is_character = is.character(doi),
      transmission_route_is_character = is.character(transmission_route),
      assumptions_is_character = is.character(assumptions),
      code_available_check = code_available %in% c(0, 1, NA),
      outbreak_year_is_integer = is.integer(outbreak_date_year),
      outbreak_year_after_1800 = outbreak_date_year > 1800,
      outbreak_year_not_future = outbreak_date_year < (as.integer(
        substring(Sys.Date(), 1, 4)
      ) + 2),
      qa_m1 = qa_m1 %in% c(0, 1, NA),
      qa_m2 = qa_m2 %in% c(0, 1, NA),
      qa_a3 = qa_a3 %in% c(0, 1, NA),
      qa_a4 = qa_a4 %in% c(0, 1, NA),
      qa_d5 = qa_d5 %in% c(0, 1, NA),
      qa_d6 = qa_d6 %in% c(0, 1, NA),
      qa_d7 = qa_d7 %in% c(0, 1, NA)
    )

    rules_output <- confront(new_row, rules)
    rules_summary <- summary(rules_output)

    if (sum(rules_summary$fails) > 0) {
      stop(as_tibble(rules_summary) %>% filter(fails > 0))
    }

    return(new_row)
  }
