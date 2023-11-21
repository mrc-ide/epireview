#' Create new outbreak entry
#'
#' @param pathogen name of pathogen
#' @param new_outbreak all the required details for the new outbreak
#' @param vignette_prepend string to allow loading data in vignettes
#' @importFrom tibble as_tibble as_tibble_row
#' @importFrom validate validator confront summary %vin%
#' @importFrom dplyr select
#' @importFrom readr read_csv
#' @importFrom stats na.omit
#' @return return new row of data to be added to the outbreak data set using
#' the append_new_entry_to_table() function
#' @examples
#' create_new_outbreak_entry(
#'   pathogen = "marburg",
#'   new_outbreak = c(list("article_id"           = as.integer(1)),
#'                    list("outbreak_start_day"   = as.integer(NA)),
#'                    list("outbreak_start_month" = as.character(NA)),
#'                    list("outbreak_start_year"  = as.integer(1999)),
#'                    list("outbreak_end_day"     = as.integer(NA)),
#'                    list("outbreak_end_month"   = as.character(NA)),
#'                    list("outbreak_date_year"   = as.integer(2001)),
#'                    list("outbreak_duration_months" = as.integer(NA)),
#'                    list("outbreak_size"        = as.integer(2)),
#'                    list("asymptomatic_transmission" = as.integer(0)),
#'                    list("outbreak_country"     = as.character("Tanzania")),
#'                    list("outbreak_location"    = as.character(NA)),
#'                    list("cases_confirmed"      = as.integer(NA)),
#'                    list("cases_mode_detection" = as.character(NA)),
#'                    list("cases_suspected"      = as.integer(NA)),
#'                    list("cases_asymptomatic"   = as.integer(NA)),
#'                    list("deaths"               = as.integer(2)),
#'                    list("cases_severe_hospitalised" = as.integer(NA)),
#'                    list("covidence_id"         = as.integer(2059)))
#'   )
#' @export
create_new_outbreak_entry <-
  function(pathogen = NA,
           new_outbreak = c(list("article_id"           = as.integer(NA)),
                            list("outbreak_start_day"   = as.integer(NA)),
                            list("outbreak_start_month" = as.character(NA)),
                            list("outbreak_start_year"  = as.integer(NA)),
                            list("outbreak_end_day"     = as.integer(NA)),
                            list("outbreak_end_month"   = as.character(NA)),
                            list("outbreak_date_year"   = as.integer(NA)),
                            list("outbreak_duration_months" = as.integer(NA)),
                            list("outbreak_size"        = as.integer(NA)),
                            list("asymptomatic_transmission" = as.integer(NA)),
                            list("outbreak_country"     = as.character(NA)),
                            list("outbreak_location"    = as.character(NA)),
                            list("cases_confirmed"      = as.integer(NA)),
                            list("cases_mode_detection" = as.character(NA)),
                            list("cases_suspected"      = as.integer(NA)),
                            list("cases_asymptomatic"   = as.integer(NA)),
                            list("deaths"               = as.integer(NA)),
                            list("cases_severe_hospitalised" = as.integer(NA)),
                            list("covidence_id"         = as.integer(NA))),
           vignette_prepend = "") {

  # assertions
  assert_pathogen(pathogen)

  # read current article data for pathogen
  articles <- as_tibble(load_epidata(table_type = "article",
                                     pathogen = pathogen,
                                     vignette_prepend = vignette_prepend))
  old_outbreaks <- as_tibble(load_epidata(table_type = "outbreak",
                                          pathogen = pathogen,
                                          vignette_prepend = vignette_prepend))
  #read current article data for pathogen
    articles <- as_tibble(load_epidata_raw(
      pathogen = pathogen, "article")
    )
  old_outbreaks <- as_tibble(load_epidata_raw(pathogen = pathogen, "outbreak"
                                          ))
  new_row <- as_tibble_row(new_outbreak)

  # generate the below quantities
  new_row$outbreak_id  <- max(old_outbreaks$outbreak_id) + 1
  new_row              <- new_row %>% select(colnames(old_outbreaks))

  # Need to check that article_id & covidence_id exist in the articles table.
  if (!(new_row$article_id %in% articles$article_id &&
       articles[articles$article_id == new_row$article_id, ]$covidence_id ==
       new_row$covidence_id))
    stop("Article_id + Covidence_id pair does not exist in article data")

  # available options for fields
  file_path_ob  <- system.file("extdata",
                               paste0(pathogen, "_dropdown_outbreaks.csv"),
                               package = "epireview")
  if (file_path_ob == "") {
    file_path_ob <- paste0(vignette_prepend,
                          "extdata/", pathogen, "_dropdown_outbreaks.csv")
  }
  outbreak_options <- read_csv(file_path_ob)

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
    outbreak_date_year_is_integer = is.integer(outbreak_date_year),
    outbreak_date_year_after_1800 = outbreak_date_year > 1800,
    outbreak_date_year_not_future = outbreak_date_year <
      (as.integer(substring(Sys.Date(), 1, 4)) + 2)
  )

  rules_output  <- confront(new_row, rules)
  rules_summary <- summary(rules_output)

  print(as_tibble(rules_summary) %>% filter(fails > 0))

  if (sum(rules_summary$fails) > 0) {
    stop(as_tibble(rules_summary) %>% filter(fails > 0))
  }

  return(new_row)
}
