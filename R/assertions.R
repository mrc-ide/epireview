## Assert functions:

#------------------------------------------------
# x is one of the existing priority pathogens
#' @noRd
assert_pathogen <- function(x, message = paste(
                              "%s must be one of the priority pathogens:",
                              paste(priority_pathogens()$pathogen, collapse = ", ")
                            ),
                            name = deparse(substitute(x))) {
  assert_string(x)

  pps <- priority_pathogens()
  if (!x %in% pps$pathogen) {
    stop(sprintf(message, name), call. = FALSE)
  }

  invisible(TRUE)
}

#------------------------------------------------
# x is a table
#' @noRd
assert_table <- function(x, message = paste(
                           "%s must be one of the priority pathogens table options:",
                           paste("article", "parameter", "outbreak", "model", sep = ", ")
                         ),
                         name = deparse(substitute(x))) {
  assert_string(x)
  table_names <- c("article", "parameter", "outbreak", "model")
  if (!x %in% table_names) {
    stop(sprintf(message, name), call. = FALSE)
  }
  invisible(TRUE)
}

#------------------------------------------------
# x is character string
#' @noRd
assert_string <- function(x, message = "%s must be character string", name = deparse(substitute(x))) {
  if (!is.character(x)) {
    stop(sprintf(message, name), call. = FALSE)
  }
  invisible(TRUE)
}

assert_data_frame <- function(x, message = "%s must be a data frame", name = deparse(substitute(x))) {
  if (!is.data.frame(x)) {
    stop(sprintf(message, name), call. = FALSE)
  }
  invisible(TRUE)
}

assert_params <- function(x, message = "%s must have a column named 'parameter_type'.
                                        Did you load the data using load_epidata?", name = deparse(substitute(x))) {
  assert_data_frame(x)
  if (!"parameter_type" %in% colnames(x)) {
    stop(sprintf(message, name), call. = FALSE)
  }
  invisible(TRUE)

assert_articles <- function(x, message = "%s must have columns
   'first_author_first_name', 'first_author_surname', 'year_publication', 
   'covidence_id'. Did you load the data using load_epidata?", 
   name = deparse(substitute(x))) {
  assert_data_frame(x)
  cols_needed <- c(
    "first_author_first_name", "first_author_surname", 
    "year_publication", "covidence_id")
  if (!all(cols_needed %in% colnames(x))) {
    stop(sprintf(message, name), call. = FALSE)
  }
  invisible(TRUE)
}

