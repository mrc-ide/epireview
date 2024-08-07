#' Subset the epidemiological parameter columns by parameter type
#'
#' @param data The parameter `data.frame` (`$param`) from [load_epidata()].
#' @param parameter_name A `character` string with the parameter name. Options
#' are: `"cfr"`, `"delay"`, `"sero"`, `"risk"`,
#' `"reproduction_number"`, and `"genomic"`.
#' @param all_columns The default is FALSE meaning that only the key columns
#' specified for the specific parameter will be retrieved. If TRUE, then all
#' columns in the data.frame will be retrieved.
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
                            parameter_name = c("cfr",
                                               "delays",
                                               "sero",
                                               "risk_factors",
                                               "reproduction_number",
                                               "genomic",
                                               "attack_rate",
                                               "doubling_time",
                                               "growth_rate",
                                               "overdispersion",
                                               "relative_contribution"),
                            all_columns = FALSE) {

  if (!is.data.frame(data)) {
    stop("Please provide the epireview parameter table.")
  }

  if(! isTRUE(all_columns)){

  parameter_name <- match.arg(parameter_name)
  cols_func <- switch(parameter_name,
                      cfr = cfr_key_columns,
                      delays = delay_key_columns,
                      sero = sero_key_columns,
                      risk_factors = risk_factors_key_columns,
                      reproduction_number = reproduction_number_key_columns,
                      genomic = genomic_key_columns,
                      attack_rate = attack_double_growth_key_columns,
                      doubling_time = attack_double_growth_key_columns,
                      growth_rate = attack_double_growth_key_columns,
                      overdispersion = overdispersion_contribution_key_columns,
                      relative_contribution = overdispersion_contribution_key_columns
                      )
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
} else cols <- colnames(data)

  data <- data[, cols]

  data
}

#' Key columns across all parameters in the `$params` table from
#' [load_epidata()]
#'
#' @return A `character` vector.
#' @keywords internal
key_columns <- function() {
  c(
    "article_label", "article_info", "population_country",
    "population_sample_size",
    "population_sample_type", "population_group",
    "method_disaggregated", "parameter_type"
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
delay_key_columns <- function() {
  c(key_columns(), c(
    "parameter_value", "parameter_unit", "distribution_type",
    "distribution_par1_value", "distribution_par2_value",
    "other_delay_start","other_delay_end"
  ))
}

#' Key columns for serological parameters in the `$params` table from
#' [load_epidata()]
#'
#' @return A `character` vector.
#' @keywords internal
sero_key_columns <- function() {
  c(key_columns(),
    c("parameter_value",
      "cfr_ifr_numerator", "cfr_ifr_denominator")
  )
}

#' Key columns for risk factor parameters in the `$params` table from
#' [load_epidata()]
#'
#' @return A `character` vector.
#' @keywords internal
risk_factors_key_columns <- function() {
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
      "parameter_value",
      "parameter_unit", "exponent", "genome_site",
      "genomic_sequence_available"
    )
  )
}

#' Key columns for attack rate, doubling time and growth rate parameters in the
#' `$params` table from [load_epidata()]
#'
#' @return A `character` vector.
#' @keywords internal
attack_double_growth_key_columns <- function() {
  c(key_columns(),
    c(
      "parameter_value",
      "parameter_unit", "exponent"
    )
  )
}


#' Key columns for overdispersion and relative contribution to transmission from
#' human-human transmission parameters in the `$params` table from
#' [load_epidata()]
#'
#' @return A `character` vector.
#' @keywords internal
overdispersion_contribution_key_columns <- function() {
  c(key_columns(),
    c(
      "parameter_value",
      "parameter_unit", "exponent"
    )
  )
}


