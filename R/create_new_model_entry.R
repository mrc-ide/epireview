#' Create new model entry
#'
#' @param pathogen name of pathogen
#' @param new_model all the required details for the new outbreak
#' @return return data for new row to be added with append_new_entry_to_table function
#' @examples
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


  # # (1) Valid outbreak_country -- should check against approved list
  # if(!is.character(new_row$outbreak_country) | is.na(new_row$outbreak_country))
  #   stop('No outbreak_country set')
  # # (2) Need valid outbreak_date_year
  # if(new_row$outbreak_date_year < 1800 | new_row$outbreak_date_year > (as.integer(substring(Sys.Date(),1,4))+2))
  #   stop('Publication year outside allowed range')

  return(new_row)
}




