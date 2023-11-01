#' Create forest plot for reproduction numbers
#'
#' @param df processed data with parameter information produced using
#' prep_data_forest_plots()
#' @return returns plot with a summary of reproduction number estimates
#' @importFrom dplyr filter arrange mutate group_by
#' @importFrom ggplot2 aes theme_bw geom_point scale_y_discrete
#' scale_x_continuous geom_segment geom_errorbar labs scale_color_brewer
#' scale_shape_manual theme guides element_text guide_legend position_dodge
#' scale_linetype_manual scale_colour_manual xlim
#' @importFrom stats median
#' @examples
#' df = data_forest_plots(pathogen = "marburg", exclude = c(15, 17))
#' forest_plot_r(df = df)
#' @export
forest_plot_r <- function(df) {

  parameter <- "Reproduction number"

  # Deal with R CMD Check "no visible binding for global variable"
  parameter_value <- parameter_type <- first_author_surname <-
    parameter_class <- article_label_unique <- parameter_type_short <-
    article_label <- parameter_uncertainty_lower_value <-
    parameter_uncertainty_upper_value <- parameter_data_id <- NULL

  df_plot <- df %>%
    filter(parameter_class == parameter) %>%
    mutate(median = median(parameter_value, na.rm = TRUE)) %>%
    group_by(parameter_type) %>%
    arrange(first_author_surname) %>%
    mutate(parameter_type_short =
             ifelse(parameter_type ==
                      "Reproduction number (Basic R0)",
                    "Basic (R0)",
                    ifelse(parameter_type ==
                             "Reproduction number (Effective, Re)",
                           "Effective (Re)", NA)))

  plot <- ggplot(df_plot, aes(x = parameter_value,
                              y = article_label_unique,
                              col = parameter_type_short)) +
    geom_errorbar(aes(y = article_label,
                      xmin = parameter_uncertainty_lower_value,
                      xmax = parameter_uncertainty_upper_value,
                      group = parameter_data_id,
                      linetype = "Uncertainty interval"),
                  position = position_dodge(width = 0.5),
                  width = 0.2,
                  lwd = 1) +
    geom_point(aes(x = parameter_value,
                   y = article_label,
                   group = parameter_data_id),
               size = 3) +
    geom_vline(xintercept = 1, linetype = "dashed", colour = "dark grey") +
    labs(x = "Reproduction number", y = "", linetype = "", colour = "") +
    scale_linetype_manual(values = c("solid"),
                          labels = function(x) str_wrap(x, width = 5)) +
    scale_colour_manual(values = c("#D95F02", "#7570B3")) +
    xlim(c(0, 2)) +
    guides(colour = guide_legend(order = 1, ncol = 1),
           linetype = guide_legend(order = 2, ncol = 1))

  return(plot)
}
