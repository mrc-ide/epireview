#' Load data for a particular pathogen
#'
#' @param table_type which type of table (either article, parameter, outbreak,
#' model) should be loaded
#' @param pathogen name of pathogen
#' @return return data for table_type and pathogen
#' @importFrom readr read_csv
#' @examples
#' load_data("outbreak","marburg")
#' @export
load_data <- function(table_type = NA, pathogen = NA)
{
  if(is.na(table_type) || is.na(pathogen)){
    stop("table_type and pathogen name must be supplied. table_type can be
         one of either 'article', 'parameter', 'outbreak' or 'model'")
  }

  data_tbl <- read_csv(system.file("data",
                                   paste0(pathogen, "_", table_type, ".csv"),
                                   package = "epireview"))
  return(data_tbl)
}

