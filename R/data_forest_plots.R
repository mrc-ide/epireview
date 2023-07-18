#' Process data for use in forest_plot_delay(), forest_plot_mutations(),
#' forest_plot_r() and forest_plot_severity()
#'
#' @param pathogen name of pathogen e.g. "marburg"
#' @param exclude article IDs to exclude
#' @return processed data to use as input for forest_plot_delay(),
#' forest_plot_mutations(), forest_plot_r() and forest_plot_severity()
#' @importFrom readr read_csv
#' @importFrom stringr str_starts
#' @importFrom dplyr select arrange filter mutate rowwise
#' @examples
#' data_forest_plots(pathogen = "marburg", exclude = c(15, 17))
#' @export

data_forest_plots <- function(pathogen, exclude) {

  # Get file pathway for parameter data
  file_path_pa <- system.file(
    "data", paste0(pathogen, "_parameter.csv"), package = "epireview")
  if (file_path_pa == "")
    file_path_pa <- paste0("../data/", pathogen, "_parameter.csv")
  params <- read_csv(file_path_pa)

  # Get file pathway for article data
  file_path_ar <- system.file(
    "data", paste0(pathogen, "_article.csv"), package = "epireview")
  if (file_path_ar == "")
    file_path_ar <- paste0("../data/", pathogen, "_article.csv")
  articles <- read_csv(file_path_ar)

  # Deal with R CMD Check "no visible binding for global variable"
  parameter_class <- parameter_type <- article_id <- article_label <-
    first_author_surname <- year_publication <- parameter_value <-
    parameter_value_type <- parameter_lower_bound <- parameter_upper_bound <-
    parameter_data_id <- parameter_uncertainty_lower_value <-
    parameter_uncertainty_upper_value <- population_country <-
    parameter_uncertainty_type <- cfr_ifr_method <- NULL

  df <- left_join(params, articles %>%
                  select(article_id, first_author_surname, year_publication),
                by = "article_id") %>%
  mutate(article_label = as.character(
    paste0(first_author_surname, "", year_publication)),
    population_country = str_replace_all(population_country, ";", ",")) %>%
  arrange(article_label, -year_publication) %>%
  filter(article_id %in% exclude == FALSE) %>%
  mutate(parameter_uncertainty_lower_value =
           replace(parameter_uncertainty_lower_value,
                   (parameter_uncertainty_type == "Range" &
                      !is.na(parameter_lower_bound) &
                      parameter_class == "Human delay"), NA),
         parameter_uncertainty_upper_value =
           replace(parameter_uncertainty_upper_value,
                   (parameter_uncertainty_type == "Range" &
                      !is.na(parameter_upper_bound) &
                      parameter_class == "Human delay"), NA))

# pathogen specific edits
if (pathogen == "marburg") {
  df <- df %>%
    rowwise() %>%
    mutate(parameter_uncertainty_lower_value =
           replace(parameter_uncertainty_lower_value,
                   parameter_data_id == 43,
                   parameter_uncertainty_lower_value * 1e-4),
         parameter_uncertainty_upper_value =
           replace(parameter_uncertainty_upper_value,
                   parameter_data_id == 43,
                   parameter_uncertainty_upper_value * 1e-4)) %>%
    mutate(parameter_value =
           replace(parameter_value, parameter_data_id == 34, 0.93),
         cfr_ifr_method =
           replace(cfr_ifr_method, str_starts(parameter_type, "Severity") &
                     is.na(cfr_ifr_method), "Unknown")) %>%
    mutate(parameter_value_type =
           ifelse(parameter_data_id == 16, "Other", parameter_value_type),
         parameter_value_type =
           ordered(parameter_value_type, levels = c("Mean",
                                                    "Median",
                                                    "Standard Deviation",
                                                    "Other",
                                                    "Unspecified")))
}

return(df)

}
