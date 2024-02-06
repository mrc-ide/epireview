reorder_studies <- function(df) {

  ## In general we expect that either both lower and upper bounds are provided
  ## or both are NA. If one is NA and the other is not, 
  ## range_midpoint will be NA.
  df$range_midpoint <- ifelse(is.na(df$parameter_value) & 
  !is.na(df$parameter_upper_bound),
   df$parameter_lower_bound + 
   ((df$parameter_upper_bound - df$parameter_lower_bound) / 2), NA
  )

  df$temp_order_by <- ifelse(!is.na(df$parameter_value),
    df$parameter_value, df$range_midpoint
  )
  res <- by(df, df$population_country, function(x) {
    ## By default order puts NAs at the end
    x[order(x$temp_order_by), ]
  })
  ## Here we ignore the order of countries and just append the data frames
  ## More sensible options are possible - e.g. geographical or alphabetical
  df <- do.call(rbind, res)

  df$y <- factor(df$article_label,
    levels = unique(df$article_label, ordered = TRUE)
  )
  
  df
}
