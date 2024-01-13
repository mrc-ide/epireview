#' Plotting theme for epireview
#' A standard theme for figures in epireview.
#' @inheritParams ggplot2::theme_bw
#' @importFrom ggplot2 update_geom_defaults
#' @importFrom ggplot2 theme_bw
#' @importFrom ggplot2 theme
#' @export
theme_epireview <- function(
    base_size = 11,
    base_family = "",
    base_line_size = base_size / 22,
    base_rect_size = base_size / 22) {

  update_geom_defaults("point", list(size = 3))
  update_geom_defaults("segment", list(lwd = 5, alpha = 0.4))
  update_geom_defaults("errorbar", list(lwd = 1, width = 0.4))
  th <- theme_bw(base_size, base_family, base_line_size, base_rect_size)
  th <- th + theme(
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5),
    plot.margin = margin(10, 20, 10, 20),
    panel.spacing = unit(1.5, "lines"),
    legend.position = "bottom"
  )

  th
}

#' country_palette Function
#'
#' This function creates a color palette for countries.
#'
#' 
#' @param countries A vector of country names. If not provided, a palette of length 36 with a default set of
#' countries is returned.
#'
#' @return A named color palette.
#'
#' @examples
#' country_palette()
#' country_palette(countries = c("USA", "Canada", "Mexico"))
#'
#' @importFrom paletteer paletteer_d
#' @importFrom pals polychrome
#'
#' @export
country_palette <- function(countries) {
  pal <- paletteer::paletteer_d("pals::polychrome")
  ## this gives a palette of length 36. I don't think
  ## we need more than 36 countries in a single plot.
  if (missing(countries)) {
    countries <- c(
      'Liberia', 'Guinea', 'Sierra Leone', 'Nigeria', 'Senegal', 'Mali',
      'DRC', 'Gabon', 'Uganda', 'South Sudan', 'Kenya', 'Ethiopia',
      'Cameroon', 'Central African Republic', 'Republic of the Congo',
      'Sudan', 'Chad', 'Benin', 'Togo', 'Ghana', 'Burkina Faso', 'Ivory Coast',
      'Equatorial Guinea', 'Angola', 'South Africa', 'Zambia', 'Tanzania',
      'Djibouti', 'Somalia', 'Mozambique', 'Madagascar', 'Malawi', 'Zimbabwe',
      'United Kingdom', 'Unspecified'
    )
  } else {
    ## If more than 36 countries are provided, throw and error
    if (length(countries) > 36) {
      stop("More than 36 countries provided. Please provide a vector of length 36 or less")
    }
    pal <- pal[1:length(countries)]
  }
  names(pal) <- countries
  pal
}

##' Define a consistent color palette for use in
##' figures
##'
##'
##' @param x a list of parameters. Optional. If missing, the entire
##' palette is returned.
##' @return a named list of colors that can be used
##' in forest plots for manually setting colors
##' with for example
##' \code{\link{ggplot2:scale_color_manual}{scale_color_manual}}
##' @author Sangeeta Bhatia
parameter_palette <- function(x) {
  out <- list(
    ## Variations of R0
    "Basic (R0)" = "#D95F02",
    "Reproduction number (Basic R0)" = "#D95F02",
    ## Variations of Re
    "Effective (Re)" = "#7570B3",
    "Reproduction number (Effective, Re)" = "#7570B3"
  )
  if (missing(x)) {
    return(out)
  }
  out[x]
}
##' Define a consistent shape palette for use in
##'
##' We map shape aesthetic to value type i.e., mean, median etc.
##' This function defines a shape palette that can be used in forest
##' plots
##' @param x a list of parameters
##' @return a named list of shapes where names are value types (mean,
##' median, std dev etc.)
##'
##' @author Sangeeta Bhatia
value_type_palette <- function(x) {

  out <- list(
    Mean = 16,
    mean = 16,
    average = 16,
    Median = 15,
    median = 15,
    `Std Dev` = 17,
    `std dev` = 17,
    sd = 17,
    other = 18,
    Other = 18
  )
  ## if x is missing, return the whole palette
  if (missing(x)) {
    return(out)
  }
  out[x]
}

##' Define a consistent color palette for use in
##' figures. Palettes are currently defined for
##' parameters and countries. Any other variable will
##' return NULL
color_palette <- function(col_by = c("parameter", "country"), ...) {
  match.arg(col_by)
  other_args <- list(...)
  if (col_by == "parameter") {
    col_palette <- parameter_palette(other_args)
  } 
  if (col_by == "country") {
    col_palette <- country_palette(other_args)
  }
  col_palette
}

## Synonym for color_palette
colour_palette <- function(col_by = c("parameter", "country"), ...) {
  color_palette(col_by, ...)
}

#' shape_palette function
#'
#' This function generates a shape palette based on the specified shape_by parameter.
#'
#' @param shape_by A character vector specifying the parameter to shape the palette by.
#'   Currently, only "value_type" is supported.
#' @param ... Additional arguments to be passed to the underlying palette function.
#'
#' @return A shape palette based on the specified shape_by parameter.
#'
#' @examples
#' shape_palette("value_type")
#'
#' @export
shape_palette <- function(shape_by = c("value_type"), ...) {
  match.arg(shape_by)
  other_args <- list(...)
  if (shape_by == "value_type") {
    shape_palette <- value_type_palette(other_args)
  }
  shape_palette
}