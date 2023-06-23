#' Create new model entry
#'
#' @param pathogen name of pathogen
#' @param new_model all the required details for the new outbreak
#' @return return data for new row to be added with append_new_entry_to_table function
#' @examples
#' create_new_outbreak_entry('marburg',c( list( "article_id"           = as.integer(1)),
#'                                        list( "model_type"           = as.character("Compartmental")),
#'                                        list( "compartmental_type"   = as.character("SEIR,SIR")),
#'                                        list( "stoch_deter"          = as.character("Deterministic")),
#'                                        list( "theoretical_model"    = as.logical(FALSE)),
#'                                        list( "interventions_type"   = as.character("Vaccination")),
#'                                        list( "code_available"       = as.logical(TRUE)),
#'                                        list( "transmission_route"   = as.character("Sexual")),
#'                                        list( "assumptions"          = as.character("Unspecified")),
#'                                        list( "covidence_id"         = as.integer(2059))   ))
#'
#' @export
create_new_outbreak_entry <- function(pathogen = NA,
                                      new_model = c(    list( "article_id"           = as.integer(NA)),
                                                        list( "model_type"           = as.character(NA)),
                                                        list( "compartmental_type"   = as.character(NA)),
                                                        list( "stoch_deter"          = as.character(NA)),
                                                        list( "theoretical_model"    = as.logical(NA)),
                                                        list( "interventions_type"   = as.character(NA)),
                                                        list( "code_available"       = as.logical(NA)),
                                                        list( "transmission_route"   = as.character(NA)),
                                                        list( "assumptions"          = as.character(NA)),
                                                        list( "covidence_id"         = as.integer(NA))   ))
{
  #read current article data for pathogen
  articles             <- as_tibble(load_data(table_type = 'article',pathogen = pathogen))
  old_models           <- as_tibble(load_data(table_type = 'model',pathogen = pathogen))
  new_row              <- as_tibble_row(new_model)

  # generate the below quanties
  new_row$model_data_id <- max(old_models$model_data_id) + 1

  new_row              <- new_row %>% dplyr::select(colnames(old_models))

  # Need to check that article_id & covidence_id exist in the articles table.
  if(!(new_row$article_id %in% articles$article_id & articles[articles$article_id==new_row$article_id,]$covidence_id == new_row$covidence_id))
    stop('Article_id + Covidence_id pair does not exist in article data')

  #available options for fields
  file_path_ob  <- system.file("data", "access_db_dropdown_models.csv", package = "epireview")
  if(file_path_ob=="") file_path_ob <- "data/access_db_dropdown_models.csv"
  model_options <- read_csv(file_path_ob)

  #validate that the entries make sense
  if(!is.character(new_row$model_type) | is.na(new_row$model_type) )
    stop(paste0('Model type not set'))
  for( model in strsplit(new_row$model_type,",")[[1]])
    if(!(model %in% model_options$`Model type`))
      stop(paste(model,'not valid'))

  if(!is.character(new_row$compartmental_type) | is.na(new_row$compartmental_type) )
    stop(paste0('Compartmental type not set'))
  for( model in strsplit(new_row$compartmental_type,",")[[1]])
    if(!(model %in% model_options$`Compartment type`))
      stop(paste(model,'not valid'))

  if(!is.character(new_row$stoch_deter) | is.na(new_row$stoch_deter) )
    stop(paste0('Stochastic/Deterministic not set'))
  for( model in strsplit(new_row$stoch_deter,",")[[1]])
    if(!(model %in% model_options$`Stochastic or deterministic`))
      stop(paste(model,'not valid'))

  if(!is.character(new_row$interventions_type) | is.na(new_row$interventions_type) )
    stop(paste0('Intervention not set'))
  for( model in strsplit(new_row$interventions_type,",")[[1]])
    if(!(model %in% model_options$Interventions))
      stop(paste(model,'not valid'))

  if(!is.character(new_row$transmission_route) | is.na(new_row$transmission_route) )
    stop(paste0('Transmission route not set'))
  for( model in strsplit(new_row$transmission_route,",")[[1]])
    if(!(model %in% model_options$`Transmission route`))
      stop(paste(model,'not valid'))

  if(!is.character(new_row$assumptions) | is.na(new_row$assumptions) )
    stop(paste0('Transmission route not set'))
  for( model in strsplit(new_row$assumptions,",")[[1]])
    if(!(model %in% model_options$Assumptions))
      stop(paste(model,'not valid'))

  if(!(new_row$code_available %in% c(0,1,NA)))
    stop('code_available outside allowed values')
  if(!(new_row$theoretical_model %in% c(0,1,NA)))
    stop('theoretical_model outside allowed values')

  return(new_row)
}




