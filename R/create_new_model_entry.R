#' Create new model entry
#'
#' @param pathogen name of pathogen
#' @param new_model all the required details for the new outbreak
#' @param vignette_prepend string to allowing loading data from vignettes
#' @return return data for new row to be added with append_new_entry_to_table function
#' @importFrom tibble as_tibble
#' @importFrom validate validator
#' @importFrom validate confront
#' @importFrom validate summary
#' @examples
#' create_new_model_entry('marburg',new_model = c( list( "article_id"           = as.integer(1)),
#'                                        list( "model_type"           = as.character("Compartmental")),
#'                                        list( "compartmental_type"   = as.character("SEIR,SIR")),
#'                                        list( "stoch_deter"          = as.character("Deterministic")),
#'                                        list( "theoretical_model"    = as.logical(FALSE)),
#'                                        list( "interventions_type"   = as.character("Vaccination")),
#'                                        list( "code_available"       = as.logical(TRUE)),
#'                                        list( "transmission_route"   = as.character("Sexual")),
#'                                        list( "assumptions"          = as.character("Unspecified")),
#'                                        list( "covidence_id"         = as.integer(2059))),
#'                          vignette_prepend = "")
#'
#' @export
create_new_model_entry <- function(pathogen = NA,
                                      new_model = c(    list( "article_id"           = as.integer(NA)),
                                                        list( "model_type"           = as.character(NA)),
                                                        list( "compartmental_type"   = as.character(NA)),
                                                        list( "stoch_deter"          = as.character(NA)),
                                                        list( "theoretical_model"    = as.logical(NA)),
                                                        list( "interventions_type"   = as.character(NA)),
                                                        list( "code_available"       = as.logical(NA)),
                                                        list( "transmission_route"   = as.character(NA)),
                                                        list( "assumptions"          = as.character(NA)),
                                                        list( "covidence_id"         = as.integer(NA))),
                                   vignette_prepend = "")
{
  #read current article data for pathogen
  articles             <- as_tibble(load_data(table_type = 'article',pathogen = pathogen),vignette_prepend=vignette_prepend)
  old_models           <- as_tibble(load_data(table_type = 'model',pathogen = pathogen),vignette_prepend=vignette_prepend)
  new_row              <- as_tibble_row(new_model)

  # generate the below quanties
  new_row$model_data_id <- max(old_models$model_data_id) + 1

  new_row              <- new_row %>% dplyr::select(colnames(old_models))

  # Need to check that article_id & covidence_id exist in the articles table.
  if(!(new_row$article_id %in% articles$article_id & articles[articles$article_id==new_row$article_id,]$covidence_id == new_row$covidence_id))
    stop('Article_id + Covidence_id pair does not exist in article data')

  #available options for fields
  file_path_ob  <- system.file("data", "access_db_dropdown_models.csv", package = "epireview")
  if(file_path_ob=="") file_path_ob <- paste0(vignette_prepend,"data/access_db_dropdown_models.csv")
  model_options <- read_csv(file_path_ob)

  #validate that the entries make sense
  rules <- validator(
    model_type_is_character         = is.character(model_type),
    model_types_valid               = strsplit(model_type,",")[[1]] %vin% na.omit(model_options$`Model type`),
    compartmental_type_is_character = is.character(compartmental_type),
    compartmental_type_valid        = strsplit(compartmental_type,",")[[1]] %vin% na.omit(model_options$`Compartment type`),
    stoch_deter_is_character        = is.character(stoch_deter),
    stoch_deter_valid               = strsplit(stoch_deter,",")[[1]] %vin% na.omit(model_options$`Stochastic or deterministic`),
    intervention_type_is_character  = is.character(interventions_type),
    intervention_type_valid         = strsplit(interventions_type,",")[[1]] %vin% na.omit(model_options$Interventions),
    transmission_route_is_character = is.character(transmission_route),
    transmission_route_valid        = strsplit(transmission_route,",")[[1]] %vin% na.omit(model_options$`Transmission route`),
    assumptions_is_character        = is.character(assumptions),
    assumptions_valid               = strsplit(assumptions,",")[[1]] %vin% na.omit(model_options$Assumptions),
    code_available_check            = code_available %in% c(0,1,NA),
    theoretical_model_check         = theoretical_model %in% c(0,1,NA)
  )

  rules_output  <- confront(new_row, rules)
  rules_summary <- summary(rules_output)

  print(as_tibble(rules_summary) %>% filter(fails>0))

  if(sum(rules_summary$fails)>0)
    stop(as_tibble(rules_summary) %>% filter(fails>0) )

  return(new_row)
}




