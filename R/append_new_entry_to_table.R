#' Append new entry to article, outbreak, model, or parameter table
#'
#' @description This function appends a new entry to the article, outbreak, model,  or parameter tables.
#' 
#' @inheritParams load_epidata_raw
#' @param new_row the new row of data to be added to the table, this can be
#' generated using the utility functions \code{create_new_article_entry()}, \code{create_new_model_entry()},
#' \code{create_new_outbreak_entry()}, or \code{create_new_parameter_entry()}.
#' @param validate check if the new row to be added passes minimum criteria
#' (either TRUE or FALSE)
#' @return table with new entry 
#' @importFrom readr write_csv
#'
#' @export
append_new_entry_to_table <- function(pathogen,
                                      table,
                                      new_row,
                                      validate = TRUE
                                      ) {

  # assertions
  assert_pathogen(pathogen)
  assert_table(table)

  old_table <- load_epidata_raw(pathogen = pathogen, table)
                            
                            

  if (!((sum(colnames(new_row) == colnames(old_table)) /
        length(colnames(new_row))) == 1))
    stop("Schemas of new row and data sets do not match")

  if (table == "article" && new_row$article_id %in% old_table$article_id)
    stop("article_id already exists in the data set")

  new_table <- rbind(old_table, new_row)

  if (validate) {
    if (table == "article")
      create_new_article_entry(pathogen = pathogen,
                               new_article = new_row %>% as.vector())
    if (table == "outbreak")
      create_new_outbreak_entry(pathogen = pathogen,
                                new_outbreak = new_row %>% as.vector())
    if (table == "model")
      create_new_model_entry(pathogen = pathogen,
                             new_model = new_row %>% as.vector())
    if (table == "parameter")
      create_new_parameter_entry(pathogen = pathogen,
                                 new_param = new_row %>% as.vector())
  }


  new_table
}
                                      