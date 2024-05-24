#' Assign quality assessment score to each article
#'
#' @param articles data.frame  loaded from \code{load_epidata_raw} function
#' @param params data.frame  loaded from \code{load_epidata_raw} function
#' @param models data.frame  loaded from \code{load_epidata_raw} function
#' @details 
#' @return article data.frame with an updated column containing QS score out of 100.
#' @export
#' @importFrom package function
#' @examples
#' 
assign_qa_score <- function(articles, ignore_errors = FALSE) {
  
  assert_articles(articles)

  ## Check if everything is NA; test that actually works
  
  question_cols <- c(
    "qa_m1", "qa_m2", "qa_a3", "qa_a4", "qa_d5", "qa_d6", "qa_d7"
  )
  if (! all(question_cols %in% colnames(articles))) {
    msg1 <- "Not all QA questions are present in the data"
    msg2 <- "Did you forget to use load_epidata to load data?"
    stop(paste(msg1, msg2), call. = FALSE)
  }
  nquestions <- length(question_cols)
  answers <- articles[, question_cols]
  ## Check if there is any row where everything is NA
  check <- apply(answers, 1, function(x) sum(is.na(x)))
  all_nas <- check == nquestions
  if (any(all_nas)) {
    message(
      paste(
        sum(all_nas), "articles have all NAs for QA questions. 
            These are excluded for QA assessment, please check that this is correct."
      )
    )
    errors <- articles[all_nas, ]
  }
  n_non_nas <- nquestions - check
  articles$qs_denominator <- n_non_nas
  articles$qs_numerator <- apply(
    answers, 1, 
    function(x) sum(x %in% c('yes', 'Yes', 'YES', "1"), na.rm = TRUE) 
  )
  ## Articles with all NAs will have NA score
  articles$qs_score <- NA
  articles$qs_score[! all_nas] <- articles$qs_numerator[! all_nas] / 
    articles$qs_denominator[! all_nas]   
  
  list(articles = articles, errors = errors)
}


##' Quality assessment questionnaire
##' This function returns the list of 7 questions used to assess quality of 
##' articles.
##' @return a data.frame with the following columns: (a) qnames: these are the 
##' names of the corresponding columns in the articles data.frame; (b) qtext:
##' the text of the question, and (c) notes: any additional notes.
##' @export
qa_questions <- function() {
  question_cols <- c(
    "qa_m1", "qa_m2", "qa_a3", "qa_a4", "qa_d5", "qa_d6", "qa_d7"
  )
  question_text <- c(
    "Q1 Method: Clear & reproducible",
    "Q2 Method: Robust & appropriate",
    "Q3 Assumptions: Clear & reproducible",
    "Q4 Assumptions: Justified (published study or analysis of data)",
    "Q5 Data: Clearly described & reproducible",
    "Q6 Data: Issues discussed and acknowledged",
    "Q7 Data: Issues accounted for"
  )
  notes <- c(
    "Enough equations / reference to methodological papers / code to reproduce 
     the analysis",
    "subjective criteria",
    "are assumptions and parameter values used as inputs (e.g. the generation 
     time distribution for a branching process model) clearly stated?",
    "objective criteria",
    "Data issues are discussed and acknowledged",
    "Data issues are accounted for"
  )
  data.frame(qnames = question_cols, qtext = question_text, notes = notes)

}