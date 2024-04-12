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
assign_qa_score <- function(articles, params, models, ignore_error = FALSE) {
  
  ##assert_articles(articles)
  ##assert_params(params)
  ##assert_models(models)
  
  ## Check if everything is NA; test that actially works
  
  question_cols <- c("qa_m1", "qa_m2", "qa_a3", "qa_a4", "qa_d5", "qa_d6", "qa_d7")
  answers <- articles[, question_cols]
  ## Check if there is any row where everything is NA
  check <- apply(answers, 1, function(x) sum(is.na(x)))
  ## Should we expect 6 NAs for Ebola?? Check
  if (any(check %in% 7)) {
    warning("Some of the articles have all NAs for QA questions. 
            These are excluded for QA assessment, please check that this is correct.")
    errors <- articles[check %in% 7, ]
    
  }
  
  ## Check if an article has only reported a model
  model_only <- ! articles$id %in% params$id
  ## Additional checks here e.g., whether the model is theoretical only
  ## theoretical_only 
  
  ## convert every yes to 1, every no to 0
  ## Is there a model only article where non-model only questions have been answeed?
  ## Return these as potential errors.
  
  
  ## Assuming that we have everything in order.
  ## If only model has been extracted, denominator is 4
  ## sum answers to Questions 1 to 4
  
  ## If any parameter has been extracted, appropriate denominator is the number of non-NAs
  ## 3 and 4 could be NA depending on what has been extracted;
  ## other should not be NA if any parameter has been extracted. so if they are, then flag to use
  
  ## outbreak only??? No QA score assigned because only one question has been answered.
  
  ## We are ready to assign QA score only if error data.frame is empty.
  ## ignore_error is TRUE.
  ## If TRUE everything is scored out of number of non-NAs
  
  ## article with a column article_type (only_model_extracted, parameter_extracted, 
  ## both_extracted; OR )
  ## and a column called QA_score
  
  list(articles = articles, errors = errors)
}

##' 
##' @return article data.frame with an updated column  article_type
assign_article_type <- function(articles) {
  
}
## Look-up table.
verbose_questions <- function() {
  q_m
}