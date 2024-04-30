#' Create new model entry
#'
#' @param pathogen name of pathogen
#' @param new_model all the required details for the new model
#' @return return new row of data to be added to the model data set using the
#' append_new_entry_to_table() function
#' @importFrom tibble as_tibble as_tibble_row
#' @importFrom validate validator confront summary %vin%
#' @importFrom dplyr select
#' @importFrom readr read_csv
#' @importFrom stats na.omit
#' @importFrom methods as
#' @examples
#' create_new_model_entry(
#'   pathogen = 'marburg',
#'   new_model = list(
#'     article_id           = as.numeric(1),
#'     model_type           = as.character("Compartmental"),
#'     compartmental_type   = as.character("SEIR, SIR"),
#'     stoch_deter          = as.character("Deterministic"),
#'     theoretical_model    = as.logical(FALSE),
#'     interventions_type   = as.character("Vaccination"),
#'     code_available       = as.logical(TRUE),
#'     transmission_route   = as.character("Sexual"),
#'     assumptions          = as.character("Unspecified"),
#'     covidence_id         = as.integer(2059)
#'   )
#' )
#'
#' @export
create_new_model_entry <-
  function(pathogen = NA,
           new_model = list(
             article_id          = as.numeric(NA),
             model_type          = as.character(NA),
             compartmental_type  = as.character(NA),
             stoch_deter         = as.character(NA),
             theoretical_model   = as.logical(NA),
             interventions_type  = as.character(NA),
             code_available      = as.logical(NA),
             transmission_route  = as.character(NA),
             assumptions         = as.character(NA),
             covidence_id        = as.integer(NA)
           )
  ) {

    #read current article data for pathogen
    articles <- as_tibble(load_epidata_raw(pathogen = pathogen, "article"))

    old_models <- as_tibble(load_epidata_raw(pathogen = pathogen, "model"))

    new_row <- as_tibble_row(new_model)

    ## Look for any columns in old data that are not in new data
    ## and add them to new data with NA values with the same class
    ## as the corresponding column in the old data.
    for (col in colnames(old_models)) {
      if (!(col %in% colnames(new_row))) {
        new_row[[col]] <- as(NA, class(old_models[[col]]))
      }
    }

    # generate the below quantities
    new_row$model_data_id <- max(old_models$model_data_id) + 1
    new_row <- new_row %>% select(colnames(old_models))

    # Need to check that article_id & covidence_id exist in the articles table.
    if (!(new_row$article_id %in% articles$article_id &&
          articles[articles$article_id ==
                     new_row$article_id, ]$covidence_id == new_row$covidence_id))
      stop("Article_id + Covidence_id pair does not exist in article data")

    #available options for fields
    file_path_ob <- system.file("extdata", paste0(pathogen, "_dropdown_models.csv"),
                                package = "epireview")

    model_options <- read_csv(file_path_ob)

    # Deal with R CMD Check "no visible binding for global variable"
    model_type <- compartmental_type <- stoch_deter <- interventions_type <-
      transmission_route <- assumptions <- code_available <- theoretical_model <-
      fails <- NULL

    #validate that the entries make sense
    rules <- validator(
      model_type_is_character = is.character(model_type),
      model_types_valid = strsplit(model_type, ",")[[1]] %vin%
        na.omit(model_options$`Model type`),
      compartmental_type_is_character = is.character(compartmental_type),
      compartmental_type_valid = strsplit(compartmental_type, ",")[[1]] %vin%
        na.omit(model_options$`Compartment type`),
      stoch_deter_is_character = is.character(stoch_deter),
      stoch_deter_valid = strsplit(stoch_deter, ",")[[1]] %vin%
        na.omit(model_options$`Stochastic or deterministic`),
      intervention_type_is_character = is.character(interventions_type),
      intervention_type_valid = strsplit(interventions_type, ",")[[1]] %vin%
        na.omit(model_options$Interventions),
      transmission_route_is_character = is.character(transmission_route),
      transmission_route_valid = strsplit(transmission_route, ",")[[1]] %vin%
        na.omit(model_options$`Transmission route`),
      assumptions_is_character = is.character(assumptions),
      assumptions_valid = strsplit(assumptions, ",")[[1]] %vin%
        na.omit(model_options$Assumptions),
      code_available_check = code_available %in% c(0, 1, NA),
      theoretical_model_check = theoretical_model %in% c(0, 1, NA)
    )

    rules_output  <- confront(new_row, rules)
    rules_summary <- summary(rules_output)

    print(as_tibble(rules_summary) %>% filter(fails > 0))

    if (sum(rules_summary$fails) > 0) {
      stop(as_tibble(rules_summary) %>% filter(fails > 0))
    }

    return(new_row)
  }
