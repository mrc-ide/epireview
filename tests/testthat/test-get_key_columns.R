suppressWarnings({
  lassa_data <- epireview::load_epidata("lassa")
  lassa_params <- lassa_data$params
  marburg_data <- epireview::load_epidata("marburg")
  marburg_params <- marburg_data$params
  ebola_data <- epireview::load_epidata("ebola")
  ebola_params <- ebola_data$params
})

test_that("get_key_columns works for lassa cfr", {
  df <- get_key_columns(data = lassa_params, parameter_name = "cfr")
  expect_s3_class(df, class = "data.frame")
  expect_identical(dim(df), c(440L, 12L))
  expect_identical(
    colnames(df),
    c("article_label", "article_info", "population_country",
      "population_sample_size",
      "population_sample_type", "population_group",
      "method_disaggregated", "parameter_type",
      "parameter_value", "cfr_ifr_numerator", "cfr_ifr_denominator",
      "cfr_ifr_method")
  )
})

test_that("get_key_columns works for lassa delays", {
  df <- get_key_columns(data = lassa_params, parameter_name = "delays")
  expect_s3_class(df, class = "data.frame")
  expect_identical(dim(df), c(440L, 15L))
  expect_identical(
    colnames(df),
    c("article_label", "article_info", "population_country","population_sample_size",
      "population_sample_type", "population_group",
      "method_disaggregated", "parameter_type",
      "parameter_value", "parameter_unit", "distribution_type",
      "distribution_par1_value", "distribution_par2_value", "other_delay_start",
      "other_delay_end")
  )
})

test_that("get_key_columns works for lassa sero", {
  df <- get_key_columns(data = lassa_params, parameter_name = "sero")
  expect_s3_class(df, class = "data.frame")
  expect_identical(dim(df), c(440L, 11L))
  expect_identical(
    colnames(df),
    c("article_label", "article_info", "population_country","population_sample_size",
      "population_sample_type", "population_group",
      "method_disaggregated", "parameter_type",
      "parameter_value", "cfr_ifr_numerator", "cfr_ifr_denominator")
  )
})

test_that("get_key_columns works for lassa risk", {
  df <- get_key_columns(data = lassa_params, parameter_name = "risk_factors")
  expect_s3_class(df, class = "data.frame")
  expect_identical(dim(df), c(440L, 12L))
  expect_identical(
    colnames(df),
    c("article_label", "article_info", "population_country","population_sample_size",
      "population_sample_type", "population_group",
      "method_disaggregated", "parameter_type",
      "riskfactor_outcome", "riskfactor_name", "riskfactor_significant",
      "riskfactor_adjusted")
  )
})

test_that("get_key_columns works for lassa reproduction_number", {
  df <- get_key_columns(
    data = lassa_params,
    parameter_name = "reproduction_number"
  )
  expect_s3_class(df, class = "data.frame")
  expect_identical(dim(df), c(440L, 11L))
  expect_identical(
    colnames(df),
    c("article_label", "article_info", "population_country","population_sample_size",
      "population_sample_type", "population_group",
      "method_disaggregated", "parameter_type",
      "parameter_value", "method_r", "parameter_unit")
  )
})

test_that("get_key_columns works for lassa genomic", {
  df <- get_key_columns(data = lassa_params,  parameter_name = "genomic")
  expect_s3_class(df, class = "data.frame")
  expect_identical(dim(df), c(440L, 13L))
  expect_identical(
    colnames(df),
    c("article_label", "article_info", "population_country","population_sample_size",
      "population_sample_type", "population_group",
      "method_disaggregated", "parameter_type",
      "parameter_value", "parameter_unit", "exponent", "genome_site",
      "genomic_sequence_available")
  )
})

test_that("get_key_columns works for marburg cfr", {
  df <- get_key_columns(data = marburg_params, parameter_name = "cfr")
  expect_s3_class(df, class = "data.frame")
  expect_identical(dim(df), c(70L, 12L))
  expect_identical(
    colnames(df),
    c("article_label", "article_info", "population_country","population_sample_size",
      "population_sample_type", "population_group",
      "method_disaggregated", "parameter_type",
      "parameter_value", "cfr_ifr_numerator", "cfr_ifr_denominator",
      "cfr_ifr_method")
  )
})

test_that("get_key_columns works for marburg delays", {
  expect_warning(
    df <- get_key_columns(data = marburg_params, parameter_name = "delays"),
    regexp = "(Some of the key columns are not found in the data)"
  )
  expect_s3_class(df, class = "data.frame")
  expect_identical(dim(df), c(70L, 13L))
  expect_identical(
    colnames(df),
    c("article_label", "article_info", "population_country","population_sample_size",
      "population_sample_type", "population_group",
      "method_disaggregated", "parameter_type",
      "parameter_value", "parameter_unit", "distribution_type",
      "distribution_par1_value", "distribution_par2_value")
  )
})

test_that("get_key_columns works for marburg sero", {
  df <- get_key_columns(data = marburg_params, parameter_name = "sero")
  expect_s3_class(df, class = "data.frame")
  expect_identical(dim(df), c(70L, 11L))
  expect_identical(
    colnames(df),
    c("article_label", "article_info", "population_country","population_sample_size",
      "population_sample_type", "population_group",
      "method_disaggregated", "parameter_type",
      "parameter_value", "cfr_ifr_numerator", "cfr_ifr_denominator")
  )
})

