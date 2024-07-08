#' Create new outbreak entry
#'
#' @param pathogen name of pathogen
#' @param new_outbreak all the required details for the new outbreak as a list
#' @importFrom tibble as_tibble as_tibble_row
#' @importFrom validate validator confront summary %vin%
#' @importFrom dplyr select
#' @importFrom readr read_csv
#' @importFrom stats na.omit
#' @importFrom methods as
#' @importFrom cli cli_abort
#' @return return new row of data to be added to the outbreak data set using
#' the append_new_entry_to_table() function
#' @export
create_new_outbreak_entry <- function(pathogen, new_outbreak) {
  
  # assertions
  assert_pathogen(pathogen)
  
  # read current article data for pathogen
  articles <- as_tibble(load_epidata_raw(pathogen = pathogen, "article"))
  
  old_outbreaks <- as_tibble(load_epidata_raw(pathogen = pathogen, "outbreak"))
  
  new_row <- as_tibble_row(new_outbreak)
  
  # generate the below quantities
  new_row$outbreak_id <- max(old_outbreaks$outbreak_id) + 1
  new_row <- new_row %>% select(colnames(old_outbreaks))
  
  # Need to check that article_id & covidence_id exist in the articles table.
  if (!(new_row$article_id %in% articles$article_id &&
        articles[articles$article_id == new_row$article_id, ]$covidence_id ==
        new_row$covidence_id))
    cli_abort("Article_id + Covidence_id pair does not exist in article data")

  # available options for fields
  file_path_ob <- system.file("extdata",
                              paste0(pathogen, "_dropdown_outbreaks.csv"),
                              package = "epireview")
  
  outbreak_options <- read_csv(file_path_ob, show_col_types = FALSE)
  
  # Deal with R CMD Check "no visible binding for global variable"
  outbreak_country <- cases_mode_detection <- outbreak_date_year <-
    fails <- NULL
  
  # validate that the entries make sense
  rules <- validator(
    outbreak_country_is_character = is.character(outbreak_country),
    outbreak_country_valid = strsplit(outbreak_country, ",")[[1]] %vin%
      na.omit(outbreak_options$`Outbreak country`),
    cases_mode_detection_is_character = is.character(cases_mode_detection),
    cases_mode_detection_valid = strsplit(cases_mode_detection, ",")[[1]] %vin%
      na.omit(outbreak_options$`Detection mode`),
    outbreak_date_year_is_integer = outbreak_date_year %% 1 == 0,
    outbreak_date_year_after_1800 = outbreak_date_year > 1800,
    outbreak_date_year_not_future = outbreak_date_year <
      (as.integer(substring(Sys.Date(), 1, 4)) + 2)
  )
  
  rules_output <- confront(new_row, rules)
  rules_summary <- summary(rules_output)
  
  print(as_tibble(rules_summary) %>% filter(fails > 0))
  
  if (sum(rules_summary$fails) > 0) {
    cli_abort(as_tibble(rules_summary) %>% filter(fails > 0))
  }
  
  ## Check for columns in old data that are not in new data
  ## and add them to new data with NA values with the same class
  ## as the corresponding column in the old data.
  for (col in colnames(old_outbreaks)) {
    if (!(col %in% colnames(new_row))) {
      new_row[[col]] <- as(NA, class(old_outbreaks[[col]]))
    }
  }

  new_row
}
