#' Prepare parameter dataframe for meta analysis of means
#' @details
#' The function checks that the format of df is adequate for conducting a meta
#' analysis of means. It filters the dataframe to only include rows that meet the
#' required format.
#' We can only conduct a meta analysis for a parameter if its estimates have been
#' reported as (a) mean and standard deviation, (b) median and interquartile
#' range, or (c) median and range. This function filters the parameter dataframe
#' to only include rows that meet these criteria. It also checks that the
#' parameter values are all in the same units; and that the sample size is
#' reported for each parameter value.
#' @param df a parameter dataframe. This must have columns for each of the
#' following: parameter_value, parameter_unit, population_sample_size,
#' parameter_value_type, parameter_uncertainty_singe_type,
#' parameter_uncertainty_type, parameter_uncertainty_lower_value,
#' parameter_uncertainty_upper_value. This will typically be the `params`
#' data.frame from the output of \code{load_epireview}.
#'
#'
#' @return a parameter dataframe with relevant rows selected and additional columns
#' added to facilitate the meta analysis of means. The additional columns are:
#' xbar, median, q1, q3, min, max.
#'
#'
#' @export
#'
#' @examples
#' ## preparing data for meta analyses of delay from symptom onset to
#' ## hospitalisation for Lassa
#'
#' df <- load_epidata("lassa")[["params"]]
#' o2h_df <- df[df$parameter_type %in% "Human delay - symptom onset>admission to care", ]
#' o2h_df_filtered <- filter_df_for_metamean(o2h_df)
#' ## o2h_df_filtered could then be used directly in meta analyses as:
#' ## mtan <- metamean(data = o2h_df_filtered, ...)
filter_df_for_metamean <- function(df) {

  # must have the correct columns
  cols_needed <- c("parameter_value", "parameter_unit", "population_sample_size",
                   "parameter_value_type", "parameter_uncertainty_singe_type",
                   "parameter_uncertainty_type", "parameter_uncertainty_lower_value",
                   "parameter_uncertainty_upper_value")

  if (!all(cols_needed %in% colnames(df))) {
    cols_missing <- cols_needed[!cols_needed %in% colnames(df)]
    stop(
      "df must have columns named: ", paste(cols_needed, collapse = ", "),
      ". Columns missing: ", paste(cols_missing, collapse = ", "),
      call. = FALSE
    )
  }

  ## Ensure that there is a single parameter type present
  if(length(unique(df$parameter_type)) != 1) {
    stop("parameter_type must be the same across all values.", call. = FALSE)
  }

  ## First check that there are no rows where a value is present but unit is
  ## missing, or vice versa
  if(any(is.na(df$parameter_value) & !is.na(df$parameter_unit))) {
    message("parameter_value must be present if parameter_unit is present.
            Rows with non-NA parameter_value and NA parameter_unit will be
            removed.")
    df <- filter(df,!( is.na(.data[["parameter_value"]]) & !is.na(.data[["parameter_unit"]]) ))
  }

  if(any(!is.na(df$parameter_value) & is.na(df$parameter_unit))) {
    message("parameter_unit is missing but parameter_value is present.
            Rows with non-NA parameter_value and NA parameter_unit will be
            removed."
    )
    df <- filter(df,!( is.na(.data[["parameter_value"]]) & 
      !is.na(.data[["parameter_unit"]]) ))
  }

  # values of the parameter must all have the same units
  if(length(unique(df$parameter_unit[!is.na(df$parameter_unit)])) != 1) {
    msg1 <- "parameter_unit must be the same across all values."
    msg2 <- "Consider calling delays_to_days() if you are working with delays."
    stop(paste(msg1, msg2), call. = FALSE)
  }

  df <- df %>% filter(!is.na(.data[["population_sample_size"]])) %>%
    filter(!is.na(.data[["parameter_value"]])) %>%
    filter(
      (.data[["parameter_value_type"]] == 'Mean' & 
        grepl(x = tolower(.data[["parameter_uncertainty_singe_type"]]), 
          pattern = 'standard deviation')) |
      (.data[["parameter_value_type"]] == 'Median' & 
        grepl(x = tolower(.data[["parameter_uncertainty_type"]]), 
          pattern = 'iqr')) |
      (.data[["parameter_value_type"]] == 'Median' & 
        grepl(x = tolower(.data[["parameter_uncertainty_type"]]), 
          pattern = 'range'))
    )

  df <- mutate(
    df,
    xbar = ifelse(
      .data[["parameter_value_type"]] == "Mean", .data[["parameter_value"]], NA),
    median = ifelse(
      .data[["parameter_value_type"]] == "Median", .data[["parameter_value"]], NA
    ),
    q1 = ifelse(
      grepl(x = tolower(.data[["parameter_uncertainty_type"]]), "iqr"),
      .data[["parameter_uncertainty_lower_value"]], NA),
    q3 = ifelse(grepl(x = tolower(.data[["parameter_uncertainty_type"]]), "iqr"),
      .data[["parameter_uncertainty_upper_value"]], NA),
    min = ifelse(
      grepl(
        x = tolower(.data[["parameter_uncertainty_type"]]), pattern = "range"
      ) &
      !grepl(x = tolower(.data[["parameter_uncertainty_type"]]), "iqr"),
      .data[["parameter_uncertainty_lower_value"]], NA
    ),
    max = ifelse(
      grepl(x = tolower(.data[["parameter_uncertainty_type"]]), pattern = "range"
      ) &
      !grepl(x = tolower(.data[["parameter_uncertainty_type"]]), pattern = "iqr"),
      .data[["parameter_uncertainty_upper_value"]], NA
    )
  )

  df
}
