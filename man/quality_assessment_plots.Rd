% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/quality_assessment.R
\name{quality_assessment_plots}
\alias{quality_assessment_plots}
\title{Plots for the quality assessment (QA) of the included studies}
\usage{
quality_assessment_plots(pathogen = NA, prepend = "")
}
\arguments{
\item{pathogen}{processed data with QA information (see vignette for each
pathogen)}

\item{prepend}{string to allow loading data in vignettes}
}
\value{
two plots to summarise the quality assessment scores
}
\description{
Plots for the quality assessment (QA) of the included studies
}
\examples{
quality_assessment_plots(pathogen = "marburg")
}
