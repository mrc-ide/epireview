## function name get_parameter

#' retrieve all parameters of specified type
#' @param data parameter dataframe outputted from load_epidata()
#' @param parameter_name name of the parameter type to retrieve, ensuring the name matches that in data
#' @return dataframe with all parameter estimates and specified columns
#' @examples
#' df <- load_epidata(pathogen = "ebola")
#' get_parameter(data = df$params, parameter_name = "Human delay - serial interval")
#' @examples
#' df <- load_epidata(pathogen = "marburg")
#' get_parameter(data = df$params, parameter_name = "Attack rate")

get_parameter <- function(data, parameter_name) {
  if(length(data[which(data$parameter_type == parameter_name),]) == 0) {
    stop("data should be the parameter dataframe outputted from load_epidata()")
  } else {
    index <- which(data$parameter_type == parameter_name)
    get_param <- data[index,]
    if(nrow(get_param) == 0) {
      warning("There are no available estimates for the specified parameter name. Check that you have entered parameter type correctly.")
    }
    get_param
  }
}
