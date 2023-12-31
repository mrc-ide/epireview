#' Utility to obtain available fields in a specified table
#'
#' Note: This will need to be extended when other pathogens are added
#'
#' @param table_type which type of table (either "parameter", "outbreak", or
#' "model") should be loaded
#' @param pathogen pathogen name e.g. "marburg"
#' @param field can either be "all" to return all fields in the specified
#' table_type, or a specific variable name that the user wants to return
#' @param vignette_prepend string to allow loading data in vignettes
#' @return data for specified table_type and field
#' @importFrom dplyr mutate everything across
#' @importFrom tidyr replace_na
#' @importFrom readr read_csv
#' @importFrom stats na.omit
#' @examples
#' get_table_field_options(table_type = "model",
#'                        pathogen = "marburg",
#'                        field = "all")
#'
#' get_table_field_options(table_type = "model",
#'                        pathogen = "marburg",
#'                        field = "Model type")
#'
#' get_table_field_options(table_type = "parameter", pathogen = "marburg",
#'                         field = "Reproduction number method")
#' @export
get_table_field_options <- function(table_type = NA,
                                    pathogen = NA,
                                    field = "all",
                                    vignette_prepend = "") {

  file_path_ob <- system.file(
    "extdata", paste0(pathogen, "_dropdown_", table_type, "s.csv"),
    package = "epireview")

  if (file_path_ob == "") file_path_ob <- paste0(
    vignette_prepend, "extdata/", pathogen, "_dropdown_", table_type, "s.csv")
  model_options <- read_csv(file_path_ob)

  if (field == "all") {
    return(model_options %>% mutate(across(everything(), ~replace_na(.x, ""))))
  } else {
    return(as.vector(na.omit(model_options[[field]])))
  }
}
