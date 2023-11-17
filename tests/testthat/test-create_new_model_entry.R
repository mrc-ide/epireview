old_models <- as_tibble(load_epidata(table_type = "model",
                                     pathogen = 'marburg',
                                     vignette_prepend = ''))
model_columns <- colnames(old_models)

dummy_model = c(list("article_id"           = as.numeric(1)),
              list("model_type"           = as.character("Compartmental")),
              list("compartmental_type"   = as.character("SEIR, SIR")),
              list("stoch_deter"          = as.character("Deterministic")),
              list("theoretical_model"    = as.logical(FALSE)),
              list("interventions_type"   = as.character("Vaccination")),
              list("code_available"       = as.logical(TRUE)),
              list("transmission_route"   = as.character("Sexual")),
              list("assumptions"          = as.character("Unspecified")),
              list("covidence_id"         = as.numeric(2059)))

test_that("new model entry matches old model structure", {
  expect_error(create_new_model_entry(pathogen='marburg'))

  dummy <- create_new_model_entry(pathogen = 'marburg', new_model = dummy_model)
  expect_named(dummy,model_columns)
  expect_s3_class(dummy,'data.frame',exact = FALSE)
  expect_identical(sapply(dummy, class),sapply(old_models, class))

  file_path_ob <- system.file("extdata", paste0('marburg', "_dropdown_models.csv"),
                              package = "epireview")
  model_options <- read_csv(file_path_ob)

})
