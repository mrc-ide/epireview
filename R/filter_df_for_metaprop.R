#' Prepare parameter dataframe for meta analysis of proportions
#' @details
#' The function checks that the format of df is adequate for conducting a meta
#' analysis of proportions. It filters the dataframe to only include rows that
#' meet the required format by (1) removing rows where the denominator is missing,
#' and (2) removing rows where both the numerator column or parameter value are
#' missing. If the numerator column is missing and the parameter value is present,
#' the numerator is imputed as the parameter value divided by 100 times the
#' denominator.
#'
#' @param df a parameter dataframe. This must have columns for each of the
#' following: parameter_value, parameter_unit, plus two columns for the
#' numerator and the denominator of the proportion of interest.
#' This dataframe will typically be the `params`
#' data.frame from the output of \code{\link{load_epidata}}.
#' @param num_col a string specifying the column name for the column containing
#' the numerator of the proportion of interest.
#' @param denom_col a string specifying the column name for the column
#' containing the denominator of the proportion of interest.
#'
#' @return a parameter dataframe with relevant rows selected to enable
#' meta analysis of proportions.
#'
#' @export
#'
#' @examples
#' ## preparing data for meta analyses of CFR for Lassa
#'
#' df <- load_epidata("lassa")[["params"]]
#' cfr_df <- df[df$parameter_type %in% "Severity - case fatality rate (CFR)", ]
#' cfr_filtered <- filter_df_for_metaprop(cfr_df,
#'   num_col = "cfr_ifr_numerator", denom_col = "cfr_ifr_denominator"
#' )
#' ## cfr_filtered could then be used directly in meta analyses as:
#' ## mtan <- metaprop(data = cfr_filtered, ...)
filter_df_for_metaprop <- function(df, num_col, denom_col) {
  cols_needed <- c("parameter_value", "parameter_unit", num_col, denom_col)

  df <- check_df_for_meta(df, cols_needed)

  df <- df[!is.na(df[[denom_col]]), ]
  df <- df[!(is.na(df[[num_col]]) & is.na(df[["parameter_value"]])), ]

  df[[num_col]] <- ifelse(
    is.na(df[[num_col]]) & !is.na(df[["parameter_value"]]),
    round((df[["parameter_value"]] / 100) * df[[denom_col]]),
    df[[num_col]]
  )

  df
}
