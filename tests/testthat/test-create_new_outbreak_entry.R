old_outbreaks <- as_tibble(load_epidata_raw(pathogen = 'marburg', table = "outbreak"))
                                       
                                       
outbreak_columns <- colnames(old_outbreaks)
dummy_outbreak = c(list("article_id"           = as.numeric(1)),
                 list("outbreak_start_day"   = as.numeric(NA)),
                 list("outbreak_start_month" = as.character(NA)),
                 list("outbreak_start_year"  = as.numeric(1999)),
                 list("outbreak_end_day"     = as.numeric(NA)),
                 list("outbreak_end_month"   = as.character(NA)),
                 list("outbreak_date_year"   = as.numeric(2001)),
                 list("outbreak_duration_months" = as.numeric(NA)),
                 list("outbreak_size"        = as.logical(NA)),
                 list("asymptomatic_transmission" = as.numeric(0)),
                 list("outbreak_country"     = as.character("Tanzania")),
                 list("outbreak_location"    = as.character(NA)),
                 list("cases_confirmed"      = as.numeric(NA)),
                 list("cases_mode_detection" = as.character(NA)),
                 list("cases_suspected"      = as.numeric(NA)),
                 list("cases_asymptomatic"   = as.numeric(NA)),
                 list("deaths"               = as.numeric(2)),
                 list("cases_severe_hospitalised" = as.numeric(NA)),
                 list("covidence_id"         = as.numeric(2059)))

test_that("new outbreak entry matches old outbreak structure", {
  expect_error(create_new_outbreak_entry(pathogen='marburg'))

  dummy <- create_new_outbreak_entry(pathogen = 'marburg', new_outbreak = dummy_outbreak)
  expect_named(dummy,outbreak_columns)
  expect_s3_class(dummy,'data.frame',exact = FALSE)
  expect_identical(sapply(dummy, class),sapply(old_outbreaks, class))

})
