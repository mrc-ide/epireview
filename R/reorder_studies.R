reorder_studies <- function(df) {

  df$range_midpoint <- ifelse(is.na(df$parameter_value) & !is.na(df$parameter_upper_bound),
    df$parameter_upper_bound - df$parameter_lower_bound, NA
  )
  df$temp_order_by <- ifelse(!is.na(df$parameter_value),
    df$parameter_value,
    df$range_midpoint
  )

  df <- df[order(df$temp_order_by), ]

  df$y <- factor(df$article_label,
    levels = unique(df$article_label, ordered = TRUE)
  )
  
  df
}
