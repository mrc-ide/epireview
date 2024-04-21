

#' Function to curate raw data from epireview
#'
#' @param articles       dataframe of articles (based on csv in epireview)
#' @param outbreaks      dataframe of outbreaks (based on csv in epireview), can be empty / tibble()
#' @param models         dataframe of models (based on csv in epireview)
#' @param parameters     dataframe of parameters (based on csv in epireview)
#' @param plotting       If the outputs are going to be used in plotting function or display functions (such as Latex tables)
#'
#' @return  a list of dataframes of curated data for articles, outbreaks (may be empty), models and parameters
#' @export
#'
#' @importFrom dplyr rename functionality
#'
#' @examples    to be added!
data_curation <- function(articles, outbreaks, models, parameters, plotting) {

  articles   <- articles %>%
    mutate(refs = paste(first_author_first_name," (",year_publication,")",sep="")) %>% #define references
    group_by(refs) %>% mutate(counter = row_number()) %>% ungroup() %>% #distinguish same-author-same-year references
    mutate(new_refs = ifelse(refs %in% refs[duplicated(refs)], paste0(sub("\\)$", "", refs),letters[counter],")"), refs)) %>%
    select(-counter,-refs) %>% dplyr::rename(refs = new_refs)

  if(dim(outbreaks)[1]>0)
  {
    outbreaks  <- outbreaks %>%
      mutate(refs = articles$refs[match(covidence_id, articles$covidence_id)])
  }

  models     <- models %>%
    mutate(refs = articles$refs[match(covidence_id, articles$covidence_id)])

  parameters <- parameters %>%
    mutate(refs = articles$refs[match(covidence_id, articles$covidence_id)]) %>%
    filter(!parameter_from_figure)

  param4plot <- parameters %>%
    dplyr::mutate_at(vars(parameter_value, parameter_lower_bound, parameter_upper_bound,
                          parameter_uncertainty_lower_value, parameter_uncertainty_upper_value),
                     list(~ ifelse(inverse_param, 1/.x, .x))) %>%
    dplyr::mutate_at(vars(parameter_value, parameter_lower_bound, parameter_upper_bound,
                          parameter_uncertainty_lower_value, parameter_uncertainty_upper_value),
                     list(~ .x * 10^exponent)) %>%
    dplyr::mutate_at(vars(parameter_value,parameter_lower_bound,parameter_upper_bound,
                          parameter_uncertainty_lower_value,parameter_uncertainty_upper_value), #account for different units
                     list(~ ifelse(parameter_unit %in% "Weeks", . * 7, .))) %>%
    mutate(parameter_unit = ifelse(parameter_unit %in% "Weeks", "Days", parameter_unit)) %>%
    mutate(no_unc = is.na(parameter_uncertainty_lower_value) & is.na(parameter_uncertainty_upper_value), #store uncertainty in pu_lower and pu_upper
           parameter_uncertainty_lower_value = case_when(
             parameter_uncertainty_singe_type == "Maximum" & no_unc ~ parameter_value,
             parameter_uncertainty_singe_type == "Standard deviation (Sd)" & no_unc ~ parameter_value-parameter_uncertainty_single_value,
             parameter_uncertainty_singe_type == "Standard Error (SE)" & no_unc ~ parameter_value-parameter_uncertainty_single_value,
             distribution_type == "Gamma" & no_unc ~ qgamma(0.05, shape = (distribution_par1_value/distribution_par2_value)^2, rate = distribution_par1_value/distribution_par2_value^2),
             TRUE ~ parameter_uncertainty_lower_value),
           parameter_uncertainty_upper_value = case_when(
             parameter_uncertainty_singe_type == "Maximum" & no_unc ~ parameter_uncertainty_single_value,
             parameter_uncertainty_singe_type == "Standard deviation (Sd)" & no_unc ~ parameter_value+parameter_uncertainty_single_value,
             parameter_uncertainty_singe_type == "Standard Error (SE)" & no_unc ~ parameter_value+parameter_uncertainty_single_value,
             distribution_type == "Gamma" & no_unc ~ qgamma(0.95, shape = (distribution_par1_value/distribution_par2_value)^2, rate = distribution_par1_value/distribution_par2_value^2),
             TRUE ~ parameter_uncertainty_upper_value)) %>%
    select(-c(no_unc)) %>%
    mutate(central = dplyr::coalesce(parameter_value,100*cfr_ifr_numerator/cfr_ifr_denominator,0.5*(parameter_lower_bound+parameter_upper_bound))) #central value for plotting

  if (plotting) {
    parameters <- param4plot
  } else {
    check_param_id <- (parameters$parameter_data_id == param4plot$parameter_data_id )    # check that parameter data ids didn't get scrambled
    if(sum(check_param_id)==dim(parameters)[1])
    {
      parameters$central <- param4plot$central
    } else {
      errorCondition('parameters not in right order to match')
    }
  }

  if(dim(outbreaks)[1]>0)
  {
    outbreaks  <- outbreaks  %>% mutate(outbreak_location  = str_replace_all(outbreak_location, "\xe9" , "é"))
  }

  parameters <- parameters %>% mutate(parameter_type     = str_replace_all(parameter_type, "\x96" , "–"),
                                      population_country = str_replace_all(population_country, c("昼㸴" = "ô", "�" = "ô")))

  return(list(articles = articles, outbreaks = outbreaks,
              models = models, parameters = parameters))
}
