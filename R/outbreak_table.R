#' Create table with all outbreak data for a particular pathogen
#'
#' @param df processed data with outbreak information (see vignette for each
#' pathogen)
#' @param pathogen name of pathogen
#' @return returns flextable summarising all extracted outbreaks for the
#' specified pathogen
#' @importFrom officer fp_border
#' @importFrom dplyr filter select rowwise mutate distinct arrange group_by
#' @importFrom flextable flextable set_flextable_defaults
#' @importFrom tm removeNumbers
#' @examples
#' outbreak_table(df = data, pathogen = "marburg")
#' @export
outbreak_table <- function(df, pathogen) {

  border_style = fp_border(color = "black", width = 1)
  set_flextable_defaults(background.color = "white")

  outbreak_tbl <- df %>%
    filter(is.na(outbreak_start_year) == FALSE) %>%
    select(c(article_label, outbreak_start_day, outbreak_start_month,
             outbreak_start_year, outbreak_end_day, outbreak_end_month,
             outbreak_date_year, outbreak_country, outbreak_location,
             cases_confirmed, cases_suspected, cases_asymptomatic,
             cases_mode_detection, cases_severe_hospitalised, deaths)) %>%
    rowwise() %>%
    mutate(outbreak_start_month =
             str_replace_all(removeNumbers(outbreak_start_month), "-", ""),
           outbreak_end_month =
             str_replace_all(removeNumbers(outbreak_end_month), "-", "")) %>%
    mutate(outbreak_start = date_start(start_day = outbreak_start_day,
                                       start_month = outbreak_start_month,
                                       start_year = outbreak_start_year),
           outbreak_end = date_start(start_day = outbreak_end_day,
                                     start_month = outbreak_end_month,
                                     start_year = outbreak_date_year),
           cases_mode_detection = str_replace_all(cases_mode_detection,
                                                  "Molecular (PCR etc)",
                                                  "Molecular")) %>%
    distinct() %>%
    arrange(outbreak_country, outbreak_date_year) %>%
    group_by(outbreak_country, outbreak_start_year) %>%
    select(Country = outbreak_country,
                  Location = outbreak_location,
                  Article = article_label,
                  Start = outbreak_start,
                  End = outbreak_end,
                  Deaths = deaths,
                  "Confirmed" = cases_confirmed,
                  "Suspected" = cases_suspected,
                  "Asymptomatic" = cases_asymptomatic,
                  "Severe/hospitalised" = cases_severe_hospitalised,
                  "Confirmation Method" = cases_mode_detection) %>%
    mutate(index_of_change = row_number(),
           index_of_change =
             ifelse(index_of_change == max(index_of_change), 1, 0)) %>%
    flextable(col_keys = c("Country", "Location", "Article", "Start", "End",
                           "Deaths", "Confirmed", "Suspected", "Asymptomatic",
                           "Severe/hospitalised", "Confirmation Method")) %>%
    fontsize(i = 1, size = 12, part = "header") %>%
    border_remove() %>%
    autofit() %>%
    theme_booktabs() %>%
    vline(j = c(3, 5, 7, 10), border = border_style) %>%
    hline(i = ~ index_of_change == 1) %>%
    bold(i = 1, bold = TRUE, part = "header")

  return(outbreak_tbl)
}
