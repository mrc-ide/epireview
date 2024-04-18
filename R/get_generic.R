## function name get_generic

#' retrieve all parameters of specified type
#' @param data parameter dataframe outputted from load_epidata()
#' @param parameter_name name of the parameter type to retrieve, ensuring the name matches that in data
#' @return dataframe with all parameter estimates and specified columns
#' @examples
#' df <- load_epidata(pathogen = "ebola")
#' get_generic(data = df$params, parameter_name = "Human delay - serial interval")
#' @examples
#' df <- load_epidata(pathogen = "marburg")
#' get_generic(data = df$params, parameter_name = "Attack rate")
get_generic <- function(data, parameter_name) {
  if(length(data[which(data$parameter_type == parameter_name),]) == 0) {
    stop("data should be the parameter dataframe outputted from load_epidata()")
  } else {
    index <- which(data$parameter_type == parameter_name)
    pathogen <- unique(data$pathogen)
    if(pathogen == "Ebola virus") {
      name_vec <- c("pathogen","parameter_type",
                    "ebola_variant","ebola_species",
                    "first_author_surname","year_publication",
                    "parameter_value","parameter_unit",
                    "parameter_lower_bound","parameter_upper_bound",
                    "parameter_value_type","parameter_uncertainty_single_value",
                    "parameter_uncertainty_singe_type","parameter_uncertainty_lower_value",
                    "parameter_uncertainty_upper_value","parameter_uncertainty_type",
                    "distribution_type","distribution_par1_value",
                    "distribution_par1_type","distribution_par1_uncertainty",
                    "distribution_par2_value","distribution_par2_type",
                    "distribution_par2_uncertainty","method_from_supplement",
                    "method_disaggregated_by","method_disaggregated",
                    "method_disaggregated_only","population_sex",
                    "population_sample_type","population_group",
                    "population_age_min","population_age_max",
                    "population_sample_size","population_country",
                    "population_location","population_study_start_day",
                    "population_study_start_month","population_study_start_year",
                    "population_study_end_day","population_study_end_month",
                    "population_study_end_year","outbreak")
    } else {
      name_vec <- c("pathogen","parameter_type",
                    "first_author_surname","year_publication",
                    "parameter_value","parameter_unit",
                    "parameter_lower_bound","parameter_upper_bound",
                    "parameter_value_type","parameter_uncertainty_single_value",
                    "parameter_uncertainty_singe_type","parameter_uncertainty_lower_value",
                    "parameter_uncertainty_upper_value","parameter_uncertainty_type",
                    "distribution_type","distribution_par1_value",
                    "distribution_par1_type","distribution_par1_uncertainty",
                    "distribution_par2_value","distribution_par2_type",
                    "distribution_par2_uncertainty","method_from_supplement",
                    "method_disaggregated_by","method_disaggregated",
                    "method_disaggregated_only","population_sex",
                    "population_sample_type","population_group",
                    "population_age_min","population_age_max",
                    "population_sample_size","population_country",
                    "population_location","population_study_start_day",
                    "population_study_start_month","population_study_start_year",
                    "population_study_end_day","population_study_end_month",
                    "population_study_end_year")
    }
    name_index <- which(names(data) %in% name_vec)
    get_param <- data[index,name_index]
  }

  if(nrow(get_param) == 0) {
    stop("There are no available estimates for this parameter")
  }

  return(get_param)
}
