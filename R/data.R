#' Data on the priority pathogens included in the systematic review
#' @description
#' This data set gives the list of WHO priority pathogens for which
#' the Pathogen Epidemiology Review Group (PERG) has carried out a
#' systematic review. The data set gives the name of the pathogen
#' as used in the package and associated information with the review.
#'
#' @title priority_pathogens
#'
#' @return data.frame with the following fields
#' - pathogen: name of the pathogen as used in the package
#' - articles_screened: number of titles and abstracts screened for inclusion
#' - articles_extracted: number of articles from which data were extracted
#' - doi: doi of the accompanying systematic review
#' @export
priority_pathogens <- function() {

  data.frame(
    pathogen = c("marburg", "ebola"),
    articles_screened = c(4460, 9563),
    articles_extracted = c(42, 520),
    doi = c("10.1101/2023.07.10.23292424v1", NA),
    articles_file = c(
      "marburg_article.csv",
      "ebola_articles.csv"
    ),
    params_file = c(
      "marburg_parameter.csv",
      "ebola_parameters.csv"
    ),
    models_file = c(
      "marburg_model.csv",
      "ebola_models.csv"
    ),
    outbreaks_file = c(
      "marburg_outbreak.csv",
      NA
    )
  )
}



#' Data on the articles identified and included in the systematic review of
#' articles related to Marburg virus disease.
#'
#' @description
#' This data set provides the details of all extracted articles included in
#' the systematic review for Marburg virus disease (MVD).
#'
#' @name marburg_article
#' @docType data
#' @format A csv file containing the following parameters:
#'
#' - "article_id" = ID variable for the article.
#' - "pathogen" = pathogen name.
#' - "covidence_id" = article identifier used by the Imperial team.
#' - "first_author_first_name" = first author first name or initials.
#' - "article_title" = title of article.
#' - "doi" = the doi of the article.
#' - "journal" = journal that the article is published in.
#' - "year_publication" = year of article publication.
#' - "volume" = journal volume.
#' - "issue" = journal issue.
#' - "page_first" = first page number.
#' - "page_last" = last page number.
#' - "paper_copy_only" = if the article is not available online.
#' - "notes" = notes the extractor has made.
#' - "first_author_surname" = surname of the first author.
#' - "double_extracted" = either single extracted (0) or double extracted (1).
#' - "qa_m1" = quality assessment: "Is the methodological/statistical approach
#'      suitable? Q1. Clear and reproducible?" (either 0, 1, or NA)
#' - "qa_m2" = quality assessment: "Is the methodological/statistical approach
#'      suitable? Q2. Robust and appropriate for the aim?" (either 0, 1, or NA)
#' - "qa_a3" = quality assessment: "Are the assumptions appropriate? Q3. Clear
#'      and reproducible?" (either 0, 1, or NA)
#' - "qa_a4" = quality assessment: "Are the assumptions appropriate? Q4.
#'      Justified?" (either 0, 1, or NA)
#' - "qa_d5" = quality assessment: "Are the data appropriate for the selected
#'      methodological approach? Q5. Clearly described and reproducible?"
#'      (either 0, 1, or NA)
#' - "qa_d6" = quality assessment: "Are issues in data... Q6. Clearly discussed
#'      and acknowledged?" (either 0, 1, or NA)
#' - "qa_d7" = quality assessment: "Are issues in data... Q7. Accounted for in
#'      chosen methodological approach?" (either 0, 1, or NA)
#' - "score" = overall quality assessment score.
#'
#' @source Cuomo-Dannenburg G, McCain K, McCabe R, Unwin HJT, Doohan P, Nash RK,
#' et al. Marburg Virus Disease outbreaks, mathematical models, and disease
#' parameters: a Systematic Review. medRxiv; 2023. 2023.07.10.23292424.
#' Available from: https://www.medrxiv.org/content/10.1101/2023.07.10.23292424v1
#'
NULL

