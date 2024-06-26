## This function is a wrapper around the forest_plot function in forest_plot.R
## It will 
## 1. filter the data frame to only include estimates of effective reproduction number; 
## 2. order the studies (see details); 
## 3. rename or create columns required by forest_plot; 
## 5. set sensible axis limits, and  give nice labels
## to axis.
#' Generate a forest plot for effective reproduction number (Rt)
#'
#' This function generates a forest plot for the effective reproduction number 
#' (Rt) using the provided data frame.
#'
#' @param df The data frame containing the necessary data for generating the 
#' forest plot.
#' @param ulim The upper limit for the x-axis of the plot. Default is 10.
#' @param reorder_studies Logical. If TRUE, the studies will be reordered using
#' the \code{\link{reorder_studies}} function. Default is TRUE.
#' @param ... Additional arguments to be passed to the 
#' \code{\link{forest_plot}} function.
#'
#' @return A ggplot2 object representing the forest plot for effective 
#' reproduction number (Rt).
#'
#' @importFrom ggplot2 scale_x_continuous geom_vline labs theme element_blank
#'
#' @examples
#' df <- load_epidata("ebola")[["params"]]
#' forest_plot_rt(df)
#'
#' @export
forest_plot_rt <- function(df, ulim = 10, reorder_studies = TRUE, ...) {
  
  rt <- df[df$parameter_type == "Reproduction number (Effective, Re)", ]
  check_ulim(rt, ulim, "effective reproduction number")
  p <- forest_plot_rt_int(rt, ulim, reorder_studies, ...) + 
  labs(x = "Effective reproduction number (R)")
  p
}

#' forest_plot_r0 function
#'
#' This function generates a forest plot for the reproduction number (Basic R0) 
#' using the provided data frame.
#' @inheritParams forest_plot_rt
#' @inheritDotParams forest_plot_rt
#'
#' @return ggplot2 object.
#'
#' @examples
#' df <- load_epidata("ebola")[["params"]]
#' forest_plot_r0(df, ulim = 2.5, reorder_studies = TRUE)
#'
#' @export
forest_plot_r0 <- function(df, ulim = 10, reorder_studies = TRUE, ...) {
  
  rt <- df[df$parameter_type == "Reproduction number (Basic R0)", ]
  check_ulim(rt, ulim, "basic reproduction number")
  p <- forest_plot_rt_int(rt, ulim, reorder_studies, ...) + 
  labs(x = "Basic reproduction number (R0)")
  p
}

## Internal function; not exported
##' @importFrom scales squish
forest_plot_rt_int <- function(rt_r0, ulim, reorder_studies, ...) {
  rt_r0 <- reparam_gamma(rt_r0)
  rt_r0 <- param_pm_uncertainty(rt_r0)

  if (reorder_studies) rt_r0 <- reorder_studies(rt_r0)
  p <- forest_plot(rt_r0, ...)
  p <- p +       
    scale_x_continuous(
      limits = c(0, ulim), expand = c(0, 0), oob = scales::squish,
      breaks = seq(0, ulim, by = 1)
     ) +
    geom_vline(xintercept = 1, linetype = "dashed", colour = "dark grey")
  
  p
}