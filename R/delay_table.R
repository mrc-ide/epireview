#' Create table for human delay parameters
#'
#' @param df processed data with parameter information produced using
#' data_param_table()
#' @param pathogen name of pathogen
#' @return flextable with an overview of the delay parameter estimates
#' extracted from the included studies
#' @importFrom officer fp_border
#' @importFrom flextable flextable set_flextable_defaults fontsize
#' border_remove autofit theme_booktabs vline hline bold add_footer_lines
#' @importFrom dplyr filter mutate select arrange group_by row_number %>%
#' @importFrom stringr str_to_title str_replace
#' @examples
#' df <- data_param_table(pathogen = "marburg", exclude = c(15, 17))
#' delay_table(df = df, pathogen = "marburg")
#' @export

delay_table <- function(df, pathogen) {

  # assertions
  assert_pathogen(pathogen)

  border_style <- fp_border(color = "black", width = 1)
  set_flextable_defaults(background.color = "white")

  # Deal with R CMD Check "no visible binding for global variable"
  parameter_class <- parameter_type <- article_label <- population_country <-
    `Survey year` <- parameter_value <- parameter_value_type <- Uncertainty <-
    parameter_uncertainty_type <- population_group <- method_moment_value <-
    riskfactor_outcome <- `Parameter type` <- Country <- index_of_change <- NULL

  delay_tbl <- df %>%
    filter(parameter_class == "Human delay") %>%
    mutate(parameter_type = str_to_title(
      str_replace(parameter_type, "Human delay - ", ""))) %>%
    select(c(Article = article_label,
             Country = population_country,
             `Survey year`,
             `Parameter type` = parameter_type,
             `Delays (days)` = parameter_value,
             Statistic = parameter_value_type,
             Uncertainty,
             `Uncertainty type` = parameter_uncertainty_type,
             `Population Group` = population_group,
             `Timing of survey` = method_moment_value,
             Outcome = riskfactor_outcome)) %>%
    arrange(`Parameter type`, Country, `Survey year`) %>%
    group_by(`Parameter type`) %>%
    mutate(index_of_change = row_number(),
           index_of_change = ifelse(
             index_of_change == max(index_of_change), 1, 0)) %>%
    flextable(
      col_keys = c("Article", "Country", "Parameter type", "Survey year",
                   "Delays (days)", "Statistic", "Uncertainty",
                   "Uncertainty type", "Population Group", "Timing of survey",
                   "Outcome")) %>%
    fontsize(i = 1, size = 12, part = "header") %>%
    border_remove() %>%
    autofit() %>%
    theme_booktabs() %>%
    vline(j = c(4), border = border_style) %>%
    hline(i = ~ index_of_change == 1) %>%
    bold(i = 1, bold = TRUE, part = "header") %>%
    add_footer_lines("")

  return(delay_tbl)
}
