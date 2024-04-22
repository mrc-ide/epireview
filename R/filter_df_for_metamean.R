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
#' data.frame from the output of \code{\link{load_epireview}}.
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
#' ## TODO: rewrite example once the curation functions exist with examples
#' ## of how to then use metamean function
#' df <- readRDS("tests/testthat/data/example_param_df.RDS")
#' dataframe <- filter_df_for_metamean(df)
#' ## mtan <- metamean(data = dataframe, ...)
#'
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
    warning("parameter_value must be present if parameter_unit is present.
            Rows with non-NA parameter_value and NA parameter_unit will be 
            removed.")
    df <- filter(df, is.na(parameter_value) & !is.na(parameter_unit))
  }

  if(any(!is.na(df$parameter_value) & is.na(df$parameter_unit))) {
    warning("parameter_unit is missing but parameter_value is present.
            Rows with non-NA parameter_value and NA parameter_unit will be 
            removed."
    )
    df <- filter(df, !is.na(parameter_value) & is.na(parameter_unit))
  }

  # values of the parameter must all have the same units
  if(length(unique(df$parameter_unit[!is.na(df$parameter_unit)])) != 1) {
    msg1 <- "parameter_unit must be the same across all values."
    msg2 <- "Consider calling delays_to_days() if you are working with delays."
    stop(paste(msg1, msg2), call. = FALSE)
  }

  df <- df %>% filter(!is.na(population_sample_size)) %>%
    filter(!is.na(parameter_value)) %>%
    filter(
      (parameter_value_type == 'Mean' & parameter_uncertainty_singe_type == 'Standard deviation (Sd)') |
      (parameter_value_type == 'Median' & parameter_uncertainty_type == 'Inter Quartile Range (IQR)') |
      (parameter_value_type == 'Median' & parameter_uncertainty_type == 'Range')
    )

  df <- mutate(
    df, 
    xbar = ifelse(parameter_value_type == "Mean", parameter_value, NA),
    median = ifelse(parameter_value_type == "Median", parameter_value, NA),
    q1 = ifelse(parameter_uncertainty_type == "Inter Quartile Range (IQR)", 
      parameter_uncertainty_lower_value, NA),
    q3 = ifelse(parameter_uncertainty_type == "Inter Quartile Range (IQR)", 
      parameter_uncertainty_upper_value, NA),
    min = ifelse(parameter_uncertainty_type == "Range", 
      parameter_uncertainty_lower_value, NA),
    max = ifelse(parameter_uncertainty_type == "Range", 
      parameter_uncertainty_upper_value, NA)
  )

  df
}