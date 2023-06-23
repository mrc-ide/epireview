#' Create risk table
#'
#' @param df data with outbreak information
#' @param pathogen name of pathogen
#' @return returns flextable
#' @examples
#'
#' @export
risk_table <- function(df,pathogen){
  border_style = officer::fp_border(color="black", width=1)
  set_flextable_defaults(background.color = "white")

  risk_tbl_supp <- df %>%
    dplyr::mutate(riskfactor_occupation = str_replace_all(riskfactor_occupation, "burrial", "burial")) %>%
    rowwise() %>%
    dplyr::mutate(riskfactor_1 = str_split(riskfactor_name, ";")[[1]][1],
                  riskfactor_2 = str_split(riskfactor_name, ";")[[1]][2],
                  riskfactor_3 = str_split(riskfactor_name, ";")[[1]][3]) %>%
    tidyr::pivot_longer(riskfactor_1:riskfactor_3, names_to = "riskfactor_num", values_to = "riskfactor_names") %>%
    dplyr::mutate(riskfactor_name = if_else(riskfactor_names == "Occupation",
                                            "Occupation - Funeral and burial services",
                                            riskfactor_names)) %>%
    dplyr::filter(is.na(riskfactor_name) == FALSE) %>%
    dplyr::select(c(Article = article_label,
                    Country = population_country,
                    `Survey year`,
                    'Outcome' = riskfactor_outcome,
                    'Risk factor' = riskfactor_name,
                    'Significant' = riskfactor_significant,
                    'Adjusted' = riskfactor_adjusted,
                    `Sample size` = population_sample_size,
                    'Population sample type' = population_sample_type,
                    `Population group` = population_group,
                    `Timing of survey` = method_moment_value))

  risk_flextable_tbl <- risk_tbl_supp %>%
    arrange(Outcome, Country, `Survey year`) %>%
    group_by(Country) %>%
    mutate(index_of_change = row_number(),
           index_of_change = ifelse(index_of_change == max(index_of_change),1,0)) %>%
    flextable(col_keys = c("Article", "Country", "Survey year", "Outcome", 'Risk factor', 'Occupation',
                           'Significant', 'Adjusted', 'Sample size', 'Population sample type',
                           'Population group', 'Timing of survey')) %>%
    fontsize(i = 1, size = 12, part = "header") %>%  # adjust font size of header
    border_remove() %>%
    autofit() %>%
    theme_booktabs() %>%
    vline(j = c(4), border = border_style) %>%
    hline(i = ~ index_of_change == 1) %>%
    bold(i = 1, bold = TRUE, part = "header")

  return(risk_flextable_tbl)
}
