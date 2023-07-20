#' Process data for delay table
#'
#' @param pathogen name of pathogen e.g. "marburg"
#' @param exclude article IDs to exclude
#' @return processed data to use as input for delay_table(), risk_table() and
#' seroprevalence_table()
#' @importFrom readr read_csv
#' @importFrom dplyr left_join mutate select arrange filter
#' @examples
#' df <- data_param_table(pathogen = "marburg", exclude = c(15, 17))
#' @export

data_param_table <- function(pathogen, exclude) {

  # Get file pathway for parameter data
  file_path_pa <- system.file(
    "extdata", paste0(pathogen, "_parameter.csv"), package = "epireview")
  if (file_path_pa == "")
    file_path_pa <- paste0("../extdata/", pathogen, "_parameter.csv")
  params <- read_csv(file_path_pa)

  # Get file pathway for article data
  file_path_ar <- system.file(
    "extdata", paste0(pathogen, "_article.csv"), package = "epireview")
  if (file_path_ar == "")
    file_path_ar <- paste0("../extdata/", pathogen, "_article.csv")
  articles <- read_csv(file_path_ar)

  # Deal with R CMD Check "no visible binding for global variable"
  article_id <- first_author_surname <- year_publication <-
    population_country <- article_label <- NULL

  x <- left_join(params, articles %>%
                   select(article_id, first_author_surname, year_publication),
                 by = "article_id") %>%
    mutate(article_label = as.character(
      paste0(first_author_surname, "", year_publication)),
      population_country = str_replace_all(population_country, ";", ",")) %>%
    arrange(article_label, -year_publication) %>%
    filter(article_id %in% exclude == FALSE)

  return(x)
}
