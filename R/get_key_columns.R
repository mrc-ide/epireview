#' Subset the epidemiological parameter columns by parameter type
#'
#' @param data The parameter `data.frame` (`$param`) from [load_epidata()].
#' @param parameter_name A `character` string with the parameter name. Options
#' are: `"cfr"`, `"delays"`, `"sero"`, `"risk"`,
#' `"reproduction_number"`, and `"genomic"`.
#'
#' @return A `data.frame` with the key columns for the selected parameter.
#' @export
#'
#' @examples
#' lassa_data <- load_epidata("lassa")
#' lassa_params <- lassa_data$params
#' cfr_lassa <- get_parameter(
#'   data = lassa_params,
#'   parameter_name = "Severity - case fatality rate (CFR)"
#' )
#' get_key_columns(data = cfr_lassa, parameter_name = "cfr")
get_key_columns <- function(data,
                            parameter_name = c("cfr", "delays", "sero", "risk",
                                               "reproduction_number",
                                               "genomic")) {
  if (!is.data.frame(data)) {
    stop("Please provide the epireview parameter table.")
  }
  parameter_name <- match.arg(parameter_name)
  cols_func <- switch(parameter_name,
                      cfr = cfr_key_columns,
                      delays = delays_key_columns,
                      sero = sero_key_columns,
                      risk = risk_factor_key_columns,
                      reproduction_number = reproduction_number_key_columns,
                      genomic = genomic_key_columns)
  cols <- do.call(cols_func, args = list())
  if (!all(cols %in% colnames(data))) {
    warning(
    "THIS FUNCTIONALITY IS UNDER ACTIVE DEVELOPMENT\n" ,
    "Some of the key columns are not found in the data, only returning ",
    "those found",
    call. = FALSE
    )
    cols <- cols[cols %in% colnames(data)]
  }
  data <- data[, cols]
  return(data)
}

#' Key columns across all parameters in the `$params` table from
#' [load_epidata()]
#'
#' @return A `character` vector.
#' @keywords internal
key_columns <- function() {
  c(
    "article_label", "population_sample_size", "population_location",
    "population_group", "method_disaggregated", "parameter_type"
  )
}

#' Key columns for CFR parameters in the `$params` table from [load_epidata()]
#'
#' @return A `character` vector.
#' @keywords internal
cfr_key_columns <- function() {
  c(key_columns(),  c(
    "parameter_value", "cfr_ifr_numerator", "cfr_ifr_denominator",
    "cfr_ifr_method"
  ))
}

#' Key columns for delay distribution parameters in the `$params` table from
#' [load_epidata()]
#'
#' @return A `character` vector.
#' @keywords internal
delays_key_columns <- function() {
  c(key_columns(), c(
    "parameter_value", "parameter_unit", "distribution_type",
    "distribution_par1_value", "distribution_par2_value", "other_delay_start",
    "other_delay_end"
  ))
}

#' Key columns for serological parameters in the `$params` table from
#' [load_epidata()]
#'
#' @return A `character` vector.
#' @keywords internal
sero_key_columns <- function() {
  c(key_columns(),
    c("parameter_value", "cfr_ifr_numerator", "cfr_ifr_denominator")
  )
}

#' Key columns for risk factor parameters in the `$params` table from
#' [load_epidata()]
#'
#' @return A `character` vector.
#' @keywords internal
risk_factor_key_columns <- function() {
  c(key_columns(),
    c(
      "riskfactor_outcome", "riskfactor_name", "riskfactor_significant",
      "riskfactor_adjusted"
    )
  )
}

#' Key columns for reproduction number parameters in the `$params` table from
#' [load_epidata()]
#'
#' @return A `character` vector.
#' @keywords internal
reproduction_number_key_columns <- function() {
  c(key_columns(),
    c(
      "parameter_value", "method_r", "parameter_unit"
    )
  )
}

#' Key columns for genomic parameters in the `$params` table from
#' [load_epidata()]
#'
#' @return A `character` vector.
#' @keywords internal
genomic_key_columns <- function() {
  c(key_columns(),
    c(
      "parameter_value", "parameter_unit", "exponent", "genome_site",
      "genomic_sequence_available"
    )
  )
}

