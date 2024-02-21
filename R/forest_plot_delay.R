#' Create forest plot for human delays
#' @details There are a number of 'delays' that are relevant to the pathogens
#' we study. Some of the more commonly, and hence likely to be extracted for 
#' most pathogens, are the infectious period, the incubation period, and the
#' serial interval. However, there are many others reported by relatively few
#' studies or relevant to only a few pathogens. Hence this function is intended
#' to serve as a template for creating forest plots for these delays. It will 
#' carry out pre-processing tasks we expect to be common to all such forest
#' plots. These are described in details below.
#' 1. Check that all parameters have the same units (days) and warn the user if
#' this is not the case.
#' 2. Deal with most common unit conversions (e.g. weeks to days, months to days)
#' and with inverse parameters (e.g. rate to period).
#' 3. Reparameterise delays reported using gamma distributions.
#' We also provide some utility functions for the commonly used delays that are
#' simply syntactic sugar for this function. If however you are interested in 
#' some other delay, you will need to use this function directly, ensuring that
#' the data frame you provide has only the relevant delays.
#' @inheritParams forest_plot_rt
#' @seealso \code{\link{forest_plot_rt}}
#' prep_data_forest_plots()
#' @return returns plot with a summary of the human delays
#' @importFrom dplyr filter mutate group_by arrange desc
#' @importFrom stringr str_to_sentence str_wrap
#' @importFrom ggplot2 aes theme_bw geom_point scale_y_discrete
#' scale_x_continuous geom_segment geom_errorbar labs scale_color_brewer
#' scale_shape_manual theme guides element_text guide_legend
#' @importFrom stats setNames median
#' @examples
#' df <- data_forest_plots(pathogen = "marburg", exclude = c(15, 17))
#' forest_plot_delay(df = df)
#' @export
forest_plot_delay <- function(df, ulim = 30, reorder_studies = TRUE, ...) {
}
