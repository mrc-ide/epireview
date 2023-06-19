#' load_data function
#'
#' @param table_type which type of table (parameter, outbreak, etc) should be loaded
#' @param pathogen name of pathogen
#' @return return tibble with data for table_type and pathogen
#' @examples
#' load_data("outbreak","margburg")
#' @export (the export tag just allows the function to be exported)
load_data <- function(table_type="parameter",pathogen="marburg")
{
  data_tbl <- read.csv(paste0('data/',pathogen,'/',table_type,'_final.csv'))
  return(data_tbl)
}

