## function name get_parameter

#' retrieve all parameters of specified type
#' @param data parameter dataframe output from \code{\link{load_epidata}}
#' @param parameter_name name of the parameter type to retrieve, ensuring the
#' name matches that in data
#' @return dataframe with all parameter estimates and specified columns
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

  # Check if there are any entries that match 'parameter_name'
  if (sum(data$parameter_type == parameter_name) == 0) {
    stop("Error: No entries found matching the specified 'parameter_name'.
      Check spelling and case of 'parameter name'.")
  }

  # Extract and return the matching rows
  get_param <- data[data$parameter_type == parameter_name, , drop = FALSE]

  get_param
}

#' Retrieve all incubation period values for a given pathogen
#'
#' @param data
#'
#' @return
#' @export
#' @name get_specific
#'
#' @examples
#'
#'
get_incubation_period <- function(data){

  get_key_columns(
    get_parameter(data,"Human delay - incubation period"),
    "delays"
  )


}

#' @name get_specific

get_serial_interval <- function(data){

  get_key_columns(
    get_parameter(data,"Human delay - serial interval"),
    "delays"
  )

}


#' @name get_specific
get_generation_time <- function(data){

  get_key_columns(
    get_parameter(data,"Human delay - generation time"),
    "delays"
  )

}


#'@name get_specific
get_cfr <- function(data){

  get_key_columns(
    get_parameter(data,"Severity - case fatality rate (CFR)"),
    "cfr"
  )

}









