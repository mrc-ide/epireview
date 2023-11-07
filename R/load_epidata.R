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

  # assertions
  assert_pathogen(pathogen)
  assert_table(table_type)

  file_path <- system.file(
    "extdata", paste0(pathogen, "_", table_type, ".csv"), package = "epireview")

  if (file_path == "")
    file_path <- paste0(
      vignette_prepend, "inst/extdata/", pathogen, "_", table_type, ".csv")

  data_tbl <- read_csv(file_path)
  return(data_tbl)
}
