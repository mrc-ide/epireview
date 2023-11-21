#' Create seroprevalence table
#'
#' @param df processed data with parameter information produced by
#' data_param_table()
#' @param pathogen name of pathogen
#' @return returns flextable with a summary of seroprevalence data
#' @importFrom officer fp_border
#' @examples
#' df <- data_param_table(pathogen = "marburg", exclude = c(15, 17))
#' sero_table(df = df, pathogen = "marburg")
#' @export
sero_table <- function(df, pathogen) {

  # assertions
  assert_pathogen(pathogen)

  border_style <- fp_border(color = "black", width = 1)
  set_flextable_defaults(background.color = "white")

  # Deal with R CMD Check "no visible binding for global variable"
  parameter_class <- parameter_value <- parameter_type <- article_label <-
    population_country <- `Survey year` <- Uncertainty <-
    parameter_uncertainty_type <- cfr_ifr_numerator <- cfr_ifr_denominator <-
    population_group <- method_moment_value <- method_disaggregated_by <-
    Country <- `Parameter type*` <- index_of_change <- NULL

  sero_tbl <- df %>%
    mutate(parameter_value = round(parameter_value, 2),
           parameter_type =
             str_replace(parameter_type, "Seroprevalence - ", "")) %>%
    filter(parameter_class == "Seroprevalence") %>%
    select(c(Article = article_label,
             Country = population_country,
             `Survey year`,
             `Parameter type*` = parameter_type,
             `Seroprevalence (%)` = parameter_value,
             `Uncertainty (%)` = Uncertainty,
             `Uncertainty type` = parameter_uncertainty_type,
             `Number Seropositive` = cfr_ifr_numerator,
             `Sample size` = cfr_ifr_denominator,
             `Population Group` = population_group,
             parameter_class,
             `Timing of survey` = method_moment_value,
             `Disaggregated data\navailable` = method_disaggregated_by))

  multicountry <- sero_tbl[which(
    sero_tbl$Country == "Cameroon, Central African Republic, Chad,
    Republic of the Congo, Equatorial Guinea, Gabon"), ]

  sero_flextable_tbl <- sero_tbl %>%
    filter(!Country == "Cameroon, Central African Republic, Chad,
           Republic of the Congo, Equatorial Guinea, Gabon") %>%
    arrange(Country, `Survey year`, `Parameter type*`) %>%
    rbind(multicountry) %>%
    group_by(Country) %>%
    mutate(index_of_change = row_number(),
           index_of_change = ifelse(
             index_of_change == max(index_of_change), 1, 0)) %>%
    flextable(
      col_keys = c("Article", "Country", "Parameter type*", "Survey year",
                   "Seroprevalence (%)", "Uncertainty (%)", "Uncertainty type",
                   "Number Seropositive", "Sample size", "Population Group",
                   "Timing of survey", "Disaggregated data\navailable")) %>%
    fontsize(i = 1, size = 12, part = "header") %>%
    border_remove() %>%
    autofit() %>%
    theme_booktabs() %>%
    vline(j = c(4), border = border_style) %>%
    hline(i = ~ index_of_change == 1) %>%
    bold(i = 1, bold = TRUE, part = "header") %>%
    add_footer_lines("*HAI/HI: Hemagglutination Inhibition Assay;
                     IFA: Indirect Fluorescent Antibody assay;
                     IgG: Immunoglobulin G;
                     IgM: Immunoglobulin M; Unspecified assay.")

  return(sero_flextable_tbl)
}
