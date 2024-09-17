#' Short labels parameters for use in figures
#' @details
#' This function assigns short labels to otherwise very long parameter
#' names. It is generally not intended to be called directly but is used by
#' \code{\link{load_epidata}} when the data is loaded. The short parameter names
#' are read from the file "param_name.csv" in the package. If you want to supply
#' your own short names, you can do so by specifying the parameter_type_full and
#' parameter_type_short arguments. Note however that if parameter_type_full does 
#' not contain all the parameter types in the data, the short label 
#' (parameter_type_short) will be NA for missing values. It is therefore easier
#' and recommended that you update the column parameter_type_short once the data
#' are loaded via \code{\link{load_epidata}}.
#'
#' @param x data.frame containing a column called "parameter_type",  This will
#' typically be the `params` data.frame from the output of \code{\link{load_epidata}}.
#' @param parameter_type_full optional. User can specify the full name  of a
#' parameter type not already included in the function.
#' @param parameter_type_short optional. Shorter value of parameter_type_full
#' @return data.frame with a new column called "parameter_type_short"
#' @export
#' @author Sangeeta Bhatia
short_parameter_type <- function(x, parameter_type_full, parameter_type_short) {

  x$other_delay <- NA_character_
  idx <- x$parameter_type %in% "Human delay - time symptom to outcome" &
      x$riskfactor_outcome %in% "Death" 
  x$other_delay[idx] <- "Time symptom to outcome (Death)"

  idx <- x$parameter_type %in% "Human delay - time symptom to outcome" &
      x$riskfactor_outcome %in% "Other" 
  x$other_delay[idx] <- "Time symptom to outcome (Other)"
  
  idx <- x$parameter_type %in% 'Human delay - other human delay (go to section)' 
  x$other_delay[idx] <- paste0(
    tolower(gsub('Other: ', '', x$other_delay_start[idx])), ' to ',
    tolower(gsub('Other: ', '', x$other_delay_end[idx]))
  )
  x$parameter_type[idx] <- paste0('Human delay - ', x$other_delay[idx])

  idx <- x$parameter_type %in% 'Human delay - time symptom to outcome'
  x$parameter_type[idx] <- paste0('Human delay - ', tolower(x$other_delay[idx]))

  if (! missing(parameter_type_full) & ! missing(parameter_type_short)) {
    idx <- match(x$parameter_type, parameter_type_full)
    if (any(is.na(idx))) {
      cli_alert_warning("Some parameter types in the data do not have a short 
        label. Using the full parameter type instead.")
    }
    x$parameter_type_short <- NA_character_
    x$parameter_type_short[! is.na(idx)] <- 
      parameter_type_short[idx[! is.na(idx)]]
  } else if (! missing(parameter_type_full) & missing(parameter_type_short)) {
    cli_abort("Please specify both parameter_type_full and parameter_type_short")
  } else if ( missing(parameter_type_full) & ! missing(parameter_type_short)) {
    cli_abort("Please specify both parameter_type_full and parameter_type_short")
  }

  x
}

#' Retrieve pathogen-specific data
#'
#' @details
#' The data extracted in the systematic review has been stored in four
#' files - one each for articles, parameters, outbreaks, and transmission models.
#' Data in these files can be linked using article identifier.
#' This function will read in the pathogen-specific files and join them into a 
#' data.frame. This function also
#' creates user-friendly short labels for the "parameter_type" column in params
#' data.frame. See \code{\link{short_parameter_type}} for more details.
#'
#' @param pathogen name of pathogen. This argument is case-insensitive.
#' Must be one of the priority pathogens You can get a list of the
#' priority pathogens currently included in the package by calling the function
#' \code{\link{priority_pathogens}}.
#' @param mark_multiple logical. If TRUE, multiple studies from the same
#' author in the same year will be marked with an numeric suffix to 
#' distinguish them. See \code{\link{mark_multiple_estimates}} for more details.
#' @return a list of length 4. The first element is a data.frame called "articles"
#' which contains all of the information about the articles extracted for this
#' pathogen. The second element is a data.frame called "params" with articles
#' information (authors, publication year, doi) combined with the parameters.
#' The third element is a data.frame called "models" with all transmission
#' models extracted for this pathogen including articles information as above.
#' The fourth element is a data.frame called "outbreaks" which contains all
#' of the outbreaks extracted for this pathogen, where available. If no data
#' is available for a particular table, the corresponding element in the list
#' will be NULL.
#'
#' @importFrom dplyr left_join
#' @importFrom cli cli_alert_info cli_alert_warning cli_abort cli_alert_success
#' @export
load_epidata <- function(pathogen, mark_multiple = TRUE) {

  pathogen <- tolower(pathogen)
  assert_pathogen(pathogen)

  articles <- suppressWarnings(load_epidata_raw(pathogen, "article"))
  models <- suppressWarnings(load_epidata_raw(pathogen, "model"))
  outbreaks <- suppressWarnings(load_epidata_raw(pathogen, "outbreak"))
  params <- suppressWarnings(load_epidata_raw(pathogen, "parameter"))


  models_extracted <- TRUE
  outbreaks_extracted <- TRUE
  params_extracted <- TRUE

  if (! inherits(articles, "data.frame")) {
    cli_abort(paste("No article information found for", pathogen))
  }

  if (! inherits(models, "data.frame")) {
    cli_alert_warning(paste(pathogen, "does not have any extracted model 
      information. Models will be set to NULL."))
    ## flip the flag to indicate that no models were found
    models_extracted <- FALSE
  }

  if (! inherits(outbreaks, "data.frame")) {
    cli_alert_info(paste(pathogen, "does not have any extracted outbreaks 
      information. Outbreaks will be set to NULL."))
    outbreaks_extracted <- FALSE
  }

  if (! inherits(params, "data.frame")) {
    cli_alert_warning(paste(pathogen, "does not have any extracted parameter 
      information. Parameters will be set to NULL."))
    params_extracted <- FALSE
  }


  articles <- pretty_article_label(articles, mark_multiple)
  articles <- update_article_info(articles)
  ## These are the columns we want to affix to the other tables
  ## to make them easier to work with; we don't want to add all of
  ## articles.
  cols <- c(
    "id", "first_author_surname", "year_publication", "article_label",
    "article_info"
  )
  articles_everything <- articles
  articles <- articles[, cols]
  
  param_names <- epireview_read_file("param_name.csv")  
  params <- short_parameter_type(
    params, param_names$parameter_type_full, param_names$parameter_type_short
  )
  params$parameter_value <- as.numeric(params$parameter_value)

  if (params_extracted) {
    params <- make_unique_id(articles_everything, params, "params")
    params <- left_join(params, articles, by = "id") |>
      mark_multiple_estimates("parameter_type", label_type = "numbers")
  } else params <- NULL

  if (models_extracted) {
    models <- make_unique_id(articles_everything, models, "models")
    models <- left_join(models, articles, by = "id") |>
      mark_multiple_estimates("model_type", label_type = "numbers")
  } else models <- NULL

  if (outbreaks_extracted) {
    outbreaks <- make_unique_id(articles_everything, outbreaks, "outbreaks")
    outbreaks <- left_join(outbreaks, articles, by = "id") |>
      mark_multiple_estimates("outbreak_country", label_type = "numbers")
  } else outbreaks <- NULL

  cli_alert_success(paste("Data loaded for", pathogen))

  list(
    articles = articles_everything, params = params, models = models,
    outbreaks = outbreaks
  )
}

#' Distinguish multiple estimates from the same study
#'
#' @details
#' If a study has more than one estimate/model/outbreak for the same 
#' parameter_type/model/outbreak,
#' we add a suffix to the article_label to distinguish them
#' otherwise they will be plotted on the same line in the forest plot. Say
#' we have two estimates for the same parameter_type (p) from the same study (s),
#' they will then be labeled as s 1 and s 2.
#' @param df The data frame containing the estimates.
#' @param col The column name that identifies multiple enteries for a study. 
#' Duplicate values in this column for a study will be marked with a suffix.
#' Although the user can choose 
#' any column here, the most logical choices are: for parameters - 
#' "parameter_type"; for models - "model_type"; for outbreaks - 
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
mark_multiple_estimates <- function(df, 
  col = "parameter_type", 
  label_type = c("letters", "numbers")) {

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
