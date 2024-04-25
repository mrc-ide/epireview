##' Short labels parameters for use in figures
##'
##' This function assigns short labels to otherwise very long parameter
##' names. It is generally not intended to be called directly but is used by
##' \code{\link{prep_data_forest_plot}}
##'
##' @param x data.frame containing a column called "parameter_type"
##' @param parameter_type_full optional. User can specify the full value of a parameter type not already included in the function.
##' @param parameter_type_short optional. Shorter value of parameter_type_full
##' @return data.frame with a new column called "parameter_type_short"
##' @author Sangeeta Bhatia
short_parameter_type <- function(x, parameter_type_full, parameter_type_short) {

  x$parameter_type_short <- case_when(
    x$parameter_type == "Reproduction number (Basic R0)" ~ "Basic (R0)",
    x$parameter_type == "Reproduction number (Effective, Re)" ~ "Effective (Re)",
    x$parameter_type == "Human delay - time symptom to outcome" &
      x$riskfactor_outcome == "Death" ~ "Time symptom to outcome (Death)",
    x$parameter_type == "Human delay - time symptom to outcome" &
      x$riskfactor_outcome == "Other" ~ "Time symptom to outcome (Other)"
  )

  if (! missing(parameter_type_full) & ! missing(parameter_type_short)) {
    x$parameter_type_short <- case_when(
      x$parameter_type == parameter_type_full ~ parameter_type_short
    )
  } else if (! missing(parameter_type_full) & missing(parameter_type_short)) {
    stop("Please specify both parameter_type_full and parameter_type_short")
  } else if ( missing(parameter_type_full) & ! missing(parameter_type_short)) {
    stop("Please specify both parameter_type_full and parameter_type_short")
  }

  x
}





##' Retrieve pathogen-specific data
##'
##' @details
##' The data extracted in the systematic review has been stored in three
##' files - one each for articles, parameters, and transmission models.
##' Data in the three files can be linked using article identifier.
##' This function will read in the pathogen-specific articles and
##' parameters files and join them into a data.frame. The resulting
##' data set can be used to create a forest plot.
##'
##' @param pathogen name of pathogen. Must be one of the priority pathogens
##' exactly as specified in the package. You can get a list of the
##' priority pathogens currently included in the package by calling
##' \code{priority_pathogens()}.
##' 
##' @param mark_multiple logical. If TRUE, multiple studies from the same
##' author in the same year will be marked with a suffix to distinguish them.
##' @return a list of length 2. The first element is a data.frame
##' called "params" with articles information (authors, publication year)
##' combined with the parameters. The second element is a data.frame
##' called "models" with all transmission models extracted for this
##' pathogen.
##' @importFrom readr read_csv
##' @importFrom dplyr left_join
##' @export

load_epidata <- function(pathogen, mark_multiple = TRUE) {

  assert_pathogen(pathogen)

  articles <- load_epidata_raw(pathogen, "article")
  models <- load_epidata_raw(pathogen, "model")
  outbreaks <- load_epidata_raw(pathogen, "outbreak")
  params <- load_epidata_raw(pathogen, "parameter")

  models_extracted <- TRUE
  outbreaks_extracted <- TRUE
  params_extracted <- TRUE

  if (! inherits(articles, "data.frame")) {
    stop(paste("No article information found for ", pathogen))
  }

  if (! inherits(models, "data.frame")) {
    warning(paste("No models information found for ", pathogen))
    ## flip the flag to indicate that no models were found
    models_extracted <- FALSE
  }

  if (! inherits(outbreaks, "data.frame")) {
    warning(paste("No outbreaks information found for ", pathogen))
    outbreaks_extracted <- FALSE
  }
  
  if (! inherits(params, "data.frame")) {
    warning(paste("No params information found for ", pathogen))
    params_extracted <- FALSE
  }
  

  articles <- pretty_article_label(articles, mark_multiple)
  cols <- c(
    "id", "first_author_surname", "year_publication", "article_label"
  )

  articles <- articles[, cols]

  ## Marburg parameters have entries like "Germany;Yugoslavia"
  ## For future pathogens, this should be cleaned up before data are
  ## checked into epireview
  params <- short_parameter_type(params)
  params$parameter_value <- as.numeric(params$parameter_value)
  
  if (params_extracted) {
    params <- left_join(params, articles, by = "id") |>
      mark_multiple_estimates("parameter_type")
  } else params <- NULL
  
  if (models_extracted) {
    models <- left_join(models, articles, by = "id") |>
      mark_multiple_estimates("model_type")
  } else models <- NULL

  if (outbreaks_extracted) {
    outbreaks <- left_join(outbreaks, articles, by = "id") |>
      mark_multiple_estimates("outbreak_country")
  } else outbreaks <- NULL
  
  message("Data loaded for ", pathogen)
  
  list(
    articles = articles, params = params, models = models, outbreaks = outbreaks
  )
}


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
#' @return The modified data frame with updated article_label
#'
#' @examples
#' df <- data.frame(article_label = c("A", "A", "B", "B", "C"),
#'                  parameter_type = c("X", "X", "Y", "Y", "Z"))
#' mark_multiple_estimates(df)
#'
#' @export
mark_multiple_estimates <- function(df, col = "parameter_type") {
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
    df$article_label[rows] <- paste0(article, " (", seq_len(nrows), ")")
  }
  df
}
##' Prepapre pathogen-specific data for input use in forest plots
##' @details
##' This function prepares the pathogen-specific data for use in forest plots.
##' It applies the desired filters using \code{\link{filter_cols}} and then
##' renames the columns to be used in the forest plot. Central value is renamed
##' to "mid", lower and upper uncertainty bounds are renamed to "low" and "high"
##' respectively. The resulting data.frame can be used to create a basic forest plot using
##' \code{\link{forest_plot}}. The basic workflow is (a) load data, (b) filter and prepare data, and 
##' (c) create forest plot.
##' @inheritParams filter_cols
##' @return data.frame a filtered data.frame with the following columns: article_label, parameter_type,
##' mid, low, high
prepare_data_forest_plot <- function(df, cols, funs, vals) {

  df <- filter_cols(df, cols, funs, vals)

  df <- df %>%
    mutate(
      mid = parameter_value,
      low = parameter_uncertainty_lower_value,
      high = parameter_uncertainty_upper_value
    ) %>%
    select(article_label, parameter_type, mid, low, high)

  df

}