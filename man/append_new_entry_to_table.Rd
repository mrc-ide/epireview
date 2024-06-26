% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/append_new_entry_to_table.R
\name{append_new_entry_to_table}
\alias{append_new_entry_to_table}
\title{Append new entry to article, outbreak, model, or parameter table}
\usage{
append_new_entry_to_table(pathogen, table, new_row, validate = TRUE)
}
\arguments{
\item{pathogen}{name of pathogen. Must be one of the priority pathogens
exactly as specified in the package. You can get a list of the
priority pathogens currently included in the package by calling}

\item{table}{the table to be loaded. Must be one of
"article", "parameter", "outbreak", or "model"}

\item{new_row}{the new row of data to be added to the table, this can be
generated using the utility functions \code{create_new_article_entry()}, \code{create_new_model_entry()},
\code{create_new_outbreak_entry()}, or \code{create_new_parameter_entry()}.}

\item{validate}{check if the new row to be added passes minimum criteria
(either TRUE or FALSE)}
}
\value{
table with new entry
}
\description{
This function appends a new entry to the article, outbreak, model,  or parameter tables.
}
