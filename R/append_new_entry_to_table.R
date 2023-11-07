#' Append new entry to article, outbreak, model, or parameter table
#'
#' NOTE: This can only be run in a locally cloned repository
#'
#' @param pathogen name of pathogen
#' @param table_type table to be updated, either "article", "outbreak", "model"
#' or "parameter"
#' @param new_row the new row of data to be added to the table, this can be
#' generated using either create_new_article_entry(), create_new_model_entry(),
#' create_new_outbreak_entry(), or create_new_parameter_entry() (must contain
#' the same number of variables as the table to be updated)
#' @param validate check if the new row to be added passes minimum criteria
#' (either TRUE or FALSE)
#' @param write_table write appended table (either TRUE or FALSE). If TRUE the
#' new table will be written as a csv file in the data folder of a locally
#' cloned repository.
#' @param vignette_prepend string to allow loading data in vignettes
#' @return table with new entry (if write_table = TRUE the relevant table in a
#' locally cloned repository is updated)
#' @importFrom readr write_csv
#'
#' @export
append_new_entry_to_table <- function(pathogen = NA,
                                      table_type = NA,
                                      new_row = NA,
                                      validate = TRUE,
                                      write_table = FALSE,
                                      vignette_prepend = "") {

  # assertions
  assert_pathogen(pathogen)
  assert_table(table_type)

  old_table <- load_epidata(table_type = table_type,
                            pathogen = pathogen,
                            vignette_prepend = vignette_prepend)

  if (!((sum(colnames(new_row) == colnames(old_table)) /
        length(colnames(new_row))) == 1))
    stop("Schemas of new row and data sets do not match")

  if (table_type == "article" && new_row$article_id %in% old_table$article_id)
    stop("article_id already exists in the data set")

  new_table <- rbind(old_table, new_row)

  if (validate) {
    if (table_type == "article")
      create_new_article_entry(pathogen = pathogen,
                               new_article = new_row %>% as.vector(),
                               vignette_prepend = vignette_prepend)
    if (table_type == "outbreak")
      create_new_outbreak_entry(pathogen = pathogen,
                                new_outbreak = new_row %>% as.vector(),
                                vignette_prepend = vignette_prepend)
    if (table_type == "model")
      create_new_model_entry(pathogen = pathogen,
                             new_model = new_row %>% as.vector(),
                             vignette_prepend = vignette_prepend)
    if (table_type == "parameter")
      create_new_parameter_entry(pathogen = pathogen,
                                 new_param = new_row %>% as.vector(),
                                 vignette_prepend = vignette_prepend)
  }

  if (write_table)
    write_csv(new_table, paste0(vignette_prepend, "inst/extdata/", pathogen, "_",
                                table_type, ".csv"))

  return(new_table)
}
