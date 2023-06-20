#' Load data for a particular pathogen
#'
#' @param table_type which type of table (either article, parameter, outbreak,
#' model) should be loaded
#' @param pathogen name of pathogen
#' @return return data for table_type and pathogen
#' @examples
#' load_data("outbreak","marburg")
#' @export
load_data <- function(table_type = NA, pathogen = NA)
{
  if(is.na(table_type)){
    stop("table_type must be one of either article, parameter, outbreak or model")
  }

  if(is.na(pathogen)){
    stop("pathogen name must be supplied")
  }

  data_tbl <- readr::read_csv(system.file("data",
                                          paste0(pathogen, "_", table_type, ".csv"),
                                          package = "epireview"))
  return(data_tbl)
}

