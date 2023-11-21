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
#' @param vignette_prepend string to allow loading data in vignettes
#' @return data.frame reading in the csv the specified pathogen table
#' @importFrom readr read_csv
#' @seealso
#' [load_epidata()] for a more user-friendly interface
#' @examples
#' load_epidata(pathogen = "marburg", table = "outbreak", )
#' @export
load_epidata_raw <- function(pathogen, table = c("article", "parameter",
  "outbreak", "model"), vignette_prepend = "") {

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
  # Get file path for article data

  file_path <- system.file("extdata", fname, package = "epireview")

  if (is.na(file_path)) {
    warning(paste("No data found for ", pathogen))
  } else {
    message(paste("Loading data for ", pathogen))
    out <- read_csv(file_path)
  }

  out

}
