#' Process data for outbreak table
#'
#' @param pathogen name of pathogen e.g. "marburg"
#' @param prepend string to allow loading data in vignettes
#' @return processed data to use as input for outbreak_table()
#' @importFrom readr read_csv
#' @importFrom dplyr left_join mutate select arrange
#' @examples
#' df <- data_outbreak_table(pathogen = "marburg")
#' @export

data_outbreak_table <- function(pathogen, prepend = "") {

  # Get file pathway for outbreak data
  file_path_ob <- system.file(
    "extdata", paste0(pathogen, "_outbreak.csv"), package = "epireview")
  if (file_path_ob == "")
    file_path_ob <- paste0(prepend, "inst/extdata/", pathogen, "_outbreak.csv")
  outbreak <- read_csv(file_path_ob)

  # Get file pathway for article data
  file_path_ar <- system.file(
    "extdata", paste0(pathogen, "_article.csv"), package = "epireview")
  if (file_path_ar == "")
    file_path_ar <- paste0(prepend, "inst/extdata/", pathogen, "_article.csv")
  articles <- read_csv(file_path_ar)

  # Deal with R CMD Check "no visible binding for global variable"
  article_id <- first_author_surname <- year_publication <-
    outbreak_country <- outbreak_location <- cases_mode_detection <-
    article_label <- NULL

  df <- left_join(outbreak, articles %>%
                    select(article_id, first_author_surname, year_publication),
                  by = "article_id") %>%
    mutate(article_label = as.character(
      paste0(first_author_surname, "", year_publication)),
      outbreak_country = str_replace_all(outbreak_country, ";", ","),
      outbreak_country = str_replace_all(
        outbreak_country, "Yuogslavia", "Yugoslavia"),
      outbreak_country = str_replace_all(
        outbreak_country, "Congo, Dem. Rep.",
        "Democratic Republic of the Congo"),
      outbreak_location = str_replace_all(
        outbreak_location, "Marburg (23), Frankfurt am Main (6), Belgrade (2)",
        "Marburg, Frankfurt am Main, Belgrade"),
           cases_mode_detection =
        gsub("[()]", "", str_replace_all(
          cases_mode_detection, "(PCR etc)", " "))) %>%
    arrange(article_label, -year_publication)

  return(df)
}
