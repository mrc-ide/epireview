#' Loads raw data for a particular pathogen
#'
#' @details
#' This function will return the raw data as a data.frame. The
#' csv files of the models, outbreaks, and parameters for a pathogen
#' do not contain information on the source but only an "article_id"
#' that can be used to merge them with the articles. If you wish to
#' retrieve linked information or multiple tables at the same time,
#' use \code{load_epidata} instead.
#'
#'
#' @inheritParams load_epidata
#'
#' @param table the table to be loaded. Must be one of
#' "article", "parameter", "outbreak", or "model"
#'
#'
#' 
#' @return data.frame reading in the csv the specified pathogen table
#' @importFrom readr read_csv
#' @seealso
#' [load_epidata()] for a more user-friendly interface
#' @examples
#' load_epidata_raw(pathogen = "marburg", table = "outbreak")
#' @export
load_epidata_raw <- function(pathogen, table = c("article", "parameter",
  "outbreak", "model")) {

  # assertions

  if ( missing(pathogen) | missing(table)) {
    stop("pathogen and table name must be supplied. table can be
         one of 'article', 'parameter', 'outbreak' or 'model'")
  }

  assert_pathogen(pathogen)
  assert_table(table)

  pps <- priority_pathogens()

  fname <- switch(
    table,
    article =  pps[pps$pathogen == pathogen, "articles_file"],
    parameter = pps[pps$pathogen == pathogen, "params_file"],
    outbreak = pps[pps$pathogen == pathogen, "outbreaks_file"],
    model = pps[pps$pathogen == pathogen, "models_file"],
  )
  ## Get column types based on table type
  col_types <- switch(
    table,
    article = article_column_type(),
    parameter = parameter_column_type(),
    outbreak = outbreak_column_type(),
    model = model_column_type()
  )

  file_path <- system.file("extdata", fname, package = "epireview")

  if (is.na(file_path)) {
    warning(paste("No data found for ", pathogen))
  } else {
    message(paste("Loading data for ", pathogen))
    out <- read_csv(file_path, col_types = col_types, show_col_types = FALSE)
  }

  out

}


## Define column types for each table
## These are used to read in the data
## and to validate the data
#' Define the column types for the article data frame
#'
#' This function defines the column types for the article data frame used in the epireview package.
#' It specifies the data types for each column in the data frame. readr is generally good at guessing the
#' column types, but it is better to be explicit. Moreover, it reads a column of NAs as a logical vector, which 
#' is particularly undesirable for us. 
#' The function is intended to be used
#' internally by \code{load_epidata_raw} where the files are being read. 
#'
#' @return A list of column types for the article data frame
#' @importFrom readr col_character col_integer col_logical
#' @export
article_column_type <- function() {
  list(
    first_author_first_name = col_character(),
    first_author_surname = col_character(),
    article_title = col_character(),
    doi = col_character(),
    journal = col_character(),
    year_publication = col_integer(),
    volume = col_integer(),
    issue = col_integer(),
    page_first = col_integer(),
    page_last = col_integer(),
    paper_copy_only = col_logical(),
    notes = col_character(),
    qa_m1 = col_integer(),
    qa_m2 = col_integer(),
    qa_a3 = col_integer(),
    qa_a4 = col_integer(),
    qa_d5 = col_integer(),
    qa_d6 = col_integer(),
    qa_d7 = col_integer()
  )
}

parameter_column_type <- function() {
  list(
    article_id = col_integer(),
    parameter_name = col_character(),
    parameter_value = col_character(),
    parameter_units = col_character(),
    parameter_notes = col_character(),
    qa_m1 = col_integer(),
    qa_m2 = col_integer(),
    qa_a3 = col_integer(),
    qa_a4 = col_integer(),
    qa_d5 = col_integer(),
    qa_d6 = col_integer(),
    qa_d7 = col_integer()
  )
}