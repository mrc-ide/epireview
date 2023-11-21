##' Short labels parameters for use in figures
##'
##' This function assigns short labels to otherwise very long parameter
##' names. It is generally not intended to be called directly but is used by
##' \code{\link{prep_data_forest_plot}}
##'
##' @param x data.frame containing a column called "parameter_type"
##' @param parameter_type_full optional. User can specify the full value of a parameter type not already included in the function.
##' @param parameter_type_short optional. Shorter value of parameter_type_full
##' @return
##' @author Sangeeta Bhatia
short_parameter_type <- function(x, parameter_type_full, parameter_type_short) {

  x$parameter_type_short <- case_when(
    x$parameter_type == "Reproduction number (Basic R0)" ~ "Basic (R0)",
    x$parameter_type == "Reproduction number (Effective, Re)" ~ "Effective (Re)",
    x$parameter_type == "Human delay - time symptom to outcome" &
      x$riskfactor_outcome == "Death" ~ "Time symptom to outcome (Death)",
    x$parameter_type == "Human delay - time symptom to outcome" &
      x$riskfactor_outcome == "Other" ~ "Time symptom to outcome (Other)"
  )

  if (! missing(parameter_type_full) & ! missing(parameter_type_short)) {
    x$parameter_type_short <- case_when(
      x$parameter_type == parameter_type_full ~ parameter_type_short
    )
  } else if (! missing(parameter_type_full) & missing(parameter_type_short)) {
    stop("Please specify both parameter_type_full and parameter_type_short")
  } else if ( missing(parameter_type_full) & ! missing(parameter_type_short)) {
    stop("Please specify both parameter_type_full and parameter_type_short")
  }

  x
}

#' Filter columns of a data frame based on specified conditions.
#'
#' This function filters the rows of a data frame based on specified conditions for
#' selected columns.
#'
#' @param x A data frame.
#' @param cols A character vector specifying the columns to be filtered.
#' @param funs A character vector specifying the filter functions for each column.
#'   Each function must be one of "in", "==", ">", "<" in quotes.
#' @param vals A list of values to be used for filtering columns in \code{cols}.
#'
#' @return A data frame with rows filtered based on the specified conditions.
#'
#' @examples
#' x <- load_epidata('marburg')
#' p <- x$params
#' filter_cols(p, "parameter_type", "==", "Attack rate")
#' filter_cols(p, "parameter_type", "in", list(parameter_type = c("Attack rate", "Seroprevalence - IFA")))
#'
#'
#' @export
filter_cols <- function(x, cols, funs = c("in", "==", ">", "<"), vals) {

  if (length(cols) != length(funs)) {
    stop("Length of arguments cols is different from that of funs.
          Please specify one function for each column in cols")
  }

  if (length(funs) != length(vals)) {
    stop("Length of arguments funs is different from that of vals.
          Please specify values to be used for filtering columns in
         cols")
  }

  match.arg(funs)

  if (any(! cols %in% colnames(x))) {
    msg <- "cols must be present in x as a column. Offending cols are "
    stop(paste(msg, toString(cols[! cols %in% colnames(x)])))
  }

  ## Make sure character and factor columns take in %in% or ==
  char_cols <- sapply(
    cols,
    function(col) is.character(x[[col]]) | is.factor(x[[col]])
  )

  nonchar_funs <- sapply(
    funs, function(fun) fun %in% c(">", "<")
  )

  any_match <- any(char_cols & nonchar_funs)

  if (any_match) {
    msg <- "Non-character filter functions supplied to character columns. Offending columns are"
    stop(paste(msg, toString(cols[any_match])))
  }

  filter <- rep(TRUE, nrow(x))

  for (idx in seq_along(cols)) {
    this_col <- cols[[idx]]
    this_val <- vals[[idx]]
    this_fun <- funs[[idx]]
    filter <- switch(
      this_fun,
      ## Make sure NA is not matched
      "in" = filter & (!is.na(x[[this_col]]) & x[[this_col]] %in% this_val),
      ">" = filter & (!is.na(x[[this_col]]) & x[[this_col]] > this_val),
      "<" = filter & (!is.na(x[[this_col]]) & x[[this_col]] < this_val),
      "==" = filter & (!is.na(x[[this_col]]) & x[[this_col]] == this_val),
      )
  }

  x[filter, ]
}



##' Retrieve pathogen-specific data
##'
##' @details
##' The data extracted in the systematic review has been stored in three
##' files - one each for articles, parameters, and transmission models.
##' Data in the three files can be linked using article identifier.
##' This function will read in the pathogen-specific articles and
##' parameters files and join them into a data.frame. The resulting
##' data set can be used to create a forest plot.
##'
##' @param pathogen name of pathogen. Must be one of the priority pathogens
##' exactly as specified in the package. You can get a list of the
##' priority pathogens currently included in the package by calling
##' \code{priority_pathogens()}.
##' @param prepend
##'
##' @return a list of length 2. The first element is a data.frame
##' called "params" with articles information (authors, publication year)
##' combined with the parameters. The second element is a data.frame
##' called "models" with all transmission models extracted for this
##' pathogen.
##' @importFrom readr read_csv
##' @importFrom dplyr left_join
##' @export

load_epidata <- function(pathogen, prepend = "") {

  assert_pathogen(pathogen)

  articles <- load_epidata_raw(pathogen, "article")
  models <- load_epidata_raw(pathogen, "model")
  outbreaks <- load_epidata_raw(pathogen, "outbreak")
  params <- load_epidata_raw(pathogen, "parameter")

  if (! inherits(articles, "data.frame")) {
    stop(paste("No article information found for ", pathogen))
  }

  if (! inherits(models, "data.frame")) {
    warning(paste("No models information found for ", pathogen))
    models <- data.frame(article_id = NA)
  }

  if (! inherits(outbreaks, "data.frame")) {
    warning(paste("No outbreaks information found for ", pathogen))
    outbreaks <- data.frame(article_id = NA)
  }

  if (! inherits(params, "data.frame")) {
    warning(paste("No params information found for ", pathogen))
    params <- data.frame(article_id = NA)
  }



  ## Make pretty labels for articles
  articles$article_label <- paste0(
    articles$first_author_surname, " ", articles$year_publication
  )

  cols <- c(
    "article_id", "first_author_surname", "year_publication", "article_label"
  )

  articles <- articles[, cols]


  ## Marburg parameters have entries like "Germany;Yugoslavia"
  ## For future pathogens, this should be cleaned up before data are
  ## checked into epireview
  params <- short_parameter_type(params)
  params$parameter_value <- as.numeric(params$parameter_value)


  params <- left_join(params, articles, by = "article_id")
  models <- left_join(models, articles, by = "article_id")
  outbreaks <- left_join(outbreaks, articles, by = "article_id")


  list(params = params, models = models, outbreaks = outbreaks)
}
