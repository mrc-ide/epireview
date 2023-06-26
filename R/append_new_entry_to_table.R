#' append_new_entry_to_table
#'
#' @param pathogen name of pathogen
#' @param table_type
#' @param new_row all the required details for the new row
#' @param validate check if the new row to be added passes minimum criteria
#' @param write_table  write appended table
#' @return Null (updates table)
#' @examples
#'
#' @export
append_new_entry_to_table <- function(pathogen=NA, table_type=NA, new_row=NA, validate = TRUE, write_table = FALSE, vignette_prepend = "")
{
  old_table <- load_data(table_type =table_type,pathogen = pathogen, vignette_prepend = vignette_prepend)

  # check that schemas match
  if(!((sum( colnames(new_row) == colnames(old_table) ) / length( colnames(new_row )) ) == 1))
    stop('Schemas of new row and data sets do not match')

  # check that the entry doesn't exist already -- create same for other table types as well
  if( table_type=='article' & new_row$article_id %in% old_table$article_id)
    stop('article_id already exists in the data set')

  new_table <- rbind(old_table,new_row)

  if(validate)
  {
    if(table_type=='article')     # if not valid it will fail here.
      create_new_article_entry(pathogen = pathogen, new_article = new_row %>% as.vector(), vignette_prepend =  vignette_prepend)
    if(table_type=='outbreak')     # if not valid it will fail here.
      create_new_outbreak_entry(pathogen = pathogen, new_outbreak = new_row %>% as.vector(), vignette_prepend =  vignette_prepend)
    if(table_type=='model')     # if not valid it will fail here.
      create_new_model_entry(pathogen = pathogen, new_model = new_row %>% as.vector(), vignette_prepend =  vignette_prepend)
    if(table_type=='parameter')     # if not valid it will fail here.
      create_new_parameter_entry(pathogen = pathogen, new_param = new_row %>% as.vector(), vignette_prepend =  vignette_prepend)
  }

  if(write_table) write.csv(new_table,paste0(vignette_prepend, 'data/', pathogen, '_', table_type, '.csv'))

  return(new_table)
}
