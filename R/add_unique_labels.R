#' Make pretty labels for articles
#'
#' This function generates pretty labels for articles.
#' The labels are created by combining the surname of the first year and 
#' year of publication of an article.
#' If the surname is missing, we will use the first name. If both are missing, 
#' a warning is issued and the Covidence ID is used instead.
#' 
#'
#' @param articles A data frame containing information about the articles. This 
#' will typically be the output of \code{load_epidata_raw}.
#' @inheritParams load_epidata
#' @return A modified data frame with an additional column "article_label" 
#' containing the generated labels.
#' @examples
#' articles <- data.frame(
#'   first_author_surname = c("Smith", NA, "Johnson"),
#'   first_author_first_name = c(NA, "John", NA),
#'   year_publication = c(2010, NA, 2022),
#'   covidence_id = c("ABC123", "DEF456", "GHI789")
#' )
#' pretty_study_labels(articles)
#'
#' @export
pretty_article_label <- function(articles, mark_multiple) {
    assert_articles(articles)
    ## Warning if there are missing values for first_author_surname
    surname_missing <- is.na(articles$first_author_surname)
    if (sum(surname_missing) > 0) {
        warning(
            paste(
                "There are", sum(surname_missing), "articles with missing",
                "first author surname."
            )
        )
    }
    ## Warning if there are missing values for first_author_first_name
    ## first_author_first_name is only used if first_author_surname is missing
    ## so we check if both are missing
    both_missing <- surname_missing & is.na(articles$first_author_first_name)
    
    if (sum(both_missing) > 0) {
        warning(
            paste(
                "There are", sum(both_missing), "articles with missing",
                "first author surname and first author first name."
            )
        )
    }

    ## If both names are missing and covidence id is NA, prefix will be NA    
    all_missing <- both_missing & is.na(articles$covidence_id)
    if (sum(all_missing) > 0) {
        warning(
            paste(
                "There are", sum(all_missing), "articles with missing",
                "first author surname, first author first name, and covidence id."
            )
        )
    }
    ## If year_publication is missing
    year_missing <- is.na(articles$year_publication)
    if (sum(year_missing) > 0) {
        warning(
            paste(
                "There are", sum(year_missing), "articles with missing",
                "year of publication."
            )
        )
    }
    ## If year_publication is missing and covidence id is NA, suffix will be NA
    all_missing <- year_missing & is.na(articles$covidence_id)
    if (sum(all_missing) > 0) {
        warning(
            paste(
                "There are", sum(all_missing), "articles with missing",
                "year of publication and covidence id."
            )
        )
    }
    prefix <- ifelse(
        ! is.na(articles$first_author_surname),
        articles$first_author_surname,
        ifelse(
            ! is.na(articles$first_author_first_name),
            articles$first_author_first_name,
            articles$covidence_id  
        )
    )
    suffix <- ifelse(
        ! is.na(articles$year_publication),
        articles$year_publication,
        articles$covidence_id
    )
    articles$article_label <- paste(prefix, suffix)

    if (mark_multiple) {
      ## If there is more than one study from the same author in the same 
      ## year, they will end up with the same label. This is not ideal, so
      ## we will mark these studies with a number.      
      articles <- mark_multiple_estimates(articles, "article_label")
    }
    articles
}