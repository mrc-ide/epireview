old_parameters <- as_tibble(load_epidata(table_type = "parameter",
                                       pathogen = 'marburg',
                                       vignette_prepend = ""))
parameter_columns <- colnames(old_parameters)
dummy_param <- c(list("article_id"            = as.numeric(1)),
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
                 list("cfr_ifr_numerator"       = as.numeric(NA)),
                 list("cfr_ifr_denominator"     = as.numeric(NA)),
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
                 list("population_age_min"      = as.numeric(NA)),
                 list("population_age_max"      = as.numeric(NA)),
                 list("population_sample_size"  = as.numeric(NA)),
                 list("population_country"      = as.character(NA)),
                 list("population_location"     = as.character(NA)),
                 list("population_study_start_day"   = as.numeric(NA)),
                 list("population_study_start_month" = as.character(NA)),
                 list("population_study_start_year"  = as.numeric(NA)),
                 list("population_study_end_day"     = as.numeric(NA)),
                 list("population_study_end_month"   = as.character(NA)),
                 list("population_study_end_year"    = as.numeric(NA)),
                 list("genome_site"                  = as.character(NA)),
                 list("genomic_sequence_available"   = as.logical(NA)),
                 list("parameter_class"          = as.character(NA)),
                 list("covidence_id"             = as.numeric(2059)))


test_that("new parameter entry matches old parameter structure", {
  expect_error(create_new_parameter_entry(pathogen='marburg'))

  dummy <- create_new_parameter_entry(pathogen = 'marburg', new_param = dummy_param)
  expect_named(dummy,parameter_columns)
  expect_s3_class(dummy,'data.frame',exact = FALSE)
  expect_identical(sapply(dummy, class),sapply(old_parameters, class))

})
