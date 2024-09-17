#' Plotting theme for epireview
#' A standard theme for figures in epireview.
#' @inheritParams ggplot2::theme_bw
#' @export
theme_epireview <- function(
  base_size = 11,
  base_family = "",
  base_line_size = base_size / 22,
  base_rect_size = base_size / 22
) {
  update_geom_defaults("point", list(size = 3))
  update_geom_defaults("segment", list(lwd = 3, alpha = 0.4))
  update_geom_defaults("errorbar", list(lwd = 0.5, width = 0.4))
  th <- theme_bw(base_size, base_family, base_line_size, base_rect_size)
  th <- th + theme(
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5),
    plot.margin = margin(10, 20, 10, 20),
    panel.grid.minor = element_blank(),
    panel.spacing = unit(1.5, "lines"),
    legend.position = "bottom",
    legend.title = element_blank()
  )
  th
}

#' country_palette Function
#'
#' This function returns a color palette for countries.
#'
#' @param x A vector of country names. If provided, the function will return a
#' color palette for the specified countries.
#' @return A color palette for the specified countries.
#' @examples
#' # Get color palette for all countries
#' country_palette()
#'#' # Get color palette for specific countries
#' country_palette(c('Liberia', 'Guinea', 'Sierra Leone'))
#'
#' @importFrom cli cli_abort
#'
#' @export
country_palette <- function(x = NULL) {
  # Custom palette uses first 36 colours from
  # paletteer::paletteer_d("ggsci::default_igv")[1:36]. Declared manually to
  # reduce dependencies
  pal <- c("#5050FFFF", "#CE3D32FF", "#749B58FF", "#F0E685FF",
           "#466983FF", "#BA6338FF", "#5DB1DDFF", "#802268FF",
           "#6BD76BFF", "#D595A7FF", "#924822FF", "#837B8DFF",
           "#C75127FF", "#D58F5CFF", "#7A65A5FF", "#E4AF69FF",
           "#3B1B53FF", "#CDDEB7FF", "#612A79FF", "#AE1F63FF",
           "#E7C76FFF", "#5A655EFF", "#CC9900FF", "#99CC00FF",
           "#A9A9A9FF", "#CC9900FF", "#99CC00FF", "#33CC00FF",
           "#00CC33FF", "#00CC99FF", "#0099CCFF", "#0A47FFFF",
           "#4775FFFF", "#FFC20AFF", "#FFD147FF", "#990033FF")

  countries <- c(
    'Liberia', 'Guinea', 'Sierra Leone', 'Nigeria', 'Senegal', 'Mali',
    'DRC', 'Gabon', 'Uganda', 'South Sudan', 'Kenya', 'Ethiopia',
    'Cameroon', 'Central African Republic', 'Republic of the Congo',
    'Sudan', '
    Chad', 'Benin', 'Togo', 'Ghana', 'Burkina Faso', 'Ivory Coast',
    'Equatorial Guinea', 'Angola', 'South Africa', 'Zambia', 'Tanzania',
    'Djibouti', 'Somalia', 'Mozambique', 'Madagascar', 'Malawi', 'Zimbabwe',
    'United Kingdom', 'Unspecified'
  )
  if (missing(x) | length(x) == 0) {
    x <- countries
  } else {
    if (length(x) > length(pal)) {
      cli_abort(paste0("More than", length(pal)," countries provided. Please provide
        a vector of length", length(pal)," or less"))
    } else {
      pal <- pal[1:length(x)]
    }
  }
  names(pal) <- x
  pal[x]
}

##' Define a consistent color palette for use in
##' figures
##'
##' @param x a list of parameters. Optional. If missing, the entire
##' palette is returned.
##' @return a named list of colors that can be used
##' in forest plots for manually setting colors
##' with for example
##' \code{\link[ggplot2:scale_color_manual]{scale_color_manual}}
##' @importFrom cli cli_abort
##' @author Sangeeta Bhatia
parameter_palette <- function(x) {
  out <- list(
    "Basic (R0)" = "#D95F02",
    "Reproduction number (Basic R0)" = "#D95F02",
    "Effective (Re)" = "#7570B3",
    "Reproduction number (Effective, Re)" = "#7570B3"
  )
  n_colrs <- length(unique(out))
  colrs <- unique(out)
  if (missing(x) | length(x) == 0) {
    x <- names(out)
  } else {
    if (length(x) < n_colrs) {
      out <- colrs[seq_along(x)]
      names(out) <- x
    } else {
      cli_abort(
        paste0("Pre-defined palette has only ", n_colrs, " colors. Please
             provide a vector of length ", n_colrs, " or less")
      )
    }
  }
  out[x]
}

##' Define a consistent shape palette for use in forest plots
##'
##' We map shape aesthetic to value type i.e., mean, median etc.
##' This function defines a shape palette that can be used in forest
##' plots
##' @param x a list of parameters
##' @return a named list of shapes where names are value types (mean,
##' median, std dev etc.)
##'
##' @importFrom cli cli_abort
##' @author Sangeeta Bhatia
value_type_palette <- function(x = NULL) {
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
    Other = 18,
    Unspecified = 5,
    unspecified = 5
  )
  n_shapes <- length(unique(out))
  shapes <- unique(out)
  if (missing(x) | length(x) == 0) {
    x <- names(out)
  } else {
    if (length(x) < n_shapes) {
      out <- shapes[seq_along(x)]
      names(out) <- x
    } else {
      cli_abort(paste0("Pre-defined palette has only ", n_shapes, " shapes. Please
        provide a vector of length ", n_shapes, " or less"))
    }
  }
  out[x]
}

##' Define a consistent color palette for use in
##' figures. Palettes are currently defined for
##' parameters and countries. Any other variable will
##' return NULL
##' @param col_by a character vector specifying the parameter to color the
##' palette by.
##' @param ... additional arguments to be passed to the underlying palette
##' function.
##' These are treated as names of the palette elements.
##' @return a named list of colors that can be used in forest plots for manually
##' setting colors
##' @export
color_palette <- function(col_by = c("parameter_type", "population_country"), ...) {
  match.arg(col_by)
  other_args <- list(...)
  col_palette <- NULL
  if (col_by == "parameter_type") {
    col_palette <- parameter_palette(other_args)
  }
  if (col_by == "population_country") {
    col_palette <- country_palette(other_args)
  }
  col_palette
}

## Synonym for color_palette
colour_palette <- function(col_by = c("parameter_type", "population_country"), ...) {
  color_palette(col_by, ...)
}

#' shape_palette function
#'
#' This function generates a shape palette based on the specified shape_by parameter.
#'
#' @param shape_by A character vector specifying the parameter to shape the palette by.
#'   Currently, only "value_type" is supported.
#' @param ... Additional arguments to be passed to the underlying palette function.
#' These are treated as names of the palette elements.
#'
#' @return A shape palette based on the specified shape_by parameter.
#'
#' @examples
#' shape_palette("parameter_value_type")
#'
#' @export
shape_palette <- function(shape_by = c("parameter_value_type"), ...) {
  match.arg(shape_by)
  other_args <- list(...)
  shape_palette <- NULL
  if (shape_by == "parameter_value_type") {
    shape_palette <- value_type_palette(other_args)
  }
  shape_palette
}

#' Create a custom color palette.
#' @description This utility function creates a named color vector from user-supplied vectors of labels and color values.
#' The length of the label and color vectors must be the same.
#' The resulting custom color palette can be used as the color palette in other plotting functions.
#'
#' @param labels A vector of labels to be used as names for the custom color palette.
#' @param colors A vector of colors to be used for the custom color palette. This can be in the form of HEX codes, eg "#808080" or color names recognized by R, eg "deepskyblue"
#'
#' @return A custom palette in the form of a named color vector.
#'
#' @examples
#' labels <- c("Liberia", "Guinea", "Sierra Leone")
#' colors <- c("#5A5156FF", "#E4E1E3FF", "#5050FFFF")
#'
#'custom_pal <- custom_palette(labels, colors)
#'custom_pal
#'
#' @export
custom_palette <- function(labels, colors) {
  # An error will pop-up if the user supplies a different number of names or colors
  if (length(labels) != length(colors)) {
    stop(paste0("The number of colors supplied must match the number of different labels provided. You provided ", length(colors), " colors for ", length(labels), " labels. Please make sure that the vectors are of the same length."))
  }

  # Create the color vector
  color_vector <- colors
  names(color_vector) <- labels

  return(color_vector)
}
