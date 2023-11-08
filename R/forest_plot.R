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
forest_plot <- function(df) {

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
    )

  p

}
