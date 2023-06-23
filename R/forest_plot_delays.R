#' Create forest plot for delays
#'
#' @param df data with outbreak information
#' @return returns flextable
#' @examples
#'
#' @export
forest_plot_delay <- function(df){

  parameter <- "Human delay"

  df_delay <- df %>%
    dplyr::filter(parameter_class == parameter) %>%
    dplyr::mutate(parameter_value = as.numeric(parameter_value)) %>%
    mutate(parameter_type_short = ifelse(parameter_type=="Human delay - generation time","Generation time",
                                         ifelse(parameter_type=="Human delay - incubation period",
                                                "Incubation period",
                                                ifelse(parameter_type=="Human delay - time in care","Time in care",
                                                       ifelse(parameter_type=="Human delay - time symptom to careseeking","Time symptom to careseeking",
                                                              ifelse(parameter_type=="Human delay - time symptom to outcome" & riskfactor_outcome=="Death","Time symptom to outcome (Death)",
                                                                     ifelse(parameter_type=="Human delay - time symptom to outcome" & riskfactor_outcome=="Other","Time symptom to outcome (Other)",NA))))))) %>%
    dplyr::group_by(parameter_type_short) %>%
    dplyr::arrange(first_author_surname)

  #dplyr::filter(parameter_type != "Human delay - generation time")

  df_plot <- df_delay %>%
    dplyr::filter(parameter_class == parameter) %>%
    dplyr::mutate(parameter_value = as.numeric(parameter_value)) %>%
    dplyr::group_by(parameter_type_short) %>% ### median function not behaving in ggplot so going with this even with grouping
    mutate(median = median(parameter_value,na.rm=TRUE)) %>%
    dplyr::arrange(desc(parameter_type_short), desc(parameter_value), desc(article_label))

  df_plot$article_label_unique <- make.unique(df_plot$article_label)
  df_plot$article_label_unique <- factor(df_plot$article_label_unique, levels = df_plot$article_label_unique)

  plot <-
    ggplot(df_plot, aes(col = parameter_type_short)) +
    theme_bw() +
    geom_point(aes(x=parameter_value, y=article_label_unique, shape = parameter_value_type,
    ),
    size = 3.5) +
    scale_y_discrete(labels = setNames(df_plot$article_label, df_plot$article_label_unique)) +
    scale_x_continuous(breaks = c(seq(0, 60, by = 10))) +
    # facet_wrap(parameter_type ~ ., scales = "free",  strip.position = "top", ncol = 1) +
    geom_segment(aes( y=article_label_unique, yend = article_label_unique,
                      x=parameter_lower_bound, xend=parameter_upper_bound,
                      group=parameter_data_id,
                      # linetype="Parameter range"
    ),
    # position=position_dodge(width=0.5),
    # width=0.4,
    lwd=5,
    alpha = 0.4) +
    geom_errorbar(aes(y=article_label_unique,
                      xmin=parameter_uncertainty_lower_value, xmax=parameter_uncertainty_upper_value,
                      group=parameter_data_id,
                      # linetype="Uncertainty interval"
    ),
    # position=position_dodge(width=0.5),
    width = 0.4,
    lwd=1) +
    labs(x="Delay (days)",
         y="",#y="Study (First author surname and publication year)",
         linetype="",
         colour="",
         shape = '',
         caption = '*Solid transparent rectangles refer to parameter ranges while the error bars are uncertainty intervals.') +
    # scale_linetype_manual(values = c("blank",'solid'),
    #                       labels = function(x) str_wrap(x, width = 5)) +
    scale_color_brewer(palette = 'Dark2',#end=0.9,
                       labels = function(x) str_wrap(x, width = 18))+
    scale_shape_manual(values = c(16,15,17,18),
                       labels = c('Mean','Median','Std Dev', 'Other'),
                       na.translate = F) +
    # scale_colour_discrete(labels = c("Incubation period",
    #                                  "Time in care",
    #                                  "Symptom to careseeking",
    #                                  "Symptom to outcome")) +
    theme(#legend.position="bottom",
      legend.text = element_text(size=12),
      strip.text = element_text(size=20)) + #xlim(c(0,56)) +
    guides(colour = guide_legend(order=1,ncol =1),
           linetype = guide_legend(order=2,ncol=1))


  return(plot)
}
