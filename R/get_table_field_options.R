#' Utility to obtain available fields in a specified table
#'
#' Note: This will need to be extended when other pathogens are added
#'
#' @inheritParams load_epidata_raw 
#' @param field can either be "all" to return all fields in the specified
#' table_type, or a specific variable name that the user wants to return
#' @return data for specified table_type and field
#' @importFrom dplyr mutate everything across
#' @importFrom tidyr replace_na
#' @importFrom readr read_csv
#' @importFrom stats na.omit
#' @importFrom cli cli_abort
#' @examples
#' get_table_field_options(
#'                        pathogen = "marburg", "model",
#'                        field = "all")
#'
#' get_table_field_options(pathogen = "marburg", "model",
#'                         field = "Model type")
#'
#' get_table_field_options(pathogen = "marburg", "parameter",
#'                         field = "Reproduction number method")
#' @export
get_table_field_options <- function(pathogen, table = c("model", "parameter", "outbreak", "article"),
                                    field = "all") {
                                       
  assert_table(table)
  
  # assertions
  assert_pathogen(pathogen)

  file_path_ob <- system.file(
    "extdata", paste0(pathogen, "_dropdown_", table, "s.csv"),
    package = "epireview")
  
  if (any(file_path_ob == "")) {
    cli_abort(paste0("No data found for ", pathogen))
  }
  model_options <- read_csv(file_path_ob, show_col_types = FALSE)
  

  if (field == "all") {
    return(model_options %>% mutate(across(everything(), ~replace_na(.x, ""))))
  } else {
    return(na.omit(model_options[, field]))
  }
}
