#' Assign quality assessment score to each article
#'
#' @param articles data.frame loaded from \code{load_epidata} function
#' @param ignore_errors logical; if \code{TRUE}, the function will assign QA scores
#' where possible (i.e. where all answers to quality assessment questions
#' are not NA) and set the QA score to NAfor articles where all answers are NA.
#' If \code{FALSE}, an error is thrown instead.
#' @details
#' We have used a bespoke 7 question quality assessment (QA) questionnaire to
#' assess the quality of articles. The questions can be retrieved using the
#' \code{qa_questions} function. The function assigns a QA score to each article
#' as the number of questions answered 'yes' divided by the total number of
#' questions answered (an answer might be NA if the question is not relevant to
#' the article under consideration).
#' Articles with all NA answers are excluded from the QA unless \code{ignore_errors}
#' is set to \code{TRUE}.
#' @return a named list consisting of two elements. The first element of the
#' list is the article data.frame with an updated column containing three new columns:
#' \code{qs_denominator} (total number of questions answered), \code{qs_numerator}
#' (number of questions answered 'yes') and \code{qa_score} (QA score). The second
#' element of the list (named errors) is a data.frame containing articles
#' with all NA answers.
#' @seealso \code{\link{qa_questions}}
#' @importFrom cli cli_inform cli_abort
#' @export
#' @examples
#' lassa <- load_epidata("lassa")
#' lassa_qa <- assign_qa_score(lassa$articles, ignore_errors = FALSE)
#' head(lassa_qa$articles[, c("qa_denominator", "qa_numerator", "qa_score")])
assign_qa_score <- function(articles, ignore_errors = FALSE) {
  assert_articles(articles)

  errors <- NULL

  question_cols <- qa_questions()$qnames
  if (!all(question_cols %in% colnames(articles))) {
    msg1 <- "Not all QA questions are present in the data"
    msg2 <- "Did you forget to use load_epidata to load data?"
    cli_abort(paste(msg1, msg2), call = NULL)
  }
  nquestions <- length(question_cols)
  answers <- articles[, question_cols]
  ## Check if there is any row where everything is NA
  check <- apply(answers, 1, function(x) sum(is.na(x)))
  all_nas <- check == nquestions
  if (any(all_nas)) {
    cli_inform(
      paste(
        sum(all_nas), "articles have all NAs for QA questions; please check that
         this is expected. QA score for these articles is set to NA."
      )
    )
    errors <- articles[all_nas, ]
    if (!ignore_errors) {
      cli_abort("Please correct the errors before proceeding", call = NULL)
    }
  }
  n_non_nas <- nquestions - check
  articles$qa_denominator <- n_non_nas
  articles$qa_numerator <- apply(
    answers, 1,
    function(x) sum(x %in% c("yes", "Yes", "YES", "1"), na.rm = TRUE)
  )
  ## Articles with all NAs will have NA score
  articles$qa_score <- NA
  articles$qa_score[!all_nas] <- articles$qa_numerator[!all_nas] /
    articles$qa_denominator[!all_nas]

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
    "Enough equations/reference to methodological papers/code to reproduce
     the analysis",
    "subjective criteria",
    "are assumptions and parameter values used as inputs (e.g. the generation
     time distribution for a branching process model) clearly stated?",
    "objective criteria",
    "Data is clearly described and reproducible",
    "Data issues are discussed and acknowledged",
    "Data issues are accounted for"
  )
  data.frame(qnames = question_cols, qtext = question_text, notes = notes)
}
