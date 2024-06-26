% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_param_table.R
\name{data_param_table}
\alias{data_param_table}
\title{Process data for delay table}
\usage{
data_param_table(pathogen, prepend = "", exclude = NA)
}
\arguments{
\item{pathogen}{name of pathogen e.g. "marburg"}

\item{prepend}{string to allow loading data in vignettes}

\item{exclude}{article IDs to exclude}
}
\value{
processed data to use as input for delay_table(), risk_table() and
seroprevalence_table()
}
\description{
Process data for delay table
}
\examples{
df <- data_param_table(pathogen = "marburg", prepend = "", exclude = c(15, 17))
}
