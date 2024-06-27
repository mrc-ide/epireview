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
#' @param reorder_by character. The name of the column to reorder the data by. 
#' Default is "population_country"
#' @return The reordered dataframe
#' @export
#' @seealso \code{\link{forest_plot_rt}}  \code{\link{forest_plot_r0}}
#' @examples
#' ebola <- load_epidata("ebola")
#' params <- ebola$params
#' rt <- params[params$parameter_type == "Reproduction number (Effective, Re)",]
#' 
#' reorder_studies(param_pm_uncertainty(rt))
#' 
#'
reorder_studies <- function(df, reorder_by = "population_country") {

  if (! "mid" %in% colnames(df)) {
    stop(
      "mid column not found in the data frame, did you forget to call 
      param_pm_uncertainty?",
      call. = FALSE
    )
  }
  if (! reorder_by %in% colnames(df)) {
    stop(
      paste0(reorder_by, " column not found in the data frame"),
      call. = FALSE
    )
  }
  ## This will add NA as a valid factor level that is put at the end by
  ## default. So rows will not be dropped if they have NA in the 
  ## population_country. However note that you cannot then use is.na to check
  ## for NAs in this column. You should use df[[reorder_by]] %in% NA to
  ## subset the data frame.
  df[[reorder_by]] <- addNA(df[[reorder_by]], ifany = TRUE)
  res <- by(df, df[[reorder_by]], function(x) {
    ## By default order puts NAs at the end
    x[order(x$mid), ]
  })
  ## Here we ignore the order of countries and just append the data frames
  ## More sensible options are possible - e.g. geographical or alphabetical
  df <- do.call(rbind, res)
  
  df$article_label <- factor(df$article_label,
    levels = unique(df$article_label, ordered = TRUE)
  )
  ## unfactorise the population_country column
  df[[reorder_by]] <- as.character(df[[reorder_by]])

  df
}
