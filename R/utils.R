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

##' Define a consistent color palette for use in
##' figures
##'
##'
##' @param x a list of parameters
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

  out[x]
}
