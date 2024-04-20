test_that("data_curation works as expected", {

  articles   <- read_csv('_snaps\\sars_articles.csv')
  models     <- read_csv('_snaps\\sars_models.csv')
  parameters <- read_csv('_snaps\\sars_parameters.csv')
  outbreaks  <- read_csv('_snaps\\sars_outbreaks.csv')

  # CASE 1: plotting is FALSE
  df_plotting_false <- data_curation(articles,outbreaks = data.frame(),models,parameters,plotting = FALSE)

  expect_equal(df_plotting_false$articles$refs[1], 'Zhou (2003)')
  expect_equal(dim(outbreaks),dim(df_plotting_false$outbreaks))    # outbreaks were empty and should still be empty
  expect_equal(length(df_plotting_false), 4)                       # output 4 items
  expect_equal(names(df_plotting_false), c("articles", "outbreaks", "models", "parameters"))
  expect_equal(nrow(df_plotting_false$articles), 290)
  expect_equal(nrow(df_plotting_false$parameters), 762)
  expect_equal(nrow(df_plotting_false$models), 112)
  expect_equal(nrow(df_plotting_false$outbreaks), 0)

  check_mutation_rate <- df_plotting_false$parameters[df_plotting_false$parameters$parameter_data_id == '6368b8866f341abcdbd86b721e5db78f',]
  expect_equal(check_mutation_rate$parameter_value, 5.7)

  # CASE 2: plotting is TRUE
  df_plotting_true <- data_curation(articles,outbreaks = data.frame(),models,parameters,plotting = TRUE)

  expect_equal(df_plotting_true$articles$refs[1], 'Zhou (2003)')
  expect_equal(dim(outbreaks),dim(df_plotting_true$outbreaks))    # outbreaks were empty and should still be empty
  expect_equal(length(df_plotting_true), 4)                       # output 4 items
  expect_equal(names(df_plotting_true), c("articles", "outbreaks", "models", "parameters"))
  expect_equal(nrow(df_plotting_true$articles), 290)
  expect_equal(nrow(df_plotting_true$parameters), 762)
  expect_equal(nrow(df_plotting_true$models), 112)
  expect_equal(nrow(df_plotting_true$outbreaks), 0)

  check_mutation_rate <- df_plotting_true$parameters[df_plotting_false$parameters$parameter_data_id == '6368b8866f341abcdbd86b721e5db78f',]
  expect_equal(check_mutation_rate$parameter_value, 0.0000057)
})
