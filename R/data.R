#' Data on the models identified in the systematic review of articles related
#' to Marburg virus disease.
#'
#' @description
#' This data set provides all extracted data for mathematical models applied to
#' Marburg virus disease (MVD).
#'
#' @name marburg_model.csv
#' @docType data
#' @format A csv file containing the following parameters:
#'
#' - model_data_id = ID variable for the model.
#' - article_id = ID variable for the article the model came from.
#' - model_type = whether the model was compartmental, branching process,
#' agent/individual based, other, or unspecified.
#' - compartmental_type = if the model is compartmental, whether the model is
#' SIS, SIR, SEIR, or "other".
#' - stoch_deter = whether the article specified whether the model was
#' stochastic, deterministic, or both.
#' - theoretical_model = "TRUE" or "FALSE". "TRUE" if the model is not fit to
#' data.
#' - interventions_type = interventions modelled e.g. vaccination, quarantine,
#' vector control, treatment, contact tracing, hospitals, treatment centres,
#' safe burials, behaviour changes, other, or unspecified.
#' - code_available = whether the code was made available in the article.
#' - transmission_route = which transmission route was modelled, e.g. airborne
#' or close contact, human to human, vector to human, animal to human, sexual,
#' or unspecified.
#' - assumptions = assumptions used in the model e.g. homogenous mixing, latent
#' period is the same as incubation period, heterogeneity in transmission rates
#' between groups or over time, age dependent susceptibility, or unspecified.
#' - covidence_id = article identifier used by the Imperial team.
#'
#' @source Cuomo-Dannenburg G, McCain K, McCabe R, Unwin HJT, Doohan P, Nash RK,
#' et al. Marburg Virus Disease outbreaks, mathematical models, and disease
#' parameters: a Systematic Review [Internet]. medRxiv; 2023 [cited 2023 Jul 13].
#' p. 2023.07.10.23292424.
#' Available from: https://www.medrxiv.org/content/10.1101/2023.07.10.23292424v1
#'
NULL

#' Data on the outbreaks identified in the systematic review of articles
#' related to Marburg virus disease.
#'
#' @description
#' This data set provides all extracted data for outbreaks of Marburg virus
#' disease (MVD).
#'
#' @name marburg_outbreak.csv
#' @docType data
#' @format A csv file containing the following parameters:
#'
#' - outbreak_id = ID variable for the outbreak.
#' - article_id = ID variable for the article the outbreak data came from.
#' - outbreak_start_day = Day that the outbreak started (numeric - DD).
#' - outbreak_start_month = Month that the outbreak started (three letter
#' abbreviation e.g. "Aug").
#' - outbreak_start_year = Year that the outbreak started (numeric - YYYY).
#' - outbreak_end_day = Day that the outbreak ended (numeric - DD).
#' - outbreak_end_month = Month that the outbreak ended (three letter
#' abbreviation e.g. "Aug").
#' - outbreak_date_year = Year that the outbreak ended (numeric - YYYY).
#' - outbreak_duration_months = Outbreak duration in months.
#' - outbreak_size = total outbreak size.
#' - asymptomatic_transmission = whether asymptomatic transmission occurred,
#' either TRUE or FALSE.
#' - outbreak_country = country in which the outbreak occurred.
#' - outbreak_location = location that the outbreak occurred.
#' - cases_confirmed = total number of confirmed cases.
#' - cases_mode_detection = either diagnosed based on symptoms alone
#' ("Symptoms"), confirmed via a laboratory test such as PCR ("Molecular
#' (PCR etc)"), "Not specified", or NA.
#' - cases_suspected = total number of suspected cases.
#' - cases_asymptomatic = total number of asymptomatic cases.
#' - deaths = total number of deaths.
#' - cases_severe_hospitalised = total number of severe hospitalised cases.
#' - covidence_id = article identifier used by the Imperial team.
#'
#' @source Cuomo-Dannenburg G, McCain K, McCabe R, Unwin HJT, Doohan P, Nash RK,
#' et al. Marburg Virus Disease outbreaks, mathematical models, and disease
#' parameters: a Systematic Review [Internet]. medRxiv; 2023 [cited 2023 Jul 13].
#' p. 2023.07.10.23292424.
#' Available from: https://www.medrxiv.org/content/10.1101/2023.07.10.23292424v1
#'
NULL

#' Data on the parameters identified in the systematic review of articles
#' related to Marburg virus disease.
#'
#' @description
#' This data set provides all extracted parameters for Marburg virus disease
#' (MVD).
#'
#' @name marburg_parameter.csv
#' @docType data
#' @format A csv file containing the following parameters:
#'
#' - parameter_data_id
#' - article_id
#' - parameter_type
#' - parameter_value
#' - parameter_unit
#' - parameter_lower_bound
#' - parameter_upper_bound
#' - parameter_value_type
#' - parameter_uncertainty_single_value
#' - parameter_uncertainty_singe_type
#' - parameter_uncertainty_lower_value
#' - parameter_uncertainty_upper_value
#' - parameter_uncertainty_type
#' - cfr_ifr_numerator
#' - cfr_ifr_denominator
#' - distribution_type
#' - distribution_par1_value
#' - distribution_par1_type
#' - distribution_par1_uncertainty
#' - distribution_par2_value
#' - distribution_par2_type
#' - distribution_par2_uncertainty
#' - method_from_supplement
#' - method_moment_value
#' - cfr_ifr_method
#' - method_r
#' - method_disaggregated_by
#' - method_disaggregated
#' - method_disaggregated_only
#' - riskfactor_outcome
#' - riskfactor_name
#' - riskfactor_occupation
#' - riskfactor_significant
#' - riskfactor_adjusted
#' - population_sex
#' - population_sample_type
#' - population_group
#' - population_age_min
#' - population_age_max
#' - population_sample_size
#' - population_country
#' - population_location
#' - population_study_start_day
#' - population_study_start_month
#' - population_study_start_year
#' - population_study_end_day
#' - population_study_end_month
#' - population_study_end_year
#' - genome_site
#' - genomic_sequence_available
#' - parameter_class
#' - covidence_id
#' - Uncertainty
#' - Survey year
#'
#' @source Cuomo-Dannenburg G, McCain K, McCabe R, Unwin HJT, Doohan P, Nash RK,
#' et al. Marburg Virus Disease outbreaks, mathematical models, and disease
#' parameters: a Systematic Review [Internet]. medRxiv; 2023 [cited 2023 Jul 13].
#' p. 2023.07.10.23292424.
#' Available from: https://www.medrxiv.org/content/10.1101/2023.07.10.23292424v1
#'
NULL
