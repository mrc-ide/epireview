#' Load data for a particular pathogen
#'
#' @param table_type which type of table (either "article", "parameter",
#' "outbreak", or "model") should be loaded
#' @param pathogen name of pathogen
#' @param vignette_prepend string to allow loading data in vignettes
#' @return return data for specified table_type and pathogen
#' @importFrom readr read_csv
#' @examples
#' load_epidata(table_type = "outbreak", pathogen = "marburg")
#' @export
load_epidata <- function(table_type = NA,
                         pathogen = NA,
                         vignette_prepend = "") {

  if (is.na(table_type) || is.na(pathogen)) {
    stop("table_type and pathogen name must be supplied. table_type can be
         one of either 'article', 'parameter', 'outbreak' or 'model'")
  }

  file_path <- system.file(
    "data", paste0(pathogen, "_", table_type, ".csv"), package = "epireview")

  if (file_path == "")
    file_path <- paste0(
      vignette_prepend, "data/", pathogen, "_", table_type, ".csv")

  data_tbl <- read_csv(file_path)
  return(data_tbl)
}
