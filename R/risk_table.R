#' Create risk table
#'
#' @param df data with outbreak information
#' @param pathogen name of pathogen
#' @param supplement either TRUE or FALSE. If TRUE, returns supplementary
#' figures.
#' @return returns flextable
#' @importFrom officer fp_border
#' @importFrom dplyr mutate mutate filter select rowwise summarise
#' @importFrom tidyr pivot_longer pivot_wider
#' @importFrom flextable set_flextable_defaults flextable fontsize
#' border_remove autofit theme_booktabs vline hline bold
#' @examples
#' risk_table(df = data, pathogen = "marburg")
#' @export
risk_table <- function(df,
                       pathogen,
                       supplement = FALSE) {

  border_style <- fp_border(color = "black", width = 1)
  set_flextable_defaults(background.color = "white")

  risk_tbl_supp <- df %>%
    mutate(riskfactor_occupation =
             str_replace_all(riskfactor_occupation, "burrial", "burial")) %>%
    rowwise() %>%
    mutate(riskfactor_1 = str_split(riskfactor_name, ";")[[1]][1],
           riskfactor_2 = str_split(riskfactor_name, ";")[[1]][2],
           riskfactor_3 = str_split(riskfactor_name, ";")[[1]][3]) %>%
    pivot_longer(riskfactor_1:riskfactor_3,
                 names_to = "riskfactor_num",
                 values_to = "riskfactor_names") %>%
    mutate(riskfactor_name =
             if_else(riskfactor_names == "Occupation",
                     "Occupation - Funeral and burial services",
                     riskfactor_names)) %>%
    filter(is.na(riskfactor_name) == FALSE) %>%
    select(c(Article = article_label,
             Country = population_country,
             `Survey year`,
             "Outcome" = riskfactor_outcome,
             "Risk factor" = riskfactor_name,
             "Significant" = riskfactor_significant,
             "Adjusted" = riskfactor_adjusted,
             `Sample size` = population_sample_size,
             "Population sample type" = population_sample_type,
             `Population group` = population_group,
             `Timing of survey` = method_moment_value))

  risk_flextable_tbl <- risk_tbl_supp %>%
    arrange(Outcome, Country, `Survey year`) %>%
    group_by(Country) %>%
    mutate(index_of_change = row_number(),
           index_of_change =
             ifelse(index_of_change == max(index_of_change), 1, 0)) %>%
    flextable(col_keys = c("Article", "Country", "Survey year", "Outcome",
                           "Risk factor", "Occupation", "Significant",
                           "Adjusted", "Sample size", "Population sample type",
                           "Population group", "Timing of survey")) %>%
    fontsize(i = 1, size = 12, part = "header") %>%
    border_remove() %>%
    autofit() %>%
    theme_booktabs() %>%
    vline(j = c(4), border = border_style) %>%
    hline(i = ~ index_of_change == 1) %>%
    bold(i = 1, bold = TRUE, part = "header")

  risk_tbl <- df %>%
    mutate(riskfactor_occupation =
             str_replace_all(riskfactor_occupation, "burrial", "burial")) %>%
    rowwise() %>%
    mutate(riskfactor_1 = str_split(riskfactor_name, ";")[[1]][1],
           riskfactor_2 = str_split(riskfactor_name, ";")[[1]][2],
           riskfactor_3 = str_split(riskfactor_name, ";")[[1]][3]) %>%
    pivot_longer(riskfactor_1:riskfactor_3,
                 names_to = "riskfactor_num",
                 values_to = "riskfactor_names") %>%
    mutate(riskfactor_name = if_else(riskfactor_names == "Occupation",
                                     "Occupation - Funeral and burial services",
                                     riskfactor_names)) %>%
    filter(is.na(riskfactor_name) == FALSE) %>%
    group_by(riskfactor_outcome,
             riskfactor_name,
             riskfactor_adjusted,
             riskfactor_significant) %>%
    summarise(sample_size = sum(population_sample_size, na.rm = TRUE)) %>%
    pivot_wider(names_from = riskfactor_significant,
                       values_from = sample_size) %>%
    mutate(riskfactor_outcome = if_else(riskfactor_outcome == "Serology",
                                               "Seropositivity",
                                               riskfactor_outcome)) %>%
    select("Outcome" = riskfactor_outcome,
           "Risk factor" = riskfactor_name,
           "Adjusted" = riskfactor_adjusted,
           Significant, "Not significant")

  risk_main_flextable <- risk_tbl %>%
    arrange(Outcome, `Risk factor`, Adjusted) %>%
    group_by(Outcome) %>%
    mutate(index_of_change = row_number(),
           index_of_change =
             ifelse(index_of_change == max(index_of_change), 1, 0)) %>%
    flextable(col_keys = c("Outcome", "Risk factor", "Adjusted",
                           "Significant", "Not significant")) %>%
    fontsize(i = 1, size = 12, part = "header") %>%
    border_remove() %>%
    autofit() %>%
    theme_booktabs() %>%
    vline(j = c(2, 3, 4), border = border_style) %>%
    hline(i = ~ index_of_change == 1) %>%
    bold(i = 1, bold = TRUE, part = "header")

  if (supplement) {
    return(risk_flextable_tbl)
  } else {
    return(risk_main_flextable)
  }

}
