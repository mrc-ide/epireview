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
#' data.frame from the output of \code{load_epidata}.
#'
#'
#' @return a parameter dataframe with relevant rows selected and additional columns
#' added to facilitate the meta analysis of means. The additional columns are:
#' xbar, median, q1, q3, min, max.
#'
#' @importFrom cli cli_inform cli_abort
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
  cols_needed <- c("parameter_value", "parameter_unit", "population_sample_size",
                   "parameter_value_type", "parameter_uncertainty_singe_type",
                   "parameter_uncertainty_type", "parameter_uncertainty_lower_value",
                   "parameter_uncertainty_upper_value")
  
  df <- check_df_for_meta(df, cols_needed)
  
  df <- df[!is.na(df[["population_sample_size"]]), ]
  df <- df[!is.na(df[["parameter_value"]]), ]
  df <- df[df[["parameter_value_type"]] == 'Mean' & 
              grepl(x = tolower(df[["parameter_uncertainty_singe_type"]]), 
                    pattern = 'standard deviation') |
              df[["parameter_value_type"]] == 'Median' & 
              grepl(x = tolower(df[["parameter_uncertainty_type"]]), 
                    pattern = 'iqr') |
              df[["parameter_value_type"]] == 'Median' & 
              grepl(x = tolower(df[["parameter_uncertainty_type"]]), 
                    pattern = 'range'), ]
  
  df$xbar <- ifelse(
    df[["parameter_value_type"]] == "Mean", df[["parameter_value"]], NA
  )
  df$median <- ifelse(
    df[["parameter_value_type"]] == "Median", df[["parameter_value"]], NA
  )
  df$q1 <- ifelse(
    grepl(x = tolower(df[["parameter_uncertainty_type"]]), "iqr"),
    df[["parameter_uncertainty_lower_value"]], NA
  )
  df$q3 <- ifelse(
    grepl(x = tolower(df[["parameter_uncertainty_type"]]), "iqr"),
    df[["parameter_uncertainty_upper_value"]], NA
  )
  df$min <- ifelse(
    grepl(x = tolower(df[["parameter_uncertainty_type"]]), pattern = "range") &
    !grepl(x = tolower(df[["parameter_uncertainty_type"]]), "iqr"),
    df[["parameter_uncertainty_lower_value"]], NA
  )
  df$max <- ifelse(
    grepl(x = tolower(df[["parameter_uncertainty_type"]]), pattern = "range") &
    !grepl(x = tolower(df[["parameter_uncertainty_type"]]), pattern = "iqr"),
    df[["parameter_uncertainty_upper_value"]], NA
  )
  
  df
}
