#' Prepare parameter dataframe for meta analysis of means
#'
#' @param df a parameter dataframe. This must have columns for each of the
#' following: parameter_value, parameter_unit, population_sample_size,
#' parameter_value_type, parameter_uncertainty_singe_type,
#' parameter_uncertainty_type, parameter_uncertainty_lower_value,
#' parameter_uncertainty_upper_value
#'
#' @return a parameter dataframe with relevant rows selected
#'
#' @details The function checks that the format of df is adequate for conducting
#' a meta analysis of means, returns errors where this is not the case,
#' and filters the rows which do not match the required format.
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
  if(!"parameter_value" %in% names(df)){
    stop("df must have a column parameter_value.")
  }
  if(!"parameter_unit" %in% names(df)){
    stop("df must have a column parameter_unit.")
  }
  if(!"population_sample_size" %in% names(df)){
    stop("df must have a column population_sample_size.")
  }
  if(!"parameter_value_type" %in% names(df)){
    stop("df must have a column parameter_value_type.")
  }
  if(!"parameter_uncertainty_singe_type" %in% names(df)){
    stop("df must have a column parameter_uncertainty_singe_type.")
  }
  if(!"parameter_uncertainty_type" %in% names(df)){
    stop("df must have a column parameter_uncertainty_type.")
  }
  if(!"parameter_uncertainty_lower_value" %in% names(df)){
    stop("df must have a column parameter_uncertainty_lower_value.")
  }
  if(!"parameter_uncertainty_upper_value" %in% names(df)){
    stop("df must have a column parameter_uncertainty_upper_value.")
  }

  # values of the parameter must all have the same units
  if(length(unique(df$parameter_unit[!is.na(df$parameter_unit)])) != 1) {
    stop("parameter_unit must be the same across all values.")
  }

  df <- df %>% filter(!is.na(population_sample_size)) %>%
    filter(!is.na(parameter_value)) %>%
    filter((parameter_value_type == 'Mean' & parameter_uncertainty_singe_type == 'Standard deviation (Sd)') |
             (parameter_value_type == 'Median' & parameter_uncertainty_type == 'Inter Quartile Range (IQR)') |
             (parameter_value_type == 'Median' & parameter_uncertainty_type == 'Range'))

  df <- df %>% mutate(xbar = ifelse(parameter_value_type == "Mean", parameter_value, NA),
                                    median = ifelse(parameter_value_type == "Median", parameter_value, NA),
                                    q1     = ifelse(parameter_uncertainty_type == "Inter Quartile Range (IQR)", parameter_uncertainty_lower_value, NA),
                                    q3     = ifelse(parameter_uncertainty_type == "Inter Quartile Range (IQR)", parameter_uncertainty_upper_value, NA),
                                    min    = ifelse(parameter_uncertainty_type == "Range", parameter_uncertainty_lower_value, NA),
                                    max    = ifelse(parameter_uncertainty_type == "Range", parameter_uncertainty_upper_value, NA))

  return(df)
}
