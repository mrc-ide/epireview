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
#' @param shp_palette (Optional) Palette for shaping the points. Optional unless shape_by is
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
 
  ## ggplot2 will put all article labels on the y-axis
  ## even if mid, low, and high are NA. We will filter them out
  ## here to avoid that.
  ## We want at least one of mid, low, or high to be non-NA
  ## for each row
  rows <- apply(df, 1, function(x) {
    any(!is.na(x[c("mid", "low", "high")]))
  }, simplify = TRUE)
  df <- df[rows, ]
  ## We don't want to plot rows where mid_type is "Range midpoint" or 
  ## "Uncertainty width".
  df$mid[df$mid_type %in% c("Range midpoint")] <- NA
    
  ## uncertainty_type was created by us in param_pm_uncertainty
  ## so the user has no visibility of this variable. The main thing
  ## is that we want to distinguish Range** which is slightly different
  ## from the other types of uncertainty
  uc_types <- unique(df$uncertainty_type)
  lty_map <- rep("solid", length(uc_types))
  names(lty_map) <- uc_types
  lty_map[["Range**"]] <- "dotted"
  ## note that if you use dashed linetype here, then the legend only shows
  ## a single dash, which is of course indisguishable from a solid line.

  p <- ggplot(df) +
    geom_point(aes(x = .data[['mid']], y = .data[['article_label']])) +
    geom_errorbar(
      aes(xmin = .data[['low']], xmax = .data[['high']], y = .data[['article_label']],
          lty = .data[['uncertainty_type']])
    ) +
    scale_linetype_manual(values = lty_map, breaks = "Range**") +
    ##scale_y_discrete(breaks = df$article_label, labels = df$article_label) + 
    theme_epireview()
  
  p <- p + theme(axis.title.y = element_blank())

  if (!is.na(facet_by)) {
    p <- p + facet_col(
      ~.data[[facet_by]], scales = "free_y", space = "free"
    ) 
  }

  if (!is.na(shape_by)) {
    p <- p + aes(shape = .data[[shape_by]])
    ## use the palette if provided, otherwise use the default
    ## as defined in epireview
    ## if neither is provided, use the default palette
    if (!is.na(shp_palette)) {
      p <- p + scale_shape_manual(values = shp_palette)
    } else {
      shp_palette <- shape_palette(shape_by)
      if (! is.null(shp_palette)) {
        p <- p + scale_shape_manual(values = shp_palette)
      } else {
        ## if no palette is found, use the default and issue a warning
        warning(paste("No palette was provided or found for ", shape_by, ". 
          Using default palette"))
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
        warning(paste("No palette was provided or found for ", col_by, ". 
        Using default palette"))
      }
      
    }
  }
  p

}
