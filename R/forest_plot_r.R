## This function is a wrapper around the forest_plot function in forest_plot.R
## It will 
## 1. filter the data frame to only include estimates of effective reproduction number; 
## 2. order the studies (see details); 
## 3. rename or create columns required by forest_plot; 
## 5. set sensible axis limits, and  give nice labels
## to axis.
forest_plot_rt <- function(df, ...) {

  other_args <- list(...)
  rt <- df[df$parameter_type == "Effective (Re)", ]

  rt$y <- rt$article_label
  rt$mid <- rt$parameter_value 
  rt$low <- rt$parameter_uncertainty_lower_value
  rt$high <- rt$parameter_uncertainty_upper_value




}