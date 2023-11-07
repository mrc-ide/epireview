##' Short labels parameters for use in figures
##'
##' This function assigns short labels to otherwise very long parameter
##' names. It is not intended to be called directly but is used by
##' \code{\link{prep_data_forest_plot}}
##'
##' @param x data.frame containing a column called "parameter_type"
##' @return
##' @author Sangeeta Bhatia
short_parameter_type <- functon(x) {

  x$parameter_type_short <- case_when(
    x$parameter_type == "Reproduction number (Basic R0)" ~ "Basic (R0)",
    x$parameter_type == "Reproduction number (Effective, Re)" ~ "Effective (Re)",

    x$parameter_type == "Human delay - time symptom to outcome" &
      x$riskfactor_outcome == "Death" ~ "Time symptom to outcome (Death)",

    x$parameter_type == "Human delay - time symptom to outcome" &
      x$riskfactor_outcome == "Other" ~ "Time symptom to outcome (Other)",

  )

  x

}


##' Combine parameters and articles for use in forest plots
##'
##' @details
##'
##' This function will read in the pathogen-specific articles file and
##' parameters files and join them into a data.frame. The resulting
##' data set can be used to create a forest plot/
##'
##' @param pathogen name of pathogen. Must be one of the priority pathogens
##' exactly as specified in the package. You can get a list of the
##' priority pathogens currently included in the package by calling
##' \code{priority_pathogens()}.
##' @param prepend
##' @param exclude
##' @return data.frame with articles information (authors, publication year)
##' combined with the parameters
##' @importFrom readr read_csv
##' @importFrom dplyr left_join
##' @export

prep_data_forest_plot <- function(pathogen, prepend = "") {
  assert_pathogen(pathogen)
  pps <- priority_pathogens()

  afname <- pps[pps$pathogen == pathogen, "articles_file"]
  pfname <- pps[pps$pathogen == pathogen, "params_file"]
  mfname <- pps[pps$pathogen == pathogen, "models_file"]

  # Get file pathway for parameter data
  file_path_pa <- system.file(
    "extdata", pfname,
    package = "epireview"
  )
  if (file_path_pa == "") {
    file_path_pa <- paste0(prepend, "inst/extdata/", pathogen, "_parameter.csv")
  }

  params <- read_csv(file_path_pa, show_col_types = FALSE)
  params <- short_parameter_type(params)

  # Get file pathway for article data
  file_path_ar <- system.file(
    "extdata", afname, package = "epireview"
  )

  if (file_path_ar == "") {
    file_path_ar <- paste0(prepend, "inst/extdata/", pathogen, "_article.csv")
  }

  articles <- read_csv(file_path_ar, show_col_types = FALSE)

  ## Make pretty labels for articles
  articles$article_label <- paste0(
    articles$first_author_surname, " ", articles$year_publication
  )

  cols <- c(
    "article_id", "first_author_surname", "year_publication", "article_label"
  )

  articles <- articles[, cols]

  df <- left_join(params, articles, by = "article_id")

  ## Marburg parameters have entries like "Germany;Yugoslavia"
  ## For future pathogens, this should be cleaned up before data are
  ## checked into epireview
  df$parameter_value <- as.numeric(df$parameter_value)

  df

}
