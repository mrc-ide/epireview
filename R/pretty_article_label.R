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
#' pretty_article_label(articles, mark_multiple = TRUE)
#' @importFrom cli cli_warn
#' @export
pretty_article_label <- function(articles, mark_multiple) {
    assert_articles(articles)
  ## Warning if there are missing values for first_author_surname
  surname_missing <- is.na(articles$first_author_surname)

  is_are  <- c("is", "are")
  article_articles <- c("article", "articles")

  if (sum(surname_missing) > 0) {
    n_surname_missing <- sum(surname_missing)
    plural <- (n_surname_missing > 1) + 1

    cli_warn(
      paste(
        "There", is_are[plural], n_surname_missing, article_articles[plural],
        "with missing first author surname."
      )
    )
  }
  ## Warning if there are missing values for first_author_first_name
  ## first_author_first_name is only used if first_author_surname is missing
  ## so we check if both are missing
  both_missing <- surname_missing & is.na(articles$first_author_first_name)

  if (sum(both_missing) > 0) {
    n_both_missing <- sum(both_missing)
    plural <- (n_both_missing > 1) + 1

    cli_warn(
      paste("There", is_are[plural], n_both_missing, article_articles[plural],
            "with missing first author surname and first author first name."
      )
    )
  }

  ## If both names are missing and covidence id is NA, prefix will be NA
  all_missing <- both_missing & is.na(articles$covidence_id)
  if (sum(all_missing) > 0) {

    n_all_missing <- sum(all_missing)
    plural <- (n_all_missing > 1) + 1

    cli_warn(
      paste("There", is_are[plural], n_all_missing, article_articles[plural],
            "with missing first author surname, first author first name, and covidence id."
      )
      )
    }
    ## If year_publication is missing
    year_missing <- is.na(articles$year_publication)
    if (sum(year_missing) > 0) {
      n_year_missing <- sum(year_missing)
      plural <- (n_year_missing > 1) + 1

      cli_warn(
        paste("There", is_are[plural], n_year_missing, article_articles[plural],
              "with missing year of publication."
        )
      )
    }
    ## If year_publication is missing and covidence id is NA, suffix will be NA
    all_missing <- year_missing & is.na(articles$covidence_id)
    if (sum(all_missing) > 0) {
      n_all_missing <- sum(all_missing)
      plural <- (n_all_missing > 1) + 1

      cli_warn(
        paste("There", is_are[plural], n_all_missing, article_articles[plural],
              "with missing year of publication and covidence id."
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
      articles <- mark_multiple_estimates(
        articles, "article_label", label_type = "letters"
      )
    }
    articles
}


#' Include key article information when DOI is missing
#'
#' This function appends pretty_article_label to include the journal and we use
#' this information to fill in any entry where the DOI is missing. (Note: DOIs
#' were introduced in the late 1990s and so articles from before this time often
#' do not have one.)
#'
#' @param articles A data frame containing information about the articles. This
#' will typically be the output of \code{load_epidata_raw}.
#'
#'
#' @return A modified data frame with an updated column "doi"
#' with NA values replaced with either (1) article_label appended to include
#' journal where available or (2) just article_label when journal entry is NA.
#' @importFrom cli cli_abort
#' @export
#'
#' @examples
#' articles <- data.frame(
#'   doi = c("10.123", NA, "10.234"),
#'   article_label = c("Smith 2020", "Smith 1979", "Smith 2023"),
#'
#'   journal = c("Science", "Nature", "The Lancet")
#' )
#' update_article_info(articles)
#'
#'
update_article_info <- function(articles){

  ## does article_label column exist
  if(!"article_label" %in% colnames(articles)){
    cli_abort("Dataframe does not include article_label column. Please use function
    pretty_article_label before proceeding.")
  }

  ## Logic:
  ## if the entry has a doi then we don't have to do anything and we keep that
  ## column as it is
  ## if the entry doesn't have a doi we have two options:
  ## 1) journal is not NA and so we append journal to the article_label
  ## 2) journal is NA and so we just stick with the article_label as it was
  articles$article_info <- NA
  articles$article_info <- ifelse(
    !is.na(articles$doi),
    articles$doi,
    ifelse(!is.na(articles$journal),
      paste0(articles$article_label, " (", articles$journal, ")"),
      articles$article_label
    )
  )

  articles

}



