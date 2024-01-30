reorder_studies <- function(df) {

  df$range_midpoint <- ifelse(is.na(df$parameter_value) & !is.na(df$parameter_upper_bound),
   df$parameter_lower_bound + ((df$parameter_upper_bound - df$parameter_lower_bound) / 2), NA
  )
  df$temp_order_by <- ifelse(!is.na(df$parameter_value),
    df$parameter_value, df$range_midpoint
  )
  res <- by(df, df$population_country, function(x) {
    x[order(x$temp_order_by), ]
  })
  
  df <- do.call(rbind, res)

  df$y <- factor(df$article_label,
    levels = unique(df$article_label, ordered = TRUE)
  )
  
  df
}
