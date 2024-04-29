#' Prepare parameter dataframe for meta analysis of proportions
#' @details
#' The function checks that the format of df is adequate for conducting a meta
#' analysis of proportions. It filters the dataframe to only include rows that
#' meet the required format.
#' TODO: add more description here re the required format
#' @param df a parameter dataframe. This must have columns for each of the
#' following: parameter_value, parameter_unit, plus two columns for the
#' numerator and the denominator of the proportion of interest.
#' This dataframe will typically be the `params`
#' data.frame from the output of \code{\link{load_epireview}}.
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
#' cfr_df <- df[df$parameter_type %in% "Severity - case fatality rate (CFR)",]
#' cfr_filtered <- filter_df_for_metaprop(cfr_df,
#'   num_col = "cfr_ifr_numerator", denom_col = "cfr_ifr_denominator")
#' ## cfr_filtered could then be used directly in meta analyses as:
#' ## mtan <- metaprop(data = cfr_filtered, ...)
filter_df_for_metaprop <- function(df, num_col, denom_col) {

  # must have the correct columns
  cols_needed <- c("parameter_value", "parameter_unit",
                   num_col, denom_col)

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
    df <- filter(df,!( is.na(parameter_value) & !is.na(parameter_unit) ))
  }

  if(any(!is.na(df$parameter_value) & is.na(df$parameter_unit))) {
    message("parameter_unit is missing but parameter_value is present.
            Rows with non-NA parameter_value and NA parameter_unit will be
            removed."
    )
    df <- filter(df,!( !is.na(parameter_value) & is.na(parameter_unit) ))
  }

  # values of the parameter must all have the same units
  if(length(unique(df$parameter_unit[!is.na(df$parameter_unit)])) != 1) {
    msg1 <- "parameter_unit must be the same across all values."
    msg2 <- "Consider calling delays_to_days() if you are working with delays."
    stop(paste(msg1, msg2), call. = FALSE)
  }

  df <- df %>% filter(!is.na(!!denom_col)) %>%
    filter(!(is.na(!!num_col)&is.na(parameter_value))) %>%
    mutate(!! num_col := case_when(
      is.na(!!as.name(num_col)) & !is.na(parameter_value) ~ round((parameter_value/100)*!!as.name(denom_col)),
      TRUE ~ !!as.name(num_col)))

  df
}
