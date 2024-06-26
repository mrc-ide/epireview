% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fig_utils.R
\name{color_palette}
\alias{color_palette}
\title{Define a consistent color palette for use in
figures. Palettes are currently defined for
parameters and countries. Any other variable will
return NULL}
\usage{
color_palette(col_by = c("parameter_type", "population_country"), ...)
}
\arguments{
\item{col_by}{a character vector specifying the parameter to color the
palette by.}

\item{...}{additional arguments to be passed to the underlying palette
function.
These are treated as names of the palette elements.}
}
\value{
a named list of colors that can be used in forest plots for manually
setting colors
}
\description{
Define a consistent color palette for use in
figures. Palettes are currently defined for
parameters and countries. Any other variable will
return NULL
}
