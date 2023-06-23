#' Create forest plot for severity
#'
#' @param df data with outbreak information
#' @return returns flextable
#' @examples
#'
#' @export
forest_plot_severity <- function(df,outbreak_naive=FALSE) {

  parameter <- "Severity"

  if(outbreak_naive) {
    df <- df %>% dplyr::filter(keep_record == 1)
  }

  df_cfr <- df %>% filter(parameter_class == parameter) %>%
    mutate(parameter_value = as.numeric(parameter_value)) %>%
    group_by(parameter_type) %>%
    dplyr::arrange(article_label)

  df_cfr$pooled <- (sum(df_cfr$cfr_ifr_numerator, na.rm = TRUE)/sum(df_cfr$cfr_ifr_denominator, na.rm = TRUE))*100
  p <- df_cfr$pooled[1]/100
  n <- sum(df_cfr$cfr_ifr_denominator, na.rm = TRUE)
  df_cfr$pooled_low <- (p - 1.96*(sqrt((p * (1-p))/n)))*100
  df_cfr$pooled_upp <- (p + 1.96*(sqrt((p * (1-p))/n)))*100

  df_plot <- df_cfr %>%
    dplyr::filter(is.na(parameter_value) == FALSE) %>%
    #dplyr::select(c(article_id:distribution_par2_uncertainty, covidence_id:pooled_upp)) %>%
    dplyr::arrange((cfr_ifr_method))

  ## ensuring that each entry is on it's own line
  df_plot$article_label_unique <- make.unique(df_plot$article_label)

  ## sorry team this is also hacky but I'm gonna scream if these points don't go where we want them
  df_plot <- df_plot %>% mutate(order_num = seq(1,dim(df_plot)[1],1))

  if(outbreak_naive) {
    df_plot2 <- df_plot %>%
      dplyr::arrange(outbreak_start_year) %>%
      dplyr::mutate(order_num = row_number(),
                    p = parameter_value/100,
                    lower_ci = (p  - 1.96*(sqrt((p * (1-p))/cfr_ifr_denominator)))*100,
                    upper_ci = (p  + 1.96*(sqrt((p * (1-p))/cfr_ifr_denominator)))*100,
                    outbreak_year_cnt = as.character(paste0(outbreak_year_cnt, " [n =", cfr_ifr_denominator,"]")))

    plot <- ggplot(df_plot2, aes(x=parameter_value,
                                 y=reorder(article_label_unique,-order_num),
                                 col = article_label)) +
      theme_bw() + geom_point(size = 3) +
      scale_y_discrete(labels=setNames(df_plot2$outbreak_year_cnt,
                                       df_plot2$article_label_unique)) +
      geom_rect(xmin=unique(df_cfr$pooled_low),xmax=unique(df_cfr$pooled_upp),
                ymin=-Inf,ymax=Inf,alpha=0.02,col=NA,fill="grey") +
      geom_segment(aes(y = article_label_unique, yend = article_label_unique,
                       x = lower_ci, xend = upper_ci,
                       group=parameter_data_id),
                   lwd=3,
                   alpha = 0.4) +
      labs(x="Case fatality ratio (%)",y="",#y="Study",
           linetype="",colour="",fill="") +
      theme(legend.position="right",
            legend.text = element_text(size=12),
            strip.text = element_text(size=20)) +
      # xlim(c(0, 100)) +
      scale_color_brewer(palette = 'Dark2')+
      guides(colour = guide_legend(order=1,ncol=1),
             linetype = guide_legend(order=2,ncol=1))+
      geom_vline(xintercept = unique(df_cfr$pooled),linetype="dashed") +
      scale_linetype_manual(values = c("solid"),labels = function(x) str_wrap(x, width = 5))+
      scale_fill_manual(values="grey") +
      geom_vline(xintercept = c(0, 100), linetype = "dotted") +
      scale_x_continuous(breaks = seq(-20, 120, by = 20))
  } else {
    df_plot <- df_plot %>%
      dplyr::arrange(article_label_unique) %>%
      dplyr::mutate(order_num = row_number())

    plot <- ggplot(df_plot, aes(x=parameter_value, y=reorder(article_label_unique,-order_num),
                                col = cfr_ifr_method)) +
      theme_bw() + geom_point(size = 3) +
      scale_y_discrete(labels=setNames(df_plot$article_label, df_plot$article_label_unique)) +
      geom_errorbar(aes(y=article_label_unique,
                        xmin=parameter_uncertainty_lower_value,
                        xmax=parameter_uncertainty_upper_value,
                        group=parameter_data_id,
                        linetype="Uncertainty interval"),
                    position=position_dodge(width=0.5),
                    width=0.25,
                    lwd=1) +
      geom_segment(aes(y=article_label_unique,
                       yend = article_label_unique,
                       x=parameter_lower_bound,
                       xend=parameter_upper_bound,
                       group=parameter_data_id),
                   lwd=5,
                   alpha = 0.4) +
      labs(x="Case fatality ratio (%)",y="",#y="Study",
           linetype="",colour="",fill="") +
      theme(#legend.position="right",
        legend.text = element_text(size=12),
        strip.text = element_text(size=20)) +
      # xlim(c(0, 100)) +
      scale_colour_manual(values=c("#D95F02","#7570B3"))+
      # scale_color_brewer(palette = 'Dark2') +
      # scale_colour_viridis_d(option="viridis",begin=0.2,end=0.8)+
      guides(colour = guide_legend(order=1,ncol=1),
             linetype = guide_legend(order=2,ncol=1))+
      geom_vline(xintercept = unique(df_cfr$pooled),linetype="dashed")+
      geom_rect(xmin=unique(df_cfr$pooled_low),xmax=unique(df_cfr$pooled_upp),
                ymin=-Inf,ymax=Inf,alpha=0.05,col=NA,fill="grey"#,aes(fill="CFR - pooled 95% CI")
      )+
      scale_linetype_manual(values = c("solid"),labels = function(x) str_wrap(x, width = 5))+
      scale_fill_manual(values="grey") +
      geom_vline(xintercept = c(0, 100), linetype = "dotted") +
      scale_x_continuous(breaks = seq(-20, 120, by = 20)) +
      xlim(c(-20, 120))
  }

  return(plot)
}
