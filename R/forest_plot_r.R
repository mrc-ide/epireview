#' Create forest plot for reproduction numbers
#'
#' @param df data with outbreak information
#' @return returns flextable
#' @examples
#'
#' @export
forest_plot_R <- function(df){

  parameter <- "Reproduction number"

  df_R <- df %>% filter(parameter_class == parameter) %>%
    mutate(parameter_value = as.numeric(parameter_value)) %>%
    group_by(parameter_type) %>%
    dplyr::arrange(first_author_surname)

  df_plot <- df_R %>% filter(parameter_class == parameter) %>%
    mutate(parameter_value = as.numeric(parameter_value)) %>%
    group_by(parameter_type) %>% ### median function not behaving in ggplot so going with this even with grouping
    mutate(median = median(parameter_value,na.rm=TRUE))

  df_plot$article_label_unique <- make.unique(df_plot$article_label)

  df_plot <- df_plot %>% mutate(parameter_type_short =
                                  ifelse(parameter_type=="Reproduction number (Basic R0)",
                                         "Basic (R0)",
                                         ifelse(parameter_type=="Reproduction number (Effective, Re)","Effective (Re)",NA)))

  plot <-
    ggplot(df_plot, aes(x = parameter_value, y = article_label_unique, col = parameter_type_short))+
    theme_bw()+
    # scale_x_continuous(breaks = seq(0, 2, by = 0.2))+
    # geom_errorbar(aes(y=article_label,xmin=parameter_lower_bound,xmax=parameter_upper_bound,
    #                   group=parameter_data_id,
    #                   linetype="Parameter range"),
    #               position=position_dodge(width=0.5),
    #               width=0.25)+
    geom_errorbar(aes(y=article_label,
                      xmin=parameter_uncertainty_lower_value,xmax=parameter_uncertainty_upper_value,
                      group=parameter_data_id,
                      linetype="Uncertainty interval"),
                  position=position_dodge(width=0.5),
                  width = 0.2,
                  lwd=1)+
    geom_point(aes(x=parameter_value,y=article_label,group=parameter_data_id),size = 3)+
    # geom_vline(aes(xintercept=median,col="Sample median"),linetype="dashed", colour = "grey") +
    geom_vline(xintercept = 1, linetype = "dashed", colour = "dark grey") +
    labs(x="Reproduction number",y="",#y="Study",
         linetype="",colour="")+
    scale_linetype_manual(values = c("solid"),labels = function(x) str_wrap(x, width = 5))+
    #scale_colour_discrete(labels = c("Basic R0", "Effective Re")) +
    scale_colour_manual(values=c("#D95F02","#7570B3"))+
    theme(#legend.position="bottom",
      legend.text = element_text(size=12),
      strip.text = element_text(size=20)) + xlim(c(0,2)) +
    guides(colour = guide_legend(order=1,ncol=1),
           linetype = guide_legend(order=2,ncol=1))

  return(plot)
}
