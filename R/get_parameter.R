## function name get_parameter

#' retrieve all parameters of specified type or class
#' @param data parameter dataframe output from \code{\link{load_epidata}}
#' @param parameter_name name of the parameter type or parameter class to 
#' retrieve, ensuring the name matches that in data
#' @return dataframe with all parameter estimates and columns
#' @export
#' @examples
#' df <- load_epidata(pathogen = "ebola")
#' get_parameter(data = df$params, parameter_name = "Human delay - serial interval")
#' @examples
#' df <- load_epidata(pathogen = "marburg")
#' get_parameter(data = df$params, parameter_name = "Attack rate")

get_parameter <- function(data, parameter_name) {
  # Validate input: check if 'data' is a dataframe
  if (!is.data.frame(data)) {
    stop("Error: 'data' should be a dataframe.")
  }

  # Validate input: check if 'parameter_name' is a non-empty string
  if (!is.character(parameter_name) || parameter_name == "") {
    stop("Error: 'parameter_name' must be a non-empty string.")
  }

  # Validate that 'parameter_type' column exists in 'data'
  if (!"parameter_type" %in% names(data)) {
    stop("Error: 'data' does not contain the required 'parameter_type' column.")
  }

  # Validate that 'parameter_class' column exists in 'data'
  if (!"parameter_class" %in% names(data)) {
    stop("Error: 'data' does not contain the required 'parameter_class' column.")
  }

  # Check if there are any entries that match 'parameter_name' or 'parameter_class'
  if (sum(data$parameter_type == parameter_name) == 0 & 
    sum(data$parameter_class == parameter_name) == 0) {
    stop("Error: No entries found matching the specified 'parameter_name'.
      Check spelling and case of 'parameter name'.")
  }

  # if
  if(parameter_name %in% data$parameter_type){

    # Extract and return the matching rows
    get_param <- data[data$parameter_type == parameter_name, , drop = FALSE]

  }
  else if(parameter_name %in% data$parameter_class){

    # Extract and return the matching rows
    get_param <- data[data$parameter_class == parameter_name, , drop = FALSE]

  }

  get_param
}



#' Retrieve all incubation period parameters for a given pathogen
#'
#' @param data parameter dataframe output from \code{\link{load_epidata}}
#' @inheritParams get_key_columns
#' @return dataframe with all parameter estimates of this type and key columns 
#' (see \code{\link{get_key_columns}})
#' @export
#' @name get_specific
#'
#' @examples
#' df <- load_epidata(pathogen = "lassa")
#' get_incubation_period(data = df$params)

get_incubation_period <- function(data, all_columns){

  get_key_columns(
    get_parameter(data,"Human delay - incubation period"),
    "delays",
    all_columns
  )

}

#' Retrieve all serial interval estimates for a given pathogen
#' @name get_specific
#' @inheritParams get_key_columns
get_serial_interval <- function(data, all_columns){

  get_key_columns(
    get_parameter(data,"Human delay - serial interval"),
    "delays",
    all_columns
  )

}

#' Retrieve all generation time estimates for a given pathogen
#' @inheritParams get_key_columns
#' @name get_specific
get_generation_time <- function(data, all_columns){

  get_key_columns(
    get_parameter(data,"Human delay - generation time"),
    "delays",
    all_columns
  )

}

#' Retrieve all delay parameters for a given pathogen
#'@name get_specific
#'@inheritParams get_key_columns
get_delays <- function(data, all_columns){

  get_key_columns(
    get_parameter(data,"Human delay"),
    "delays",
    all_columns
  )

}


#' Retrieve all CFR parameters for a given pathogen
#'@name get_specific
get_cfr <- function(data, all_columns){

  get_key_columns(
    get_parameter(data,"Severity - case fatality rate (CFR)"),
    "cfr",
    all_columns
  )

}

#' Retrieve all risk factor parameters for a given pathogen
#'@inheritParams get_key_columns
#'@name get_specific
get_risk_factors <- function(data, all_columns){

  get_key_columns(
    get_parameter(data,"Risk factors"),
    "risk_factors",
    all_columns
  )

}

#' Retrieve all genomic parameters for a given pathogen
#'@inheritParams get_key_columns
#'@name get_specific
get_genomic <- function(data, all_columns){

  get_key_columns(
    get_parameter(data,"Mutations"),
    "genoomic",
    all_columns
  )

}

#' Retrieve all reproduction number parameters for a given pathogen
#'@inheritParams get_key_columns
#'@name get_specific
get_reproduction_number <- function(data, all_columns){

  get_key_columns(
    get_parameter(data,"Reproduction number"),
    "reproduction_number",
    all_columns
  )

}

#' Retrieve all seroprevalence parameters for a given pathogen
#' @inheritParams get_key_columns
#' @name get_specific
get_seroprevalence <- function(data, all_columns){

  get_key_columns(
    get_parameter(data,"Seroprevalence"),
    "sero",
     all_columns
  )

}

#' Retrieve all doubling time parameters for a given pathogen
#' @inheritParams get_key_columns
#' @name get_specific
get_doubling_time <- function(data, all_columns){

  get_key_columns(
    get_parameter(data,"Doubling time"),
    "doubling_time",
     all_columns
  )

}

#' Retrieve all attack rate parameters for a given pathogen
#' @inheritParams get_key_columns
#' @name get_specific
get_attack_rate <- function(data, all_columns){

  get_key_columns(
    get_parameter(data,"Attack rate"),
    "attack_rate",
    all_columns
  )

}


#' Retrieve all growth rate parameters for a given pathogen
#' @inheritParams get_key_columns
#' @name get_specific
get_growth_rate <- function(data, all_columns){

  get_key_columns(
    get_parameter(data,"Growth rate (r)"),
    "growth_rate",
    all_columns
  )

}


#' Retrieve all overdispersion parameters for a given pathogen
#' @inheritParams get_key_columns
#' @name get_specific
get_overdispersion <- function(data, all_columns){

  get_key_columns(
    get_parameter(data,"Overdispersion"),
    "overdispersion",
    all_columns
  )

}

#' Retrieve all overdispersion parameters for a given pathogen
#' @inheritParams get_key_columns
#' @name get_specific
get_relative_contribution <- function(data, all_columns){

  get_key_columns(
    get_parameter(data,"Relative contribution"),
    "relative_contribution",
    all_columns
  )

}


