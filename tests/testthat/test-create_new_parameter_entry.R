old_parameters <- as_tibble(load_epidata_raw(pathogen = 'marburg', table = 'parameter'))
parameter_columns <- colnames(old_parameters)
dummy_param <- list("article_id"            = as.numeric(1),
                    "parameter_type"        = as.character(NA),
                    "parameter_value"       = as.double(NA),
                    "parameter_unit"        = as.character(NA),
                    "parameter_lower_bound" = as.double(NA),
                    "parameter_upper_bound" = as.double(NA),
                    "parameter_value_type"  = as.character(NA),
                    "parameter_uncertainty_single_value" = as.double(NA),
                    "parameter_uncertainty_singe_type"   = as.character(NA),
                    "parameter_uncertainty_lower_value"  = as.double(NA),
                    "parameter_uncertainty_upper_value"  = as.double(NA),
                    "parameter_uncertainty_type"         = as.character(NA),
                    "cfr_ifr_numerator"       = as.numeric(NA),
                    "cfr_ifr_denominator"     = as.numeric(NA),
                    "distribution_type"       = as.character(NA),
                    "distribution_par1_value" = as.double(NA),
                    "distribution_par1_type"  = as.character(NA),
                    "distribution_par1_uncertainty" = as.logical(NA),
                    "distribution_par2_value" = as.double(NA),
                    "distribution_par2_type"  = as.character(NA),
                    "distribution_par2_uncertainty" = as.logical(NA),
                    "method_from_supplement"  = as.logical(NA),
                    "method_moment_value"     = as.character(NA),
                    "cfr_ifr_method"          = as.character(NA),
                    "method_r"                = as.character(NA),
                    "method_disaggregated_by" = as.character(NA),
                    "method_disaggregated"    = as.logical(NA),
                    "method_disaggregated_only" = as.logical(NA),
                    "riskfactor_outcome"      = as.character(NA),
                    "riskfactor_name"         = as.character(NA),
                    "riskfactor_occupation"   = as.character(NA),
                    "riskfactor_significant"  = as.character(NA),
                    "riskfactor_adjusted"     = as.character(NA),
                    "population_sex"          = as.character(NA),
                    "population_sample_type"  = as.character(NA),
                    "population_group"        = as.character(NA),
                    "population_age_min"      = as.numeric(NA),
                    "population_age_max"      = as.numeric(NA),
                    "population_sample_size"  = as.numeric(NA),
                    "population_country"      = as.character(NA),
                    "population_location"     = as.character(NA),
                    "population_study_start_day"   = as.numeric(NA),
                    "population_study_start_month" = as.character(NA),
                    "population_study_start_year"  = as.numeric(NA),
                    "population_study_end_day"     = as.numeric(NA),
                    "population_study_end_month"   = as.character(NA),
                    "population_study_end_year"    = as.numeric(NA),
                    "genome_site"                  = as.character(NA),
                    "genomic_sequence_available"   = as.logical(NA),
                    "parameter_class"          = as.character(NA),
                    "covidence_id"             = as.numeric(2059))


test_that("new parameter entry matches old parameter structure", {
  expect_error(create_new_parameter_entry(pathogen='marburg'))

  dummy <- create_new_parameter_entry(pathogen = 'marburg', new_param = dummy_param)
  expect_named(dummy, parameter_columns)
  expect_s3_class(dummy, 'data.frame', exact = FALSE)
  expect_identical(
    object = sapply(dummy, class), 
    expected = sapply(old_parameters, class))

})
