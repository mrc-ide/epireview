#' Process data for use in risk_table()
#'
#' @param pathogen name of pathogen e.g. "marburg"
#' @param exclude article IDs to exclude
#' @return processed data to use as input for risk_table()
#' @importFrom readr read_csv
#' @importFrom stringr str_replace_all
#' @importFrom dplyr select arrange filter mutate
#' @examples
#' data_risk_table(pathogen = "marburg", exclude = c(15, 17))
#' @export

data_risk_table <- function(pathogen, exclude) {

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
article_id <- article_label <- first_author_surname <- year_publication <-
  population_country <- NULL

df <- left_join(params, articles %>%
                  select(article_id, first_author_surname, year_publication),
                by = "article_id") %>%
  mutate(article_label =
           as.character(paste0(first_author_surname, "", year_publication)),
         population_country =
           str_replace_all(population_country, ";", ",")) %>%
  arrange(article_label, -year_publication) %>%
  filter(article_id %in% exclude == FALSE)

return(df)

}
