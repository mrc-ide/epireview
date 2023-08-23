#' Create forest plot for genetic mutations
#'
#' @param df processed data with parameter information produced using
#' data_forest_plots()
#' @return returns plot with a summary of genetic mutations
#' @importFrom dplyr filter mutate arrange group_by desc if_else
#' @importFrom ggplot2 geom_vline xlim
#' @importFrom stats setNames
#' @examples
#' df = data_forest_plots(pathogen = "marburg", exclude = c(15, 17))
#' forest_plot_mutations(df = df)
#' @export
forest_plot_mutations <- function(df) {

  parameter <- "Mutations"

  # Deal with R CMD Check "no visible binding for global variable"
  parameter_class <- parameter_value <- parameter_type <- genome_site <-
    gene <- parameter_uncertainty_single_value <- article_label_unique <-
    parameter_data_id <- parameter_uncertainty_lower_value <-
    parameter_uncertainty_upper_value <- NULL

  df_mutations <- df %>%
    filter(parameter_class == parameter) %>%
    mutate(parameter_value = as.numeric(parameter_value)) %>%
    group_by(parameter_type)

  df_plot <- df_mutations %>%
    filter(parameter_class == parameter) %>%
    mutate(parameter_value = as.numeric(parameter_value)) %>%
    group_by(parameter_type)

  df_plot$article_label_unique <- make.unique(df_plot$article_label)
  df_plot <- df_plot %>%
    mutate(gene = ifelse(is.na(genome_site) == TRUE,
                         "Whole genome", genome_site)) %>%
    arrange(gene, desc(parameter_value))
  df_plot$article_label_unique <- factor(df_plot$article_label_unique,
                                         levels = df_plot$article_label_unique)
  df_plot <- df_plot %>%
    mutate(parameter_value = if_else(parameter_value > 1e-02,
                                     parameter_value * 1e-04, parameter_value),
           parameter_uncertainty_single_value =
             if_else(parameter_uncertainty_single_value > 1e-02,
                     parameter_uncertainty_single_value * 1e-04,
                     parameter_uncertainty_single_value))

  plot <- ggplot(df_plot,
                 aes(x = (parameter_value * 1e04), y = article_label_unique,
                     col = gene)) +
    theme_bw() +
    geom_point(size = 3) +
    geom_vline(xintercept = 0, color = "black", linetype = "dashed") +
    scale_y_discrete(labels = setNames(df_plot$article_label,
                                       df_plot$article_label_unique)) +
    geom_segment(
      aes(y = article_label_unique,
          yend = article_label_unique,
          x = if_else(
            (parameter_value -
               parameter_uncertainty_single_value) * 1e04 < 0, 0,
            (parameter_value - parameter_uncertainty_single_value) * 1e04),
          xend = (parameter_value + parameter_uncertainty_single_value) * 1e04,
          group = parameter_data_id),
                 lwd = 5,
                 alpha = 0.4) +
    geom_errorbar(aes(y = article_label_unique,
                      xmin = parameter_uncertainty_lower_value * 1e04,
                      xmax = parameter_uncertainty_upper_value * 1e04,
                      group = parameter_data_id),
                  width = 0.3,
                  lwd = 1) +
    labs(x = expression(Molecular~evolutionary~rate~
                          (substitution/site/year~10^{-4})),
         y = "",
         linetype = "",
         colour = "",
         caption =
           "*Solid transparent lines are calculated as the parameter value
         \u00B1 standard error. Error bars refer to uncertainty intervals.") +
    theme(legend.text = element_text(size = 12),
          strip.text = element_text(size = 20)) +
    xlim(c(0, 10)) +
    scale_color_brewer(palette = "Dark2",
                       labels = function(x) str_wrap(x, width = 10)) +
    guides(colour = guide_legend(order = 1, ncol = 1))

  return(plot)
}
