#' Create outbreak table
#'
#' @param df data with outbreak information
#' @param pathogen name of pathogen
#' @return return data for new row to be added with append_new_entry_to_table function
#' @examples
#'
#' @export
outbreak_table <- function(df,pathogen){
  border_style = officer::fp_border(color="black", width=1)
  set_flextable_defaults(background.color = "white")

  outbreak_tbl <- df %>%
    dplyr::filter(is.na(outbreak_start_year) == FALSE) %>%
    select(c(article_label, outbreak_start_day, outbreak_start_month, outbreak_start_year,
             outbreak_end_day, outbreak_end_month, outbreak_date_year,
             outbreak_country, outbreak_location,
             cases_confirmed, cases_suspected, cases_asymptomatic, cases_mode_detection,
             cases_severe_hospitalised, deaths)) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(outbreak_start_month = str_replace_all(tm::removeNumbers(outbreak_start_month), "-",""),
                  outbreak_end_month = str_replace_all(tm::removeNumbers(outbreak_end_month), "-","")) %>%
    dplyr::mutate(outbreak_start = date_start(start_day = outbreak_start_day,
                                              start_month = outbreak_start_month,
                                              start_year = outbreak_start_year),
                  outbreak_end = date_start(start_day = outbreak_end_day,
                                          start_month = outbreak_end_month,
                                          start_year = outbreak_date_year),
                  cases_mode_detection = str_replace_all(cases_mode_detection, "Molecular (PCR etc)", "Molecular")) %>%
    dplyr::distinct() %>%
    dplyr::arrange(outbreak_country, outbreak_date_year) %>%
    group_by(outbreak_country, outbreak_start_year) %>%
    dplyr::select(Country = outbreak_country,
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
           index_of_change = ifelse(index_of_change == max(index_of_change),1,0)) %>%
    flextable(col_keys = c("Country",
                           "Location", "Article",
                           "Start", "End",
                           "Deaths", "Confirmed",
                           "Suspected", "Asymptomatic",
                           "Severe/hospitalised", "Confirmation Method")) %>%
    fontsize(i = 1, size = 12, part = "header") %>%  # adjust font size of header
    border_remove() %>%
    autofit() %>%
    theme_booktabs() %>%
    vline(j = c(3, 5, 7, 10), border = border_style) %>%
    hline(i = ~ index_of_change == 1) %>%
    bold(i = 1, bold = TRUE, part = "header")

  return(outbreak_tbl)
}
