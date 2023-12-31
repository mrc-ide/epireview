#' create a date
#' @param start_day   start day
#' @param start_month start month
#' @param start_year  start year
#' @importFrom stringr str_split_fixed
#' @export
date_start <- function(start_day, start_month, start_year) {
  start_day <- as.character(start_day)
  start_year <- as.character(start_year)

  if (!is.na(start_day)) {
    start_date <- paste0(
      start_day, "", str_split_fixed(start_month, "", 1)[1], "", start_year)
  } else if (is.na(start_day) && !is.na(start_month)) {
    start_date <- paste0(
      str_split_fixed(start_month, "", 1)[1], "", start_year)
  } else if (is.na(start_day) && is.na(start_month)) {
    start_date <- start_year
  }
  start_date
}
