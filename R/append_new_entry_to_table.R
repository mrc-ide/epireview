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
append_new_entry_to_table <- function(pathogen=NA, table_type=NA, new_row=NA, validate = TRUE, write_table = FALSE)
{
  old_table <- load_data(table_type =table_type,pathogen = pathogen)

  # check that schemas match
  if(!((sum( colnames(new_row) == colnames(old_table) ) / length( colnames(new_row )) ) == 1))
    break

  new_table <- rbind(old_table,new_row)

  if(validate)
  {
    if(table_type=='article')     # if not valid it will fail here.
      create_new_article_entry(pathogen = pathogen, new_article = new_row %>% as.vector())
  }

  if(write_table) write.csv(new_table,paste0('data/', pathogen, '_', table_type, '.csv'))

  return(new_table)
}
