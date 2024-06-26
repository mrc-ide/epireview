% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fig_utils.R
\name{shape_palette}
\alias{shape_palette}
\title{shape_palette function}
\usage{
shape_palette(shape_by = c("parameter_value_type"), ...)
}
\arguments{
\item{shape_by}{A character vector specifying the parameter to shape the palette by.
Currently, only "value_type" is supported.}

\item{...}{Additional arguments to be passed to the underlying palette function.
These are treated as names of the palette elements.}
}
\value{
A shape palette based on the specified shape_by parameter.
}
\description{
This function generates a shape palette based on the specified shape_by parameter.
}
\examples{
shape_palette("parameter_value_type")

}
