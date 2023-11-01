#' Create forest plot for human delays
#'
#' @param df processed data with human delay information produced using
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
forest_plot_delay <- function(df) {

  parameter <- "Human delay"

  # Deal with R CMD Check "no visible binding for global variable"
  parameter_class <- parameter_type <- parameter_type_short <-
    article_label <- riskfactor_outcome <- first_author_surname <-
    parameter_value <- article_label_unique <- parameter_value_type <-
    parameter_lower_bound <- parameter_upper_bound <-
    parameter_data_id <- parameter_uncertainty_lower_value <-
    parameter_uncertainty_upper_value <- NULL

  df_plot <- df %>%
    filter(parameter_class == parameter) %>%
    mutate(parameter_type_short =
             gsub("^Human delay - ", "", parameter_type)) %>%
    mutate(
      parameter_type_short = ifelse(
        parameter_type_short == "time symptom to outcome" &
          riskfactor_outcome == "Death", "Time symptom to outcome (Death)",
        ifelse(
          parameter_type_short == "time symptom to outcome" &
            riskfactor_outcome == "Other", "Time symptom to outcome (Other)",
          parameter_type_short))) %>%
    mutate(parameter_type_short = str_to_sentence(parameter_type_short)) %>%
    mutate(median = median(parameter_value, na.rm = TRUE)) %>%
    group_by(parameter_type_short) %>%
    arrange(first_author_surname) %>%
    arrange(desc(parameter_type_short),
            desc(parameter_value),
            desc(article_label))

  # Make unique article labels
  df <- add_unique_labels(df)

  plot <- ggplot(df_plot, aes(col = parameter_type_short)) +
    geom_point(aes(x = parameter_value,
                   y = article_label_unique,
                   shape = parameter_value_type), size = 3.5) +
    geom_segment(aes(y = article_label_unique, yend = article_label_unique,
                     x = parameter_lower_bound, xend = parameter_upper_bound,
                     group = parameter_data_id), lwd = 5, alpha = 0.4) +
    geom_errorbar(aes(y = article_label_unique,
                      xmin = parameter_uncertainty_lower_value,
                      xmax = parameter_uncertainty_upper_value,
                      group = parameter_data_id), width = 0.4, lwd = 1) +
    scale_y_discrete(labels = setNames(df_plot$article_label,
                                       df_plot$article_label_unique)) +
    scale_x_continuous(breaks = c(seq(0, 60, by = 10))) +
    scale_color_brewer(palette = "Dark2",
                       labels = function(x) str_wrap(x, width = 18)) +
    scale_shape_manual(values = c(16, 15, 17, 18),
                       labels = c("Mean", "Median", "Std Dev", "Other"),
                       na.translate = FALSE) +
    labs(x = "Delay (days)",
         y = "",
         linetype = "",
         colour = "",
         shape = "",
         caption = "*Solid transparent rectangles refer to parameter ranges
         while the error bars are uncertainty intervals.") +
    guides(colour = guide_legend(order = 1, ncol = 1),
           linetype = guide_legend(order = 2, ncol = 1))


  return(plot)
}
