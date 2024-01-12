##' Basic forest plot
##'
##' Basic forest plot displays central estimate and uncertainty for a parameter from different studies.
##' y-axis lists the study labels and the x-axis displays parameter.
##'
##' @param df data.frame with the following fields: article, label, mid, low, high
##' The field 'y' is mapped to the y-axis with 'label' used as a display label.
##' mid refers to the central estimate. low and high represent the lower and higher ends of the
##' uncertainty interval
##' @return ggplot2 object
##' @author Sangeeta Bhatia
forest_plot <- function(df, facet_by = NA, shape_by = NA, col_by = NA,
    shape_palette, 
    col_palette) {

  p <- ggplot(df) +
    geom_point(aes(x = mid, y = y)) +
    geom_errorbar(
      aes(xmin = low, xmax = high, y = y)
    ) +
    geom_segment(
      aes(x = low, xend = high, y = y, yend = y)
    ) + scale_y_discrete(
      breaks = df$y,
      labels = df$label
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
    if (!is.na(shape_palette)) {
      p <- p + scale_shape_manual(values = shape_palette)
    } else if (!is.na(shape_palette)) {
      shape_palette <- get_shape_palette(shape_by)
      if (! is.na(shape_palette)) {
        p <- p + scale_shape_manual(values = shape_palette)
      } else {
        warning(paste("No palette was provided or found for ", shape_by, ". Using default palette"))
      }
      ## if the palette is not found, use the default and issue a warning
      
    }   
  }

  if (!is.na(col_by)) {
    p <- p + aes(
      col = .data[[col_by]]
    )
    ## use the palette if provided, otherwise use the default
    ## as defined in epireview
    ## if neither is provided, use the default palette
    if (!is.na(col_palette)) {
      p <- p + scale_color_manual(values = col_palette)
    } else if (!is.na(col_palette)) {
      col_palette <- get_col_palette(col_by)
      if (! is.na(col_palette)) {
        p <- p + scale_color_manual(values = col_palette)
      } else {
        warning(paste("No palette was provided or found for ", col_by, ". Using default palette"))
      }
      ## if the palette is not found, use the default and issue a warning
      
    }
  }
  p

}
