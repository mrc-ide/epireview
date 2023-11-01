#' Function to create unique labels

add_unique_labels <- function(df){

  # Make unique article labels
  df$article_label_unique <- make.unique(df$article_label)
  df$article_label_unique <- factor(df$article_label_unique,
                                    levels = df$article_label_unique)

  return(df)
}
