#' Create new parameter entry
#'
#' @param pathogen name of pathogen
#' @param new_param all the required details for the new parameter entry
#' @param vignette_prepend string to allow loading data in vignettes
#' @return new row of data to be added to the outbreak data set using the
#' append_new_entry_to_table() function
#' @importFrom tibble as_tibble as_tibble_row
#' @importFrom validate validator confront summary
#' @importFrom dplyr select
#' @importFrom readr read_csv
#' @examples
#' create_new_parameter_entry <-
#'   function(pathogen = "marburg",
#'            new_param = c(list("article_id"            = as.integer(1)),
#'                          list("parameter_type"        = as.character(NA)),
#'                          list("parameter_value"       = as.double(NA)),
#'                          list("parameter_unit"        = as.character(NA)),
#'                          list("parameter_lower_bound" = as.double(NA)),
#'                          list("parameter_upper_bound" = as.double(NA)),
#'                          list("population_study_start_day"   = as.integer(NA)),
#'                          list("population_study_start_month" = as.character(NA)),
#'                          list("population_study_start_year"  = as.integer(NA)),
#'                          list("population_study_end_day"     = as.integer(NA)),
#'                          list("population_study_end_month"   = as.character(NA)),
#'                          list("population_study_end_year"    = as.integer(NA)),
#'                          list("genome_site"                  = as.character(NA)),
#'                          list("genomic_sequence_available"   = as.logical(NA)),
#'                          list("parameter_class"          = as.character(NA)),
#'                          list("covidence_id"             = as.integer(2059)),
#'                          list("Uncertainty"              = as.character(NA)),
#'                          list("Survey year"              = as.character(NA))),
#'            vignette_prepend = "")
#' @export
create_new_parameter_entry <-
  function(pathogen = NA,
           new_param = c(list("article_id"            = as.integer(NA)),
                         list("parameter_type"        = as.character(NA)),
                         list("parameter_value"       = as.double(NA)),
                         list("parameter_unit"        = as.character(NA)),
                         list("parameter_lower_bound" = as.double(NA)),
                         list("parameter_upper_bound" = as.double(NA)),
                         list("parameter_value_type"  = as.character(NA)),
                         list("parameter_uncertainty_single_value" = as.double(NA)),
                         list("parameter_uncertainty_singe_type"   = as.character(NA)),
                         list("parameter_uncertainty_lower_value"  = as.double(NA)),
                         list("parameter_uncertainty_upper_value"  = as.double(NA)),
                         list("parameter_uncertainty_type"         = as.character(NA)),
                         list("cfr_ifr_numerator"       = as.integer(NA)),
                         list("cfr_ifr_denominator"     = as.integer(NA)),
                         list("distribution_type"       = as.character(NA)),
                         list("distribution_par1_value" = as.double(NA)),
                         list("distribution_par1_type"  = as.character(NA)),
                         list("distribution_par1_uncertainty" = as.logical(NA)),
                         list("distribution_par2_value" = as.double(NA)),
                         list("distribution_par2_type"  = as.character(NA)),
                         list("distribution_par2_uncertainty" = as.logical(NA)),
                         list("method_from_supplement"  = as.logical(NA)),
                         list("method_moment_value"     = as.character(NA)),
                         list("cfr_ifr_method"          = as.character(NA)),
                         list("method_r"                = as.character(NA)),
                         list("method_disaggregated_by" = as.character(NA)),
                         list("method_disaggregated"    = as.logical(NA)),
                         list("method_disaggregated_only" = as.logical(NA)),
                         list("riskfactor_outcome"      = as.character(NA)),
                         list("riskfactor_name"         = as.character(NA)),
                         list("riskfactor_occupation"   = as.character(NA)),
                         list("riskfactor_significant"  = as.character(NA)),
                         list("riskfactor_adjusted"     = as.character(NA)),
                         list("population_sex"          = as.character(NA)),
                         list("population_sample_type"  = as.character(NA)),
                         list("population_group"        = as.character(NA)),
                         list("population_age_min"      = as.integer(NA)),
                         list("population_age_max"      = as.integer(NA)),
                         list("population_sample_size"  = as.integer(NA)),
                         list("population_country"      = as.character(NA)),
                         list("population_location"     = as.character(NA)),
                         list("population_study_start_day"   = as.integer(NA)),
                         list("population_study_start_month" = as.character(NA)),
                         list("population_study_start_year"  = as.integer(NA)),
                         list("population_study_end_day"     = as.integer(NA)),
                         list("population_study_end_month"   = as.character(NA)),
                         list("population_study_end_year"    = as.integer(NA)),
                         list("genome_site"                  = as.character(NA)),
                         list("genomic_sequence_available"   = as.logical(NA)),
                         list("parameter_class"          = as.character(NA)),
                         list("covidence_id"             = as.integer(NA)),
                         list("Uncertainty"              = as.character(NA)),
                         list("Survey year"              = as.character(NA))),
           vignette_prepend = "") {

  #read current article data for pathogen
  articles <- as_tibble(load_epidata(table_type = "article",
                                     pathogen = pathogen,
                                     vignette_prepend = vignette_prepend))
  old_parameters <- as_tibble(load_epidata(table_type = "parameter",
                                           pathogen = pathogen,
                                           vignette_prepend = vignette_prepend))
  new_row <- as_tibble_row(new_param)

  # generate the below quanties.
  new_row$parameter_data_id <- max(old_parameters$parameter_data_id) + 1
  new_row <- new_row %>% select(colnames(old_parameters))

  # Need to check that article_id & covidence_id exist in the articles table.
  if (!(new_row$article_id %in% articles$article_id &
       articles[articles$article_id == new_row$article_id, ]$covidence_id ==
       new_row$covidence_id))
    stop("Article_id + Covidence_id pair does not exist in article data")

  #available options for fields
  file_path_ob  <- system.file("data", "access_db_dropdown_parameters.csv",
                               package = "epireview")
  if (file_path_ob=="") {
    file_path_ob <- paste0(vignette_prepend,
                           "data/access_db_dropdown_parameters.csv")
  }
  parameter_options <- read_csv(file_path_ob)

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

  return(new_row)
}
