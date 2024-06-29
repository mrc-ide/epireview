#' Distinguish multiple estimates from the same study
#' 
#' @details 
#' If a study has more than one estimate for the same parameter_type/model/outbreak,
#' we add a suffix to the article_label to distinguish them
#' otherwise they will be plotted on the same line in the forest plot. Say
#' we have two estimates for the same parameter_type (p) from the same study (s),
#' they will then be labeled as s 1 and s 2.
#' 
#' 
#'
#' @param df The data frame containing the estimates.
#' @param col The column name for the table type. For parameters this is
#' "parameter_type"; for models this is "model_type"; for outbreaks this is 
#' "outbreak_country".
#'
#' @param label_type Type of labels to add to distinguish multiple estimates. 
#' Must be one of "letters" or "numbers". 
#' @return The modified data frame with updated article_label
#'
#' @examples
#' df <- data.frame(article_label = c("A", "A", "B", "B", "C"),
#'                  parameter_type = c("X", "X", "Y", "Y", "Z"))
#' mark_multiple_estimates(df, label_type = "numbers")
#'
#' @export
mark_multiple_estimates <- function(df, col = "parameter_type", label_type = c("letters", "numbers")) {

  match.arg(label_type)

  dups <- as.data.frame(
    table(article_label = df[["article_label"]], params = df[[col]])
  )

  dups <- dups[dups$Freq > 1, ]
  ## go through each duplicate and add a suffix to article_label
  for (i in seq_len(nrow(dups))) {
    article <- dups$article_label[i]
    param <- dups[["params"]][i]
    ## get the rows in params that correspond to this article and param
    rows <- df$article_label %in% article & df[[col]] %in% param
    ## add a suffix to the article_label
    nrows <- sum(rows)
    if (label_type == "letters") {
      labels <- letters[seq_len(nrows)]
    } else if (label_type == "numbers") {
      labels <- seq_len(nrows)
    }
    df$article_label[rows] <- paste0(article, " (", labels, ")")
  }
  df
}


