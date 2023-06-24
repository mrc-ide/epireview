#' Utility to obtain available table options to pick from
#'
#' @param table_type which type of table (either parameter, outbreak,
#' model) should be loaded
#' @param field
#' @return return data for table_type and pathogen
#' @importFrom readr read_csv
#' @examples
#' get_available_table_field_options("model",field='Model type')
#' @export
get_available_table_field_options <- function(table_type=NA,field="all")
{
  file_path_ob  <- system.file("data", paste0("access_db_dropdown_", table_type,"s.csv"), package = "epireview")
  if(file_path_ob=="") file_path_ob <- paste0("data/access_db_dropdown_", table_type,"s.csv")
  model_options <- read_csv(file_path_ob)

  if(field=="all")
  {
    return(model_options %>% mutate(across(everything(),~replace_na(.x, ""))))
  } else {
    return(as.vector(na.omit(model_options[[field]])))
  }
}
