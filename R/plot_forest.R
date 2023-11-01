# Common function to make a forest plot

#' @param df processed data with parameter information produced using
#' prep_data_forest_plots()
#' @param parameter parameter to plot; can be 'Human delay', 'Reproduction number', 'Mutations', 'Severity'
#' @param outbreak_naive *Only applicable if plotting severity. Whether to use unadjusted case and death counts (TRUE)
#' or the adjusted case and death counts (FALSE). FALSE by default.

plot_forest <- function(df,
                        parameter,
                        outbreak_naive = FALSE){

  theme_forest_plot <- theme_bw() +
    theme(legend.text = element_text(size = 12),
          strip.text = element_text(size = 20))

  if(parameter == 'Human delay'){
    plot <- forest_plot_delay(df = df) +
      theme_forest_plot
  }

  if(parameter == 'Reproduction number'){
    plot <- forest_plot_r(df = df) +
      theme_forest_plot
  }

  if(parameter == 'Mutations'){
    plot <- forest_plot_mutations(df = df) +
      theme_forest_plot
  }

  if(parameter == 'Severity'){
   plot <- forest_plot_severity(df = df,
                         outbreak_naive = outbreak_naive) +
     theme_forest_plot
  }

  return(plot)
}
