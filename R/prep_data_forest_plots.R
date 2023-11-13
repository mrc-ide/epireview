##' Short labels parameters for use in figures
##'
##' This function assigns short labels to otherwise very long parameter
##' names. It is not intended to be called directly but is used by
##' \code{\link{prep_data_forest_plot}}
##'
##' @param x data.frame containing a column called "parameter_type"
##' @return
##' @author Sangeeta Bhatia
short_parameter_type <- function(x) {
  x$parameter_type_short <- case_when(
    x$parameter_type == "Reproduction number (Basic R0)" ~ "Basic (R0)",
    x$parameter_type == "Reproduction number (Effective, Re)" ~ "Effective (Re)",
    x$parameter_type == "Human delay - time symptom to outcome" &
      x$riskfactor_outcome == "Death" ~ "Time symptom to outcome (Death)",
    x$parameter_type == "Human delay - time symptom to outcome" &
      x$riskfactor_outcome == "Other" ~ "Time symptom to outcome (Other)"
  )

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
#'   Each function must be in "%in", "==", ">", "<".
#' @param vals A list of values to be used for filtering columns in \code{cols}.
#'
#' @return A data frame with rows filtered based on the specified conditions.
#'
#' @examples
#'
#'
#'
#'
#'
#'
#' @export
filter_cols <- function(x, cols, funs = c("%in", "==", ">", "<"), vals) {
  if (legnth(cols) != length(funs)) {
    stop("Length of arguments cols is different from that of funs.
          Please specify one function for each column in cols")
  }

  if (legnth(funs) != length(vals)) {
    stop("Length of arguments funs is different from that of vals.
          Please specify values to be used for filtering columns in
         cols")
  }

  match.arg(funs, nomatch = "funs must be one of %in%, ==, > or <")

  ## Make sure character and factor columns take in %in% or ==
  ## and numeric columns take in ==, > or <
  char_cols <- sapply(
    cols,
    function(col) is.character(x[[col]]) | is.factor(x[[col]])
  )

  char_funs <- sapply(
    funs, function(fun) fun %in% c("==", "%in%")
  )

  match <- char_cols & char_funs

  if (!all(match)) {
    msg <- "Non-character filter functions supplied to character columns. Offending columns are"
    stop(paste(msg, toString(cols[!match])))
  }


  num_cols <- sapply(
    cols, function(col) is.numeric(x[[col]])
  )

  num_funs <- sapply(
    funs, function(fun) fun %in% c("==", ">", "<")
  )

  match <- num_cols & num_funs

  if (!all(match)) {
    msg <- "Non-numeric filter functions supplied to numeric columns. Offending columns are"
    stop(paste(msg, toString(cols[!match])))
  }


  filter <- rep(TRUE, nrow(x))

  for (idx in seq_along(cols)) {
    this_col <- cols[[idx]]
    this_val <- vals[[idx]]
    this_fun <- funs[[idx]]
    switch(
      this_fun,
      "%in" = filter & (x[[this_col]] %in% this_val),
      ">" = filter & (x[[this_col]] > this_val),
      "<" = filter & (x[[this_col]] < this_val),
      "==" = filter & (x[[this_col]] == this_val),
      )
  }

  x[filter, ]
}


prepare_params_forest_plot <- function(df, options) {
  df
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

fetch_data <- function(pathogen, prepend = "") {
  assert_pathogen(pathogen)
  pps <- priority_pathogens()


  # Get file path for article data
  afname <- pps[pps$pathogen == pathogen, "articles_file"]
  file_path_ar <- system.file("extdata", afname, package = "epireview")

  if (file_path_ar == "") {
    file_path_ar <- paste0(prepend, "inst/extdata/", pathogen, "_article.csv")
  }

  articles <- read_csv(file_path_ar, show_col_types = FALSE)

  ## Make pretty labels for articles
  articles$article_label <- paste0(
    articles$first_author_surname, " ", articles$year_publication
  )

  cols <- c(
    "article_id", "first_author_surname", "year_publication", "article_label"
  )

  articles <- articles[, cols]

  # Get file path for parameter data
  pfname <- pps[pps$pathogen == pathogen, "params_file"]
  file_path_pa <- system.file("extdata", pfname, package = "epireview")
  if (file_path_pa == "") {
    file_path_pa <- paste0(prepend, "inst/extdata/", pathogen, "_parameter.csv")
  }

  params <- read_csv(file_path_pa, show_col_types = FALSE)
  ## Marburg parameters have entries like "Germany;Yugoslavia"
  ## For future pathogens, this should be cleaned up before data are
  ## checked into epireview
  params <- short_parameter_type(params)

  ## Get file path for models
  mfname <- pps[pps$pathogen == pathogen, "models_file"]
  file_path_m <- system.file("extdata", mfname, package = "epireview")
  models <- read_csv(file_path_m, show_col_types = FALSE)


  df1 <- left_join(params, articles, by = "article_id")
  df1$parameter_value <- as.numeric(df1$parameter_value)

  df2 <- left_join(models, articles, by = "article_id")


  list(params = df1, models = df2)
}
