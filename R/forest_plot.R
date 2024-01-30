##' Basic forest plot
##'
##' Basic forest plot displays central estimate and uncertainty for a parameter from different studies.
##' y-axis lists the study labels and the x-axis displays parameter.
##'
#' Generates a forest plot.
#'
#' This function generates a forest plot using the provided data frame.
#'
#' @param df The data frame containing the data for the forest plot. data.frame with the following fields: article, label, mid, low, high
##' The field 'y' is mapped to the y-axis with 'article_label' used as a display label.
##' mid refers to the central estimate. low and high represent the lower and higher ends of the
##' uncertainty interval
#' @param facet_by (Optional) Variable to facet the plot by.
#' @param shape_by (Optional) Variable to shape the points by.
#' @param col_by (Optional) Variable to color the points by.
#' @param shape_palette (Optional) Palette for shaping the points. Optional unless shape_by is
#' not one of 'parameter_value_type'.
#' @param col_palette Palette for coloring the points. Optional unless col_by is
#' not one of 'parameter_type' or 'population_country'.
#' @importFrom ggforce facet_col
#' @details epireview provides a default palette for parameters and countries.
#' If you wish to color by a different variable, you must provide a palette.
#' @return A ggplot2 object representing the forest plot.
#' @import ggplot2
#' @export 
#' @examples
#' df <- data.frame(
#'   mid = c(1, 2, 3),
#'   y = c("A", "B", "C"),
#'   low = c(0.5, 1.5, 2.5),
#'   high = c(1.5, 2.5, 3.5)
#' )
#' forest_plot(df)
forest_plot <- function(df, facet_by = NA, shape_by = NA, col_by = NA,
    shp_palette = NA, 
    col_palette = NA) {

  p <- ggplot(df) +
    geom_point(aes(x = .data[['mid']], y = .data[['y']])) +
    geom_errorbar(
      aes(xmin = .data[['low']], xmax = .data[['high']], y = .data[['y']])
    ) +
    geom_segment(
      aes(x = .data[['low']], xend = .data[['high']], y = .data[['y']], yend = .data[['y']])
    ) + scale_y_discrete(
      breaks = df$y,
      labels = df$y
    ) + theme_epireview()


  if (!is.na(facet_by)) {
    p <- p + facet_col(
      ~.data[[facet_by]], scales = "free_y", space = "free"
    ) 
  }

  if (!is.na(shape_by)) {
    p <- p + aes(
      shape = .data[[shape_by]]
    )
    ## use the palette if provided, otherwise use the default
    ## as defined in epireview
    ## if neither is provided, use the default palette
    if (!is.na(shp_palette)) {
      p <- p + scale_shape_manual(values = shp_palette)
    } else {
      shp_palette <- shape_palette(shape_by)
      if (! is.null(shape_palette)) {
        p <- p + scale_shape_manual(values = shp_palette)
      } else {
        ## if no palette is found, use the default and issue a warning
        warning(paste("No palette was provided or found for ", shape_by, ". Using default palette"))
      }
     
      
    }   
  }

  if (!is.na(col_by)) {
    p <- p + aes(col = .data[[col_by]])
    ## use the palette if provided, otherwise use the default
    ## as defined in epireview
    ## if neither is provided, use the default palette
    if (!is.na(col_palette)) {
      p <- p + scale_color_manual(values = col_palette)
    } else {
      col_palette <- color_palette(col_by)
      if (! is.null(col_palette)) {
        p <- p + scale_color_manual(values = col_palette)
      } else {
        ## if the palette is not found, use the default and issue a warning
        warning(paste("No palette was provided or found for ", col_by, ". Using default palette"))
      }
      
    }
  }
  p

}
