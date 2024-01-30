## This function is a wrapper around the forest_plot function in forest_plot.R
## It will 
## 1. filter the data frame to only include estimates of effective reproduction number; 
## 2. order the studies (see details); 
## 3. rename or create columns required by forest_plot; 
## 5. set sensible axis limits, and  give nice labels
## to axis.
#' Generate a forest plot for effective reproduction number (Rt)
#'
#' This function generates a forest plot for the effective reproduction number (Rt) using the provided data frame.
#'
#' @param df The data frame containing the necessary data for generating the forest plot.
#' @param ulim The upper limit for the x-axis of the plot. Default is 10.
#' @param ... Additional arguments to be passed to the \code{\link[forestplot]{forest_plot}} function.
#'
#' @return A ggplot2 object representing the forest plot for effective reproduction number (Rt).
#'
#' @importFrom ggplot2 scale_x_continuous geom_vline labs theme element_blank
#'
#' @examples
#' df <- data.frame(
#'   article_label = c("Study A", "Study B", "Study C"),
#'   parameter_type = c("Effective (Re)", "Effective (Re)", "Effective (Re)"),
#'   estimate = c(1.5, 2.0, 1.8),
#'   lower_limit = c(1.2, 1.7, 1.5),
#'   upper_limit = c(1.8, 2.3, 2.1)
#' )
#' forest_plot_rt(df)
#'
#' @export
forest_plot_rt <- function(df, ulim = 10, ...) {
  
  rt <- df[df$parameter_type == "Reproduction number (Effective, Re)", ]
  p <- forest_plot_rt_int(rt, ulim, ...) + 
  labs(x = "Effective reproduction number (R)")
  p
}

forest_plot_r0 <- function(df, ulim = 10, ...) {
  
  rt <- df[df$parameter_type == "Reproduction number (Basic R0)", ]
  p <- forest_plot_rt_int(rt, ulim, ...) + 
  labs(x = "Basic reproduction number (R0)")
  p
}

## Internal function; not exported
forest_plot_rt_int <- function(rt_r0, ulim, ...) {
  rt_r0 <- param_pm_uncertainty(rt_r0)
  rt_r0 <- reorder_studies(rt_r0)
  p <- forest_plot(rt_r0, ...)
  p <- p +       
    scale_x_continuous(limits = c(0, ulim), expand = c(0, 0), oob = scales::squish) +
    geom_vline(xintercept = 1, linetype = "dashed", colour = "dark grey")
  p <- p + theme(axis.title.y = element_blank())
  p
}