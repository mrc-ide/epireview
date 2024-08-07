% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/load_epidata_raw.R
\name{load_epidata_raw}
\alias{load_epidata_raw}
\title{Loads raw data for a particular pathogen}
\usage{
load_epidata_raw(
  pathogen,
  table = c("article", "parameter", "outbreak", "model", "param_name")
)
}
\arguments{
\item{pathogen}{name of pathogen. Must be one of the priority pathogens
exactly as specified in the package. You can get a list of the
priority pathogens currently included in the package by calling}

\item{table}{the table to be loaded. Must be one of
"article", "parameter", "outbreak", or "model"}
}
\value{
data.frame reading in the csv the specified pathogen table
}
\description{
Loads raw data for a particular pathogen
}
\details{
This function will return the raw data as a data.frame. The
csv files of the models, outbreaks, and parameters for a pathogen
do not contain information on the source but only an "article_id"
that can be used to merge them with the articles. If you wish to
retrieve linked information or multiple tables at the same time,
use \code{load_epidata} instead.
}
\examples{
load_epidata_raw(pathogen = "marburg", table = "outbreak")
}
\seealso{
\code{\link[=load_epidata]{load_epidata()}} for a more user-friendly interface
}
