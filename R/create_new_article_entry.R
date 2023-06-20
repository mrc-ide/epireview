#' Create new article entry
#'
#' @param pathogen name of pathogen
#' @param new_article all the required details for the new article
#' @return return data for new row to be added with append_new_entry_to_table function
#' @examples
#'
#' @export
create_new_article_entry <- function(pathogen = NA,
                                     new_article = c(  list( "first_author_first_name" = as.character(NA)),
                                                       list( "first_author_surname"    = as.character(NA)),
                                                       list( "article_title"           = as.character(NA)),
                                                       list( "doi"                     = as.character(NA)),
                                                       list( "journal"                 = as.character(NA)),
                                                       list( "year_publication"        = as.integer(NA)),
                                                       list( "volume"                  = as.integer(NA)),
                                                       list( "issue"                   = as.integer(NA)),
                                                       list( "page_first"              = as.integer(NA)),
                                                       list( "page_last"               = as.integer(NA)),
                                                       list( "paper_copy_only"         = as.logical(NA)),
                                                       list( "notes"                   = as.character(NA)),
                                                       list( "qa_m1"                   = as.integer(NA)),
                                                       list( "qa_m2"                   = as.integer(NA)),
                                                       list( "qa_a3"                   = as.integer(NA)),
                                                       list( "qa_a4"                   = as.integer(NA)),
                                                       list( "qa_d5"                   = as.integer(NA)),
                                                       list( "qa_d6"                   = as.integer(NA)),
                                                       list( "qa_d7"                   = as.integer(NA))   ))
{
  #read current article data for pathogen
  old_articles         <- as_tibble(load_data(table_type = 'article',pathogen = pathogen))
  new_row              <- as_tibble_row(new_article)

  # generate the below quanties
  new_row$article_id   <- max(old_articles$article_id) + 1
  new_row$covidence_id <- paste0('new_',max(old_articles$covidence_id) + 1)
  new_row$pathogen     <- switch(pathogen,"marburg"="Marburg virus",
                                 "ebola"="Ebola virus", NA)      #need to complete list for all pathogens
  new_row$double_extracted <- FALSE

  new_row               <- new_row %>% rowwise() %>% mutate(score = mean(c(qa_m1,qa_m2,qa_a3,qa_a4,qa_d5,qa_d6,qa_d7),na.rm=TRUE)) %>%
    dplyr::select(colnames(old_articles))

  #validate that the entries make sense
  if(!is.character(new_row$first_author_first_name) | is.na(new_row$first_author_first_name))
    stop('No first name set')
  if(!is.character(new_row$first_author_surname) | is.na(new_row$first_author_surname))
    stop('No surname set')
  if(!is.character(new_row$article_title) | is.na(new_row$article_title))
    stop('No article title set')
  if(!is.character(new_row$journal) | is.na(new_row$journal))
    stop('No journal set')
  if(new_row$year_publication < 1800 | new_row$year_publication > (as.integer(substring(Sys.Date(),1,4))+2))
    stop('Publication year outside allowed range')
  if(!(new_row$qa_m1 %in% c(0,1,NA)))
    stop('qa_m1 outside allowed values')
  if(!(new_row$qa_m2 %in% c(0,1,NA)))
    stop('qa_m2 outside allowed values')
  if(!(new_row$qa_a3 %in% c(0,1,NA)))
    stop('qa_a3 outside allowed values')
  if(!(new_row$qa_a4 %in% c(0,1,NA)))
    stop('qa_a4 outside allowed values')
  if(!(new_row$qa_d5 %in% c(0,1,NA)))
    stop('qa_d5 outside allowed values')
  if(!(new_row$qa_d6 %in% c(0,1,NA)))
    stop('qa_d6 outside allowed values')
  if(!(new_row$qa_d7 %in% c(0,1,NA)))
    stop('qa_d7 outside allowed values')

  return(new_row)
}




