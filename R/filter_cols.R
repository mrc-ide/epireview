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
#' filter_cols(p, "parameter_type", "in", 
#'   list(parameter_type = c("Attack rate", "Seroprevalence - IFA")))
#'
#' @importFrom cli cli_abort
#' @export
filter_cols <- function(x, cols, funs = c("in", "==", ">", "<"), vals) {

  if (length(cols) != length(funs)) {
    cli_abort("Length of arguments cols is different from that of funs.
              Please specify one function for each column in cols")
  }

  if (length(funs) != length(vals)) {
    cli_abort("Length of arguments funs is different from that of vals.
    Please specify values to be used for filtering columns in cols")
  }

  match.arg(funs)

  if (any(! cols %in% colnames(x))) {
    msg <- "cols must be present in x as a column. Offending cols are "
    cli_abort(paste(msg, toString(cols[! cols %in% colnames(x)])))
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
    cli_abort(paste(msg, toString(cols[any_match])))
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