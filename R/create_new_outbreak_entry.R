#' Create new outbreak entry
#'
#' @param pathogen name of pathogen
#' @param new_outbreak all the required details for the new outbreak
#' @return return data for new row to be added with append_new_entry_to_table function
#' @examples
#'
#' @export
create_new_outbreak_entry <- function(pathogen = NA,
                                     new_outbreak = c( list( "article_id"           = as.integer(NA)),
                                                       list( "outbreak_start_day"   = as.integer(NA)),
                                                       list( "outbreak_start_month" = as.character(NA)),
                                                       list( "outbreak_start_year"  = as.integer(NA)),
                                                       list( "outbreak_end_day"     = as.integer(NA)),
                                                       list( "outbreak_end_month"   = as.character(NA)),
                                                       list( "outbreak_date_year"   = as.integer(NA)),
                                                       list( "outbreak_duration_months" = as.integer(NA)),
                                                       list( "outbreak_size"        = as.integer(NA)),
                                                       list( "asymptomatic_transmission" = as.integer(NA)),
                                                       list( "outbreak_country"     = as.character(NA)),
                                                       list( "outbreak_location"    = as.character(NA)),
                                                       list( "cases_confirmed"      = as.integer(NA)),
                                                       list( "cases_mode_detection" = as.character(NA)),
                                                       list( "cases_suspected"      = as.integer(NA)),
                                                       list( "cases_asymptomatic"   = as.integer(NA)),
                                                       list( "deaths"               = as.integer(NA)),
                                                       list( "cases_severe_hospitalised" = as.integer(NA)),
                                                       list( "covidence_id"         = as.integer(NA))   ))
{
  #read current article data for pathogen
  articles             <- as_tibble(load_data(table_type = 'article',pathogen = pathogen))
  old_outbreaks        <- as_tibble(load_data(table_type = 'outbreak',pathogen = pathogen))
  new_row              <- as_tibble_row(new_outbreak)

  # generate the below quanties
  new_row$outbreak_id  <- max(old_outbreaks$outbreak_id) + 1

  new_row              <- new_row %>% dplyr::select(colnames(old_outbreaks))

  # Need to check that article_id & covidence_id exist in the articles table.
  if(!(new_row$article_id %in% articles$article_id & articles[articles$article_id==new_row$article_id,]$covidence_id == new_row$covidence_id))
    stop('Article_id + Covidence_id pair does not exist in article data')

  #validate that the entries make sense

  # (1) Valid outbreak_country -- should check against approved list
  if(!is.character(new_row$outbreak_country) | is.na(new_row$outbreak_country))
    stop('No outbreak_country set')
  # (2) Need valid outbreak_date_year
  if(new_row$outbreak_date_year < 1800 | new_row$outbreak_date_year > (as.integer(substring(Sys.Date(),1,4))+2))
    stop('Publication year outside allowed range')

  return(new_row)
}




