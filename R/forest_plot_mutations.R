#' Create forest plot for genetic mutations
#'
#' @param df data with outbreak information
#' @return returns flextable
#' @examples
#'
#' @export
forest_plot_mutations <- function(df){

  parameter <- "Mutations"

  df_mutations <- df %>%
    dplyr::filter(parameter_class == parameter) %>%
    dplyr::mutate(parameter_value = as.numeric(parameter_value)) %>%
    dplyr::group_by(parameter_type)

  df_plot <- df_mutations %>%
    dplyr::filter(parameter_class == parameter) %>%
    dplyr::mutate(parameter_value = as.numeric(parameter_value)) %>%
    dplyr::group_by(parameter_type) #%>% ### median function not behaving in ggplot so going with this even with grouping
  # mutate(median = median(parameter_value,na.rm=TRUE))

  df_plot$article_label_unique <- make.unique(df_plot$article_label)
  df_plot <- df_plot %>%
    dplyr::mutate(gene = ifelse(is.na(genome_site)==TRUE, "Whole genome", genome_site))  %>%
    dplyr::arrange(gene, desc(parameter_value))
  df_plot$article_label_unique <- factor(df_plot$article_label_unique, levels = df_plot$article_label_unique)
  df_plot <- df_plot %>%
    dplyr::mutate(parameter_value = if_else(parameter_value > 1e-02, parameter_value * 1e-04, parameter_value),
                  parameter_uncertainty_single_value = if_else(parameter_uncertainty_single_value > 1e-02, parameter_uncertainty_single_value * 1e-04, parameter_uncertainty_single_value))


  # df_plot <- df_plot %>%
  #   dplyr::mutate(parameter_type = ifelse(article_label == "Suzuki 1997", "Mutations - substitution rate",
  #                                         parameter_type))

  plot <-
    ggplot(df_plot, aes(x=(parameter_value * 1e04), y=article_label_unique,
                        col = gene)) +
    theme_bw() + geom_point(size = 3) +
    geom_vline(xintercept = 0, color = 'black', linetype = 'dashed') +
    # facet_grid(gene ~ ., scales = "free_y", space = "free") +
    scale_y_discrete(labels=setNames(df_plot$article_label, df_plot$article_label_unique)) +
    geom_segment(aes(y=article_label_unique, yend = article_label_unique,
                     x=if_else((parameter_value - parameter_uncertainty_single_value)* 1e04 < 0, 0,
                               (parameter_value - parameter_uncertainty_single_value)* 1e04),
                     xend=(parameter_value + parameter_uncertainty_single_value)* 1e04,
                     group=parameter_data_id),
                 # linetype="Value \u00B1 standard error *"),
                 lwd=5,
                 alpha = 0.4) +
    geom_errorbar(aes(y=article_label_unique,
                      xmin=parameter_uncertainty_lower_value* 1e04,
                      xmax=parameter_uncertainty_upper_value* 1e04,
                      group=parameter_data_id),
                  # linetype="Uncertainty interval"),
                  width = 0.3,
                  lwd=1) +
    labs(x=expression(Molecular~evolutionary~rate~(substitution/site/year ~10^{-4})),
         y="",#y="Study",
         linetype="",colour="",
         caption = '*Solid transparent lines are calculated as the parameter value \u00B1 standard error. Error bars refer to uncertainty intervals.') +
    # scale_linetype_manual(values = c("dotted","solid"),labels = function(x) str_wrap(x, width = 18)) + #+ scale_x_log10()
    #geom_vline(xintercept = 0, linetype = "dotted", colour = "dark grey") +
    theme(legend.text = element_text(size=12),
          strip.text = element_text(size=20)) + xlim(c(0,10)) +
    scale_color_brewer(palette = 'Dark2',labels = function(x) str_wrap(x, width = 10)) +
    guides(colour = guide_legend(order=1,ncol=1)   )

  return(plot)
}
