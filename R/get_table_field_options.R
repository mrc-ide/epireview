#' Utility to obtain available fields in a specified table
#'
#' Note: This will need to be extended when other pathogens are added
#'
#' @param table_type which type of table (either "parameter", "outbreak", or
#' "model") should be loaded
#' @param field can either be "all" to return all fields in the specified
#' table_type, or a specific variable name that the user wants to return
#' @param vignette_prepend string to allow loading data in vignettes
#' @return data for specified table_type and field
#' @importFrom dplyr mutate everything
#' @importFrom readr read_csv
#' @examples
#' get_available_table_field_options(table_type = "model", field = "all")
#'
#' get_available_table_field_options(table_type = "model", field = "Model type")
#'
#' get_available_table_field_options(table_type = "parameter",
#'                                   field = "Reproduction number method")
#' @export
get_table_field_options <- function(table_type = NA,
                                    field = "all",
                                    vignette_prepend = "") {

  file_path_ob <- system.file(
    "data", paste0("access_db_dropdown_", table_type, "s.csv"),
    package = "epireview")

  if (file_path_ob == "") file_path_ob <-
      paste0(vignette_prepend, "data/access_db_dropdown_", table_type, "s.csv")
  model_options <- read_csv(file_path_ob)

  if (field == "all") {
    return(model_options %>% mutate(across(everything(), ~replace_na(.x, ""))))
  } else {
    return(as.vector(na.omit(model_options[[field]])))
  }
}
