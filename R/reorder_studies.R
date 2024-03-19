#' Reorder articles based on parameter value
#'
#' This function takes a dataframe as input (this will typically be params 
#' data.frame from the output of \code{\link{load_epidata}}) and reorders it 
#' to provide a sensible order for plotting. 
#' For each country, studies are ordered by the parameter value or the midpoint
#' of the parameter range if the parameter value is missing. It creates a new
#' column 'y' which is an ordered factor with levels corresponding to the
#' article_label. To order the studies in some other way, set reorder_studies to 
#' FALSE in the parameter specific 
#' forest plot functions (e.g. \code{\link{forest_plot_rt}}).
#' 
#' @param df The input dataframe to be reordered
#' @return The reordered dataframe
#' @seealso \code{\link{forest_plot_rt}}  \code{\link{forest_plot_r0}}
#' @examples
#' ebola <- load_epidata("ebola")
#' params <- ebola$params
#' rt <- filter_cols(
#'   params, "parameter_type", "in", "Reproduction number (Effective, Re)")
#' reorder_studies(rt)
#' 
#'
reorder_studies <- function(df) {

  res <- by(df, df$population_country, function(x) {
    ## By default order puts NAs at the end
    x[order(x$mid), ]
  })
  ## Here we ignore the order of countries and just append the data frames
  ## More sensible options are possible - e.g. geographical or alphabetical
  df <- do.call(rbind, res)
  
  df$article_label <- factor(df$article_label,
    levels = unique(df$article_label, ordered = TRUE)
  )
  
  df
}