#' Data on the models identified in the systematic review of articles related
#' to Marburg virus disease.
#'
#' @description
#' This data set provides all extracted data for mathematical models applied to
#' Marburg virus disease (MVD).
#'
#' @name marburg_model
#' @docType data
#' @format A csv file containing the following parameters:
#'
#' - model_data_id = ID variable for the model.
#' - article_id = ID variable for the article the model came from.
#' - model_type = whether the model was compartmental, branching process,
#'      agent/individual based, other, or unspecified.
#' - compartmental_type = if the model is compartmental, whether the model is
#'      SIS, SIR, SEIR, or "other".
#' - stoch_deter = whether the article specified whether the model was
#'      stochastic, deterministic, or both.
#' - theoretical_model = "TRUE" or "FALSE". "TRUE" if the model is not fit to
#'      data.
#' - interventions_type = interventions modelled e.g. vaccination, quarantine,
#'      vector control, treatment, contact tracing, hospitals, treatment
#'      centres, safe burials, behaviour changes, other, or unspecified.
#' - code_available = whether the code was made available in the article.
#' - transmission_route = which transmission route was modelled, e.g. airborne
#'      or close contact, human to human, vector to human, animal to human,
#'      sexual, or unspecified.
#' - assumptions = assumptions used in the model e.g. homogenous mixing, latent
#'      period is the same as incubation period, heterogeneity in transmission
#'      rates between groups or over time, age dependent susceptibility, or
#'      unspecified.
#' - covidence_id = article identifier used by the Imperial team.
#'
#' @source Cuomo-Dannenburg G, McCain K, McCabe R, Unwin HJT, Doohan P, Nash RK,
#' et al. Marburg Virus Disease outbreaks, mathematical models, and disease
#' parameters: a Systematic Review. medRxiv; 2023. 2023.07.10.23292424.
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
#' @name marburg_outbreak
#' @docType data
#' @format A csv file containing the following parameters:
#'
#' - outbreak_id = ID variable for the outbreak.
#' - article_id = ID variable for the article the outbreak data came from.
#' - outbreak_start_day = Day that the outbreak started (numeric - DD).
#' - outbreak_start_month = Month that the outbreak started (three letter
#'      abbreviation e.g. "Aug").
#' - outbreak_start_year = Year that the outbreak started (numeric - YYYY).
#' - outbreak_end_day = Day that the outbreak ended (numeric - DD).
#' - outbreak_end_month = Month that the outbreak ended (three letter
#'      abbreviation e.g. "Aug").
#' - outbreak_date_year = Year that the outbreak ended (numeric - YYYY).
#' - outbreak_duration_months = Outbreak duration in months.
#' - outbreak_size = total outbreak size.
#' - asymptomatic_transmission = whether asymptomatic transmission occurred,
#'      either TRUE or FALSE.
#' - outbreak_country = country in which the outbreak occurred.
#' - outbreak_location = location that the outbreak occurred.
#' - cases_confirmed = total number of confirmed cases.
#' - cases_mode_detection = either diagnosed based on symptoms alone
#'      ("Symptoms"), confirmed via a laboratory test such as PCR ("Molecular
#'      (PCR etc)"), "Not specified", or NA.
#' - cases_suspected = total number of suspected cases.
#' - cases_asymptomatic = total number of asymptomatic cases.
#' - deaths = total number of deaths.
#' - cases_severe_hospitalised = total number of severe hospitalised cases.
#' - covidence_id = article identifier used by the Imperial team.
#'
#' @source Cuomo-Dannenburg G, McCain K, McCabe R, Unwin HJT, Doohan P, Nash RK,
#' et al. Marburg Virus Disease outbreaks, mathematical models, and disease
#' parameters: a Systematic Review. medRxiv; 2023. 2023.07.10.23292424.
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
#' @name marburg_parameter
#' @docType data
#' @format A csv file containing the following parameters:
#'
#' - parameter_data_id = ID variable for the parameter.
#' - article_id = ID variable for the article the outbreak data came from.
#' - parameter_type = extracted parameter (see marburg_dropdown_parameters
#'      for the full list of parameters extracted).
#' - parameter_value = extracted parameter value as stated in the article.
#' - parameter_unit = units of the extracted parameter (see
#'      marburg_dropdown_parameters for the full list of parameter units).
#' - parameter_lower_bound = minimum value of the parameter across any
#'      dimension of disaggregation.
#' - parameter_upper_bound = maximum value of the parameter across any
#'      dimension of disaggregation.
#' - parameter_value_type = whether the parameter value is the mean, median,
#'      standard deviation.
#' - parameter_uncertainty_single_value = extracted uncertainty if only a
#'      single value provided.
#' - parameter_uncertainty_single_type = uncertainty type if only a single
#'      value is reported e.g. "Standard Error (SE)" (see
#'      marburg_dropdown_parameters for the full list of options).
#' - parameter_uncertainty_lower_value = lower value of paired uncertainty.
#' - parameter_uncertainty_upper_value = upper value of paired uncertainty.
#' - parameter_uncertainty_type = uncertainty type if a pair of values are
#'      provided, e.g. "CI90%", "CRI95%" (see marburg_dropdown_parameters
#'      for the full list of options).
#' - cfr_ifr_numerator = numerator of the cfr or ifr provided in the article.
#' - cfr_ifr_denominator = denominator of the cfr or ifr provided in the
#'      article.
#' - distribution_type = if uncertainty is given as a distribution (see
#'      marburg_dropdown_parameters for the full list of options).
#' - distribution_par1_value = value for distribution parameter 1.
#' - distribution_par1_type = distribution parameter 1 type, e.g. shape, scale
#'      (see marburg_dropdown_parameters for the full list of options).
#' - distribution_par1_uncertainty = whether the article reported uncertainty
#'      for the distribution parameter estimates (TRUE/FALSE).
#' - distribution_par2_value = value for distribution parameter 2.
#' - distribution_par2_type = distribution parameter 2 type, e.g. shape, scale
#'      (see marburg_dropdown_parameters for the full list of options).
#' - distribution_par2_uncertainty = whether the article reported uncertainty
#'      for the distribution parameter estimates (TRUE/FALSE).
#' - method_from_supplement = whether the parameter was taken from the
#'      supplementary material of the article. TRUE/FALSE.
#' - method_moment_value = time period, either "Pre outbreak", Start outbreak",
#'      "Mid outbreak", "Post Outbreak", or "Other", if specified in the article.
#' - cfr_ifr_method = whether the method used to calculate the cfr/ifr was
#'      "Naive", "Adjusted", "Unknown".
#' - method_r = method used to estimate the reproduction number (see
#'      marburg_dropdown_parameters for the full list of options).
#' - method_disaggregated_by = how the parameter is disaggregated e.g. by Age,
#'      Sex, Region.
#' - method_disaggregated = whether the parameter is disaggregated (TRUE/FALSE).
#' - method_disaggregated_only = whether only disaggregated data is available
#'      (TRUE/FALSE).
#' - riskfactor_outcome = the outcome(s) for which the risk factor was
#'      evaluated e.g. "Death" or "Infection" (see marburg_dropdown_parameters
#'      for the full list of options).
#' - riskfactor_name = the potential risk factor(s) evaluated e.g. "Age" (see
#'      marburg_dropdown_parameters for the full list of options).
#' - riskfactor_occupation = specific occupation(s) if occupation is a risk
#'      factor (see marburg_dropdown_parameters for the full list of options).
#' - riskfactor_significant = either "Significant", "Not significant",
#'      "Unspecified" or NA.
#' - riskfactor_adjusted = either "Adjusted", "Not adjusted", "Unspecified".
#' - population_sex = the sex of the study population, either "Female", "Male",
#'      "Both", "Unspecified".
#' - population_sample_type = how the study was conducted e.g. "Hospital based",
#'      "Population based" (see 'Setting' in marburg_dropdown_parameters for the
#'      full list of options).
#' - population_group = population group e.g. "Healthcare workers" (see
#'      marburg_dropdown_parameters for the full list of options).
#' - population_age_min = minimum age in sample (if reported).
#' - population_age_max = maximum age in the sample (if reported).
#' - population_sample_size = total number of participants/samples tested.
#' - population_country = country/countries that the study took place in.
#' - population_location = location that the study took place e.g. region, city.
#' - population_study_start_day = day study started (numeric - DD)
#' - population_study_start_month = month study started (three letter
#'      abbreviation e.g. "Feb")
#' - population_study_start_year = year study started (numeric - YYYY)
#' - population_study_end_day = day study ended (numeric - DD)
#' - population_study_end_month = month study ended (three letter abbreviation
#'      e.g. "Feb")
#' - population_study_end_year = year study ended (numeric - YYYY)
#' - genome_site = the portion of the pathogen’s genome used to estimate any
#'      extracted parameters. I.e. the gene, gene segment, codon position, or a
#'      more generic description (‘whole genome’ or ‘intergenic positions’).
#' - genomic_sequence_available = whether the study sequenced new pathogen
#'      isolates and their accession numbers have been provided for retrieval
#'      from a public database. TRUE/FALSE.
#' - parameter_class = class of the extracted parameter. Either "Human delay",
#'      "Seroprevalence", "Severity", "Reproduction number", "Mutations",
#'      "Risk factors", or "Other transmission parameters".
#' - covidence_id = article identifier used by the Imperial team.
#'
#' @source Cuomo-Dannenburg G, McCain K, McCabe R, Unwin HJT, Doohan P, Nash RK,
#' et al. Marburg Virus Disease outbreaks, mathematical models, and disease
#' parameters: a Systematic Review. medRxiv; 2023. 2023.07.10.23292424.
#' Available from: https://www.medrxiv.org/content/10.1101/2023.07.10.23292424v1
#'
NULL

#' Dropdown menu options for model extractions in the systematic review of
#' articles related to Marburg virus disease (MVD).
#'
#' @description
#' This data set provides all the dropdown menu options extractors had when
#' extracting data for mathematical models applied to MVD.
#'
#' @name marburg_dropdown_models
#' @docType data
#' @format A csv file containing the dropdown options for:
#'
#' - Model type
#' - Stochastic or deterministic
#' - Transmission route
#' - Compartment type
#' - Assumptions
#' - Interventions
#'
#' @source Cuomo-Dannenburg G, McCain K, McCabe R, Unwin HJT, Doohan P, Nash RK,
#' et al. Marburg Virus Disease outbreaks, mathematical models, and disease
#' parameters: a Systematic Review. medRxiv; 2023. 2023.07.10.23292424.
#' Available from: https://www.medrxiv.org/content/10.1101/2023.07.10.23292424v1
#'
NULL

#' Dropdown menu options for outbreak extractions in the systematic review of
#' articles related to Marburg virus disease (MVD).
#'
#' @description
#' This data set provides all the dropdown menu options extractors had when
#' extracting outbreak data for MVD.
#'
#' @name marburg_dropdown_outbreaks
#' @docType data
#' @format A csv file containing the dropdown options for:
#'
#' - Outbreak country
#' - Detection mode
#'
#' @source Cuomo-Dannenburg G, McCain K, McCabe R, Unwin HJT, Doohan P, Nash RK,
#' et al. Marburg Virus Disease outbreaks, mathematical models, and disease
#' parameters: a Systematic Review. medRxiv; 2023. 2023.07.10.23292424.
#' Available from: https://www.medrxiv.org/content/10.1101/2023.07.10.23292424v1
#'
NULL

