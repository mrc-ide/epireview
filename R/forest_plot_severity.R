#' Create forest plot for severity
#'
#' @param df processed data with severity information produced using
#' prep_data_forest_plots()
#' @param outbreak_naive whether to use unadjusted case and death counts (TRUE)
#' or the adjusted case and death counts (FALSE). FALSE by default.
#' @return returns plot with a summary of IFR and CFR estimates
#' @importFrom dplyr filter arrange mutate group_by
#' @importFrom ggplot2 aes theme_bw geom_point scale_y_discrete
#' scale_x_continuous geom_segment geom_errorbar labs scale_color_brewer
#' scale_shape_manual theme guides element_text guide_legend
#' scale_linetype_manual position_dodge scale_colour_manual xlim
#' @importFrom stats setNames reorder
#' @examples
#' df = data_forest_plots(pathogen = "marburg", exclude = c(15, 17))
#' forest_plot_severity(df = df)
#' @export
forest_plot_severity <- function(df, outbreak_naive = FALSE) {

  parameter <- "Severity"

  # Deal with R CMD Check "no visible binding for global variable"
  keep_record <- parameter_class <- parameter_value <- parameter_type <-
    article_label <- cfr_ifr_method <- outbreak_start_year <-
    cfr_ifr_denominator <- outbreak_year_cnt <- article_label_unique <-
    order_num <- lower_ci <- upper_ci <- parameter_data_id <-
    parameter_uncertainty_lower_value <- parameter_lower_bound <-
    parameter_uncertainty_upper_value <- parameter_upper_bound <- p <- NULL

  if (outbreak_naive) {
    df <- df %>% filter(keep_record == 1)
  }

  # Make unique article labels
  df <- add_unique_labels(df)

  df_plot <- df %>%
    filter(parameter_class == parameter) %>%
    group_by(parameter_type) %>%
    arrange(article_label) %>%
    filter(is.na(parameter_value) == FALSE) %>%
    arrange((cfr_ifr_method))

  df_plot <- df_plot %>% mutate(order_num = seq(1, dim(df_plot)[1], 1))

  if (outbreak_naive) {
    df_plot2 <- df_plot %>%
      arrange(outbreak_start_year) %>%
      mutate(order_num = row_number(),
             p = parameter_value / 100,
             lower_ci = (p - 1.96 * (sqrt((p * (1 - p)) /
                                            cfr_ifr_denominator))) * 100,
             upper_ci = (p  + 1.96 * (sqrt((p * (1 - p)) /
                                             cfr_ifr_denominator))) * 100,
             outbreak_year_cnt = as.character(paste0(
               outbreak_year_cnt, " [n =", cfr_ifr_denominator, "]")))


    plot <- ggplot(df_plot2, aes(x = parameter_value,
                                 y = reorder(article_label_unique, -order_num),
                                 col = article_label)) +
      geom_point(size = 3) +
      scale_y_discrete(labels = setNames(df_plot2$outbreak_year_cnt,
                                         df_plot2$article_label_unique)) +
      geom_segment(aes(y = article_label_unique,
                       yend = article_label_unique,
                       x = lower_ci,
                       xend = upper_ci,
                       group = parameter_data_id),
                   lwd = 3,
                   alpha = 0.4) +
      theme(legend.position = "right") +
      scale_color_brewer(palette = "Dark2")
  } else {
    df_plot2 <- df_plot %>%
      arrange(article_label_unique) %>%
      mutate(order_num = row_number())

    plot <- ggplot(df_plot2, aes(x = parameter_value,
                                 y = reorder(article_label_unique, -order_num),
                                 col = cfr_ifr_method)) +
      geom_point(size = 3) +
      scale_y_discrete(labels = setNames(df_plot$article_label,
                                         df_plot$article_label_unique)) +
      geom_errorbar(aes(y = article_label_unique,
                        xmin = parameter_uncertainty_lower_value,
                        xmax = parameter_uncertainty_upper_value,
                        group = parameter_data_id,
                        linetype = "Uncertainty interval"),
                    position = position_dodge(width = 0.5),
                    width = 0.25,
                    lwd = 1) +
      geom_segment(aes(y = article_label_unique,
                       yend = article_label_unique,
                       x = parameter_lower_bound,
                       xend = parameter_upper_bound,
                       group = parameter_data_id),
                   lwd = 5,
                   alpha = 0.4) +
      scale_colour_manual(values = c("#D95F02", "#7570B3"))

  }

  plot <- plot +
    scale_linetype_manual(values = c("solid"),
                          labels = function(x) str_wrap(x, width = 5)) +
    geom_vline(xintercept = c(0, 100), linetype = "dotted") +
    scale_x_continuous(breaks = seq(-20, 120, by = 20)) +
    labs(x = "Case fatality ratio (%)",
         y = "",
         linetype = "",
         colour = "",
         fill = "") +
    guides(colour = guide_legend(order = 1, ncol = 1),
           linetype = guide_legend(order = 2, ncol = 1))

  return(plot)
}
