#' Create new parameter entry
#'
#' @param pathogen name of pathogen
#' @param new_param all the required details for the new parameter entry
#' @param vignette_prepend string to allow loading data in vignettes
#' @return new row of data to be added to the outbreak data set using the
#' append_new_entry_to_table() function
#' @importFrom tibble as_tibble as_tibble_row
#' @importFrom validate validator confront summary %vin%
#' @importFrom dplyr select
#' @importFrom readr read_csv
#' @importFrom stats na.omit
#' @examples
#' create_new_parameter_entry <-
#'   function(pathogen = "marburg",
#'            new_param =
#'              c("article_id"            = as.integer(NA),
#'                "parameter_type"        = as.character(NA),
#'                "parameter_value"       = as.double(NA),
#'                "parameter_unit"        = as.character(NA),
#'                "parameter_lower_bound" = as.double(NA),
#'                "parameter_upper_bound" = as.double(NA),
#'                "parameter_value_type"  = as.character(NA),
#'                "parameter_uncertainty_single_value" = as.double(NA),
#'                "parameter_uncertainty_singe_type"   = as.character(NA),
#'                "parameter_uncertainty_lower_value"  = as.double(NA),
#'                "parameter_uncertainty_upper_value"  = as.double(NA),
#'                "parameter_uncertainty_type"         = as.character(NA),
#'                "cfr_ifr_numerator"       = as.integer(NA),
#'                "cfr_ifr_denominator"     = as.integer(NA),
#'                "distribution_type"       = as.character(NA),
#'                "distribution_par1_value" = as.double(NA),
#'                "distribution_par1_type"  = as.character(NA),
#'                "distribution_par1_uncertainty" = as.logical(NA),
#'                "distribution_par2_value" = as.double(NA),
#'                "distribution_par2_type"  = as.character(NA),
#'                "distribution_par2_uncertainty" = as.logical(NA),
#'                "method_from_supplement"  = as.logical(NA),
#'                "method_moment_value"     = as.character(NA),
#'                "cfr_ifr_method"          = as.character(NA),
#'                "method_r"                = as.character(NA),
#'                "method_disaggregated_by" = as.character(NA),
#'                "method_disaggregated"    = as.logical(NA),
#'                "method_disaggregated_only" = as.logical(NA),
#'                "riskfactor_outcome"      = as.character(NA),
#'                "riskfactor_name"         = as.character(NA),
#'                "riskfactor_occupation"   = as.character(NA),
#'                "riskfactor_significant"  = as.character(NA),
#'                "riskfactor_adjusted"     = as.character(NA),
#'                "population_sex"          = as.character(NA),
#'                "population_sample_type"  = as.character(NA),
#'                "population_group"        = as.character(NA),
#'                "population_age_min"      = as.integer(NA),
#'                "population_age_max"      = as.integer(NA),
#'                "population_sample_size"  = as.integer(NA),
#'                "population_country"      = as.character(NA),
#'                "population_location"     = as.character(NA),
#'                "population_study_start_day"   = as.integer(NA),
#'                "population_study_start_month" = as.character(NA),
#'                "population_study_start_year"  = as.integer(NA),
#'                "population_study_end_day"     = as.integer(NA),
#'                "population_study_end_month"   = as.character(NA),
#'                "population_study_end_year"    = as.integer(NA),
#'                "genome_site"                  = as.character(NA),
#'                "genomic_sequence_available"   = as.logical(NA),
#'                "parameter_class"          = as.character(NA),
#'                "covidence_id"             = as.integer(NA))
#'            )
#' @export
create_new_parameter_entry <-
  function(pathogen = NA,
           new_param = list(
             article_id            = as.integer(NA),
             parameter_type        = as.character(NA),
             parameter_value       = as.double(NA),
             parameter_unit        = as.character(NA),
             parameter_lower_bound = as.double(NA),
             parameter_upper_bound = as.double(NA),
             parameter_value_type  = as.character(NA),
             parameter_uncertainty_single_value = as.double(NA),
             parameter_uncertainty_singe_type   = as.character(NA),
             parameter_uncertainty_lower_value  = as.double(NA),
             parameter_uncertainty_upper_value  = as.double(NA),
             parameter_uncertainty_type         = as.character(NA),
             cfr_ifr_numerator       = as.integer(NA),
             cfr_ifr_denominator     = as.integer(NA),
             distribution_type       = as.character(NA),
             distribution_par1_value = as.double(NA),
             distribution_par1_type  = as.character(NA),
             distribution_par1_uncertainty = as.logical(NA),
             distribution_par2_value = as.double(NA),
             distribution_par2_type  = as.character(NA),
             distribution_par2_uncertainty = as.logical(NA),
             method_from_supplement  = as.logical(NA),
             method_moment_value     = as.character(NA),
             cfr_ifr_method          = as.character(NA),
             method_r                = as.character(NA),
             method_disaggregated_by = as.character(NA),
             method_disaggregated    = as.logical(NA),
             method_disaggregated_only = as.logical(NA),
             riskfactor_outcome      = as.character(NA),
             riskfactor_name         = as.character(NA),
             riskfactor_occupation   = as.character(NA),
             riskfactor_significant  = as.character(NA),
             riskfactor_adjusted     = as.character(NA),
             population_sex          = as.character(NA),
             population_sample_type  = as.character(NA),
             population_group        = as.character(NA),
             population_age_min      = as.integer(NA),
             population_age_max      = as.integer(NA),
             population_sample_size  = as.integer(NA),
             population_country      = as.character(NA),
             population_location     = as.character(NA),
             population_study_start_day   = as.integer(NA),
             population_study_start_month = as.character(NA),
             population_study_start_year  = as.integer(NA),
             population_study_end_day     = as.integer(NA),
             population_study_end_month   = as.character(NA),
             population_study_end_year    = as.integer(NA),
             genome_site                  = as.character(NA),
             genomic_sequence_available   = as.logical(NA),
             parameter_class          = as.character(NA),
             covidence_id             = as.integer(NA))
           ) {

  #read current article data for pathogen
  articles <- as_tibble(load_epidata_raw(pathogen = pathogen, "article"))
  old_parameters <- as_tibble(load_epidata_raw(pathogen = pathogen, "parameter"))
  new_row <- as_tibble_row(new_param)

  # generate the below quanties.
  new_row$parameter_data_id <- max(old_parameters$parameter_data_id) + 1
  new_row <- new_row[ , colnames(old_parameters)]

  # Need to check that article_id & covidence_id exist in the articles table.
  if (!(new_row$article_id %in% articles$article_id &&
        articles[articles$article_id == new_row$article_id, ]$covidence_id ==
        new_row$covidence_id))
    stop("Article_id + Covidence_id pair does not exist in article data")


  #available options for fields
  file_path_ob  <- system.file("extdata",
                               paste0(pathogen, "_dropdown_parameters.csv"),
                               package = "epireview")

  parameter_options <- read_csv(file_path_ob, show_col_types = FALSE)

  # Deal with R CMD Check "no visible binding for global variable"
  population_country <- fails <- NULL

  #validate that the entries make sense
  rules <- validator(
    model_type_is_character = is.character(population_country),
    model_types_valid = strsplit(population_country, ",")[[1]] %vin%
      na.omit(parameter_options$`Population Country`)
  )

  rules_output  <- confront(new_row, rules)
  rules_summary <- summary(rules_output)

  print(as_tibble(rules_summary) %>% filter(fails > 0))

  if (sum(rules_summary$fails) > 0)
    stop(as_tibble(rules_summary) %>% filter(fails > 0))

  ## Check for columns in old data that are not in new data
  ## and add them to new data with NA values with the same class
  ## as the corresponding column in the old data.
  for (col in colnames(old_parameters)) {
    if (!(col %in% colnames(new_row))) {
      new_row[[col]] <- as(NA, class(old_parameters[[col]]))
    }
  }
  ## Make sure the columns are in the same order as the old data
  new_row[ , colnames(old_parameters)]
}
