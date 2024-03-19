#' Calculate and plot the forest plot for doubling time
#'
#' This function calculates the doubling time and creates a forest plot
#' to visualize the results.
#' @inheritParams forest_plot_delay_int
#'
#' @return A forest plot object.
#'
#' @examples
#' df <- data.frame(parameter_type = c("Doubling time", "Doubling time"),
#'                  value = c(5, 10))
#' forest_plot_doubling_time(df, ulim = 20, reorder_studies = TRUE)
#'
#' @export
forest_plot_doubling_time <- function(df, ulim = 30, reorder_studies = TRUE, ...) {
    
    x <- df[df$parameter_type %in% c("Doubling time"), ]
    check_ulim(x, ulim, "doubling time")
    p <- forest_plot_delay_int(x, ulim, reorder_studies, ...) +
        labs(x = "Doubling time (days)")
    p
}