#' Dropdown menu options for parameter extractions in the systematic review of
#' articles related to Marburg virus disease (MVD).
#'
#' @description
#' This data set provides all the dropdown menu options extractors had when
#' extracting parameter data for MVD.
#'
#' @name marburg_dropdown_parameters
#' @docType data
#' @format A csv file containing the dropdown options for:
#'
#' - Population Country
#' - Parameter type
#' - Units
#' - Parameter uncertainty - single type
#' - Parameter uncertainty - paired type
#' - Distribution type
#' - Distribution parameter 1 - type
#' - Distribution parameter 2 - type
#' - Disaggregated by
#' - Sex
#' - Setting
#' - Group
#' - Timing
#' - Reproduction number method
#' - Time from
#' - Time to
#' - IFR_CFR_method
#' - Riskfactor outcome
#' - Riskfactor name
#' - Riskfactor occupation
#' - Riskfactor significant
#' - Riskfactor adjusted
#'
#' @source Cuomo-Dannenburg G, McCain K, McCabe R, Unwin HJT, Doohan P, Nash RK,
#' et al. Marburg Virus Disease outbreaks, mathematical models, and disease
#' parameters: a Systematic Review. medRxiv; 2023. 2023.07.10.23292424.
#' Available from: https://www.medrxiv.org/content/10.1101/2023.07.10.23292424v1
#'
NULL
