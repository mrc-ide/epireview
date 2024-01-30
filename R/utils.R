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
#' This function returns a color palette for countries.
#'
#' @param x A vector of country names. If provided, the function will return a color palette for the specified countries.
#' @return A color palette for the specified countries.
#' @examples
#' # Get color palette for all countries
#' country_palette()
#'
#' # Get color palette for specific countries
#' country_palette(c('Liberia', 'Guinea', 'Sierra Leone'))
#'
#' @importFrom paletteer paletteer_d
#' @importFrom pals polychrome
#'
#' @export
country_palette <- function(x) {
  pal <- paletteer::paletteer_d("pals::polychrome")
  class(pal) <- NULL
  countries <- c(
    'Liberia', 'Guinea', 'Sierra Leone', 'Nigeria', 'Senegal', 'Mali',
    'DRC', 'Gabon', 'Uganda', 'South Sudan', 'Kenya', 'Ethiopia',
    'Cameroon', 'Central African Republic', 'Republic of the Congo',
    'Sudan', 'Chad', 'Benin', 'Togo', 'Ghana', 'Burkina Faso', 'Ivory Coast',
    'Equatorial Guinea', 'Angola', 'South Africa', 'Zambia', 'Tanzania',
    'Djibouti', 'Somalia', 'Mozambique', 'Madagascar', 'Malawi', 'Zimbabwe',
    'United Kingdom', 'Unspecified'
  )
  if (missing(x) | length(x) == 0) {
    x <- countries
  } else {
    if (length(x) > length(pal)) {
      stop(paste0("More than", length(pal)," countries provided. Please provide a vector of length", length(pal)," or less"))
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
      stop(paste0("Pre-defined palette has only ", n_colrs, " colors. Please provide a vector of length ", n_colrs, " or less"))
    }
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
  n_shapes <- length(unique(out))
  shapes <- unique(out)
  if (missing(x) | length(x) == 0) {
    x <- names(out)
  } else {
    if (length(x) < n_shapes) {
      out <- shapes[seq_along(x)]
      names(out) <- x
    } else {
      stop(paste0("Pre-defined palette has only ", n_shapes, " shapes. Please provide a vector of length ", n_shapes, " or less"))
    }
  }
  out[x]
}

##' Define a consistent color palette for use in
##' figures. Palettes are currently defined for
##' parameters and countries. Any other variable will
##' return NULL
##' @param col_by a character vector specifying the parameter to color the palette by.
##' @param ... additional arguments to be passed to the underlying palette function.
##' These are treated as names of the palette elements.
##' @return a named list of colors that can be used in forest plots for manually setting colors
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
#' shape_palette("value_type")
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

#' Update parameter uncertainty columns in a data frame
#'
#' This function updates the parameter uncertainty columns in a data frame
#' when the uncertainty is given by a single value (standard deviation or
#' standard error). It creates new columns called `low' (parameter central
#' value - uncertainty) and `high' (parameter central value + uncertainty).
#' These columns are used by \code{\link{forest_plot}} to plot the
#' uncertainty intervals.
#' 
#' @param df A data frame containing the parameter uncertainty columns.
#' This will typically be the output of \code{\link{load_epidata}}.
#' @return The updated data frame with parameter uncertainty columns
#'
#' @examples
#' df <- data.frame(
#'   parameter_value = c(10, 20, 30),
#'   parameter_uncertainty_single_value = c(1, 2, 3),
#'   parameter_uncertainty_lower_value = c(5, 15, 25),
#'   parameter_uncertainty_upper_value = c(15, 25, 35),
#'   parameter_uncertainty_type = c(NA, NA, NA),
#'   parameter_uncertainty_singe_type = c("Standard Deviation", "Standard Error", NA)
#' )
#' updated_df <- param_pm_uncertainty(df)
#' updated_df
#'
#' @export
param_pm_uncertainty <- function(df) {
  df$parameter_uncertainty_type <- ifelse(
    is.na(df$parameter_uncertainty_type) &
      df$parameter_uncertainty_singe_type == "Standard Deviation",
    "Standard Deviation",
    ifelse(
      is.na(df$parameter_uncertainty_type) &
        df$parameter_uncertainty_singe_type == "Standard Error",
      "Standard Error",
      df$parameter_uncertainty_type
    )
  )
  df$mid <- df$parameter_value
  df$low <- ifelse(
    df$parameter_uncertainty_type %in% c("Standard Deviation", "Standard Error"),
    df$parameter_value - df$parameter_uncertainty_single_value,
    df$parameter_uncertainty_lower_value
  )
  df$high <- ifelse(
    df$parameter_uncertainty_type %in% c("Standard Deviation", "Standard Error"),
    df$parameter_value + df$parameter_uncertainty_single_value,
    df$parameter_uncertainty_upper_value
  )
  df
}