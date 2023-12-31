% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/append_new_entry_to_table.R
\name{append_new_entry_to_table}
\alias{append_new_entry_to_table}
\title{Append new entry to article, outbreak, model, or parameter table}
\usage{
append_new_entry_to_table(
  pathogen = NA,
  table_type = NA,
  new_row = NA,
  validate = TRUE,
  write_table = FALSE,
  vignette_prepend = ""
)
}
\arguments{
\item{pathogen}{name of pathogen}

\item{table_type}{table to be updated, either "article", "outbreak", "model"
or "parameter"}

\item{new_row}{the new row of data to be added to the table, this can be
generated using either create_new_article_entry(), create_new_model_entry(),
create_new_outbreak_entry(), or create_new_parameter_entry() (must contain
the same number of variables as the table to be updated)}

\item{validate}{check if the new row to be added passes minimum criteria
(either TRUE or FALSE)}

\item{write_table}{write appended table (either TRUE or FALSE). If TRUE the
new table will be written as a csv file in the data folder of a locally
cloned repository.}

\item{vignette_prepend}{string to allow loading data in vignettes}
}
\value{
table with new entry (if write_table = TRUE the relevant table in a
locally cloned repository is updated)
}
\description{
NOTE: This can only be run in a locally cloned repository
}