test_that("get_key_columns works for marburg risk", {
  df <- get_key_columns(data = marburg_params, parameter_name = "risk")
  expect_s3_class(df, class = "data.frame")
  expect_identical(dim(df), c(70L, 12L))
  expect_identical(
    colnames(df),
    c("article_label", "article_info", "population_country","population_sample_size",
      "population_sample_type", "population_group",
      "method_disaggregated", "parameter_type",
      "riskfactor_outcome", "riskfactor_name", "riskfactor_significant",
      "riskfactor_adjusted")
  )
})

test_that("get_key_columns works for marburg reproduction_number", {
  df <- get_key_columns(
    data = marburg_params,
    parameter_name = "reproduction_number"
  )
  expect_s3_class(df, class = "data.frame")
  expect_identical(dim(df), c(70L, 11L))
  expect_identical(
    colnames(df),
    c("article_label", "article_info", "population_country","population_sample_size",
      "population_sample_type", "population_group",
      "method_disaggregated", "parameter_type",
      "parameter_value", "method_r", "parameter_unit")
  )
})

test_that("get_key_columns works for marburg genomic", {
  expect_warning(
    df <- get_key_columns(data = marburg_params,  parameter_name = "genomic"),
    regexp = "(Some of the key columns are not found in the data)"
  )
  expect_s3_class(df, class = "data.frame")
  expect_identical(dim(df), c(70L, 12L))
  expect_identical(
    colnames(df),
    c("article_label", "article_info", "population_country","population_sample_size",
      "population_sample_type", "population_group",
      "method_disaggregated", "parameter_type",
      "parameter_value", "parameter_unit", "genome_site",
      "genomic_sequence_available")
  )
})

test_that("get_key_columns works for ebola cfr", {
  df <- get_key_columns(data = ebola_params, parameter_name = "cfr")
  expect_s3_class(df, class = "data.frame")
  expect_identical(dim(df), c(1223L, 12L))
  expect_identical(
    colnames(df),
    c("article_label", "article_info", "population_country","population_sample_size",
      "population_sample_type", "population_group",
      "method_disaggregated", "parameter_type",
      "parameter_value", "cfr_ifr_numerator", "cfr_ifr_denominator",
      "cfr_ifr_method")
  )
})

test_that("get_key_columns works for ebola delays", {
  df <- get_key_columns(data = ebola_params, parameter_name = "delays")
  expect_s3_class(df, class = "data.frame")
  expect_identical(dim(df), c(1223L, 15L))
  expect_identical(
    colnames(df),
    c("article_label", "article_info", "population_country","population_sample_size",
      "population_sample_type", "population_group",
      "method_disaggregated", "parameter_type",
      "parameter_value", "parameter_unit", "distribution_type",
      "distribution_par1_value", "distribution_par2_value", "other_delay_start",
      "other_delay_end")
  )
})

test_that("get_key_columns works for ebola sero", {
  df <- get_key_columns(data = ebola_params, parameter_name = "sero")
  expect_s3_class(df, class = "data.frame")
  expect_identical(dim(df), c(1223L, 11L))
  expect_identical(
    colnames(df),
    c("article_label", "article_info", "population_country","population_sample_size",
      "population_sample_type", "population_group",
      "method_disaggregated", "parameter_type",
      "parameter_value", "cfr_ifr_numerator", "cfr_ifr_denominator")
  )
})

test_that("get_key_columns works for ebola risk", {
  df <- get_key_columns(data = ebola_params, parameter_name = "risk")
  expect_s3_class(df, class = "data.frame")
  expect_identical(dim(df), c(1223L, 12L))
  expect_identical(
    colnames(df),
    c("article_label", "article_info", "population_country","population_sample_size",
      "population_sample_type", "population_group",
      "method_disaggregated", "parameter_type",
      "riskfactor_outcome", "riskfactor_name", "riskfactor_significant",
      "riskfactor_adjusted")
  )
})

test_that("get_key_columns works for ebola reproduction_number", {
  df <- get_key_columns(
    data = ebola_params,
    parameter_name = "reproduction_number"
  )
  expect_s3_class(df, class = "data.frame")
  expect_identical(dim(df), c(1223L, 11L))
  expect_identical(
    colnames(df),
    c("article_label", "article_info", "population_country","population_sample_size",
      "population_sample_type", "population_group",
      "method_disaggregated", "parameter_type",
      "parameter_value", "method_r", "parameter_unit")
  )
})

test_that("get_key_columns works for ebola genomic", {
  df <- get_key_columns(data = ebola_params,  parameter_name = "genomic")
  expect_s3_class(df, class = "data.frame")
  expect_identical(dim(df), c(1223L, 13L))
  expect_identical(
    colnames(df),
    c("article_label", "article_info", "population_country","population_sample_size",
      "population_sample_type", "population_group",
      "method_disaggregated", "parameter_type",
      "parameter_value", "parameter_unit", "exponent", "genome_site",
      "genomic_sequence_available")
  )
})

test_that("get_key_columns returns all columns when all_columns = TRUE", {
  df_key <- get_key_columns(data = lassa_params,  parameter_name = "cfr")
  df_all <- get_key_columns(
    data = lassa_params,  parameter_name = "cfr", all_columns = TRUE
  )
  expect_s3_class(df_key, class = "data.frame")
  expect_s3_class(df_all, class = "data.frame")
  expect_lt(ncol(df_key),ncol(df_all))
  expect_identical(dim(df_key),c(440L, 12L))
  ## load_epidata creates an extra column article_info
  expect_identical(dim(df_all),c(440L, 68L)) 

})





