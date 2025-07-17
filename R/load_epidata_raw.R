#' Loads raw data for a particular pathogen
#'
#' @details
#' This function will return the raw data as a data.frame. The
#' csv files of the models, outbreaks, and parameters for a pathogen
#' do not contain information on the source but only an "article_id"
#' that can be used to merge them with the articles. If you wish to
#' retrieve linked information or multiple tables at the same time,
#' use \code{load_epidata} instead.
#'
#'
#' @inheritParams load_epidata
#'
#' @param table the table to be loaded. Must be one of
#' "article", "parameter", "outbreak", "model" or "param_name"
#' @return data.frame reading in the csv the specified pathogen table
#' @seealso
#' [load_epidata()] for a more user-friendly interface
#' @examples
#' load_epidata_raw(pathogen = "marburg", table = "outbreak")
#' @importFrom cli cli_warn cli_abort
#' @export
load_epidata_raw <- function(pathogen, table = c("article", "parameter",
                                                "outbreak", "model", "param_name")) {

  # assertions

  if (missing(pathogen) | missing(table)) {
    cli_abort("pathogen and table name must be supplied. table can be
              one of 'article', 'parameter', 'outbreak' or 'model'")
  }

  assert_pathogen(pathogen)
  assert_table(table)

  pps <- priority_pathogens()

  fname <- switch(
    table,
    article =  pps[pps$pathogen == pathogen, "articles_file"],
    parameter = pps[pps$pathogen == pathogen, "params_file"],
    outbreak = pps[pps$pathogen == pathogen, "outbreaks_file"],
    model = pps[pps$pathogen == pathogen, "models_file"]
  )
  ## Get column types based on table type
  col_types <- switch(
    table,
    article = article_column_type(),
    parameter = parameter_column_type(),
    outbreak = outbreak_column_type(),
    model = model_column_type()
  )

  if (is.na(fname)) {
    cli_warn(paste("No data found for", pathogen))
    return(NULL)
  } else {
    ## Temporarily read in without column types as column names for the
    ## same table can change between pathogens
    tmp <- epireview_read_file(fname)
    ## col_types will have more columns than tmp, so we need to select
    ## only the columns that are in tmp
    ## This is because the column names can change between pathogens
    ## for instance, pathogens extracted after SARS will have additional
    ## parameters.
    cols <- intersect(colnames(tmp), names(col_types))
    col_types <- col_types[cols]
    check_column_types(fname, col_types, colnames(tmp))
    ## If a column has not been specified in col_types, default to
    ## character and bypass the check. Only warn the user
    cols_not_set <- colnames(tmp)[!colnames(tmp) %in% names(col_types)]

    if (length(cols_not_set) > 0) {
      cli_warn(paste("The following columns were not specified in col_types:",
                     paste(cols_not_set, collapse = ", ")))
      cli_warn("These columns will be read in as character vectors.")
      cli_warn("Data contributors: please carefully check that this does not
               lead to loss of information. If it does, please update the
               column types in the epireview package and submit a PR.")
      for (col in cols_not_set) {
        col_types[[col]] <- col_character()
      }
    }
    out <- epireview_read_file(
      fname, col_types = col_types, col_select = colnames(tmp)
    )
  }
  out

}


#' Checks that the column types of the input csv matches the column types
#' expected by epireview.
#'
#' This function creates a vroom object (the same type created by read_csv) and
#' checks if there are any problems with the file. If there are it will provide
#' the offending columns and the number problematic rows (per column).
#' A csv with the details of the issue will be written to a tmp file and
#' the location will be provided.
#' This function will prevent data from being loaded until all column types are
#' correct.
#'
#' The function is intended to be used
#' internally by \code{load_epidata_raw} where the files are being read.
#' @param fname The name of the csv file for which the column types are to
#' be checked
#' @param col_types The column types expected by epireview. These are specified
#' in the column type functions (e.g., article_column_type, parameter_column_type)
#' and are used to read in the data.
#' @param raw_colnames The column names of the csv file
#' @importFrom readr write_csv
#' @importFrom cli  cli_alert_info cli_alert_danger cli_ol cli_li cli_end cli_abort
#' @importFrom vroom problems
#' @seealso article_column_type parameter_column_type, outbreak_column_type,
#' model_column_type
#' @export
check_column_types <- function(fname, col_types, raw_colnames) {

  tmp_vroom <- epireview_read_file(fname, col_types = col_types)
  tmp_problem <- problems(tmp_vroom)

  if (NROW(tmp_problem) > 0){
    # update the values in col to the actual column names
    tmp_problem$col<- sapply(tmp_problem["col"],
                                 function(i) raw_colnames[i])


    # update the file to only the csv; assumes no "/" in the csv filename
    cli_alert_danger(paste("There is an issue with",
                           basename(tmp_problem$file[1]),
                           ". The following columns have (n) issues:"))

    olid <- cli_ol()

    problem_col_df <-as.data.frame(table(tmp_problem$col))
    for (i in 1:NROW(problem_col_df)){
      cli_li(paste(problem_col_df[i,1], " (n=", problem_col_df[i,2], ")", sep=""))
    }

    cli_end(olid)

    tmpfile <- tempfile(fileext = ".csv")
    write_csv(tmp_problem, file=tmpfile)

    cli_alert_info(
      paste("The errors have been written to a temporary csv that you can find here:",
            tmpfile)
      )
    cli_abort("The data cannot be loaded until these errors are fixed.",
              call=NULL)
  }
}


#' Define the column types for the article data frame
#'
#' This function defines the column types for the article data frame used in the epireview package.
#' vroom is generally good at guessing the
#' column types, but it is better to be explicit. Moreover, it reads a column of NAs as a logical vector, which
#' is particularly undesirable for us. This function is intended to be used internally by \code{load_epidata_raw} where
#' the files are being read.
#'
#'
#' @inheritParams load_epidata_raw
#' @return A list of column types for the article data frame
#' @importFrom vroom col_character col_integer col_logical
#' @seealso parameter_column_type, outbreak_column_type, model_column_type
#' @export
article_column_type <- function(pathogen) {
  out <- list(
    id = col_character(),
    covidence_id = col_integer(),
    pathogen = col_character(),
    first_author_first_name = col_character(),
    first_author_surname = col_character(),
    article_title = col_character(),
    doi = col_character(),
    journal = col_character(),
    year_publication = col_integer(),
    volume = col_integer(),
    issue = col_integer(),
    page_first = col_integer(),
    page_last = col_integer(),
    paper_copy_only = col_logical(),
    notes = col_character(),
    qa_m1 = col_character(),
    qa_m2 = col_character(),
    qa_a3 = col_character(),
    qa_a4 = col_character(),
    qa_d5 = col_character(),
    qa_d6 = col_character(),
    qa_d7 = col_character(),
    article_label = col_character()
  )

  out
}

#' parameter_column_type
#'
#' This function defines the column types for the parameters in the dataset.
#' It returns a list of column types with their corresponding names.
#'
#' @inherit article_column_type details return seealso
#' @export
#'
#' @examples
#' parameter_column_type()
#'
#' @importFrom vroom col_integer col_character col_double col_logical
#'
#' @keywords dataset, column types
parameter_column_type <- function() {
  out <- list(
    parameter_data_id = col_character(),
    id = col_character(),
    article_id = col_integer(),
    parameter_type = col_character(),
    parameter_value = col_double(),
    parameter_unit = col_character(),
    parameter_lower_bound = col_double(),
    parameter_upper_bound = col_double(),
    parameter_value_type = col_character(),
    parameter_uncertainty_single_value = col_double(),
    parameter_uncertainty_singe_type = col_character(),
    parameter_uncertainty_lower_value = col_double(),
    parameter_uncertainty_upper_value = col_double(),
    parameter_uncertainty_type = col_character(),
    cfr_ifr_numerator = col_integer(),
    cfr_ifr_denominator = col_integer(),
    distribution_type = col_character(),
    distribution_par1_value = col_double(),
    distribution_par1_type = col_character(),
    distribution_par1_uncertainty = col_logical(),
    distribution_par2_value = col_double(),
    distribution_par2_type = col_character(),
    distribution_par2_uncertainty = col_logical(),
    method_from_supplement = col_logical(),
    method_moment_value = col_character(),
    cfr_ifr_method = col_character(),
    method_r = col_character(),
    method_disaggregated_by = col_character(),
    method_disaggregated = col_logical(),
    method_disaggregated_only = col_logical(),
    riskfactor_outcome = col_character(),
    riskfactor_name = col_character(),
    riskfactor_occupation = col_character(),
    riskfactor_significant = col_character(),
    riskfactor_adjusted = col_character(),
    population_sex = col_character(),
    population_sample_type = col_character(),
    population_group = col_character(),
    population_age_min = col_double(),
    population_age_max = col_double(),
    population_sample_size = col_integer(),
    population_country = col_character(),
    population_location = col_character(),
    population_study_start_day = col_integer(),
    population_study_start_month = col_character(),
    population_study_start_year = col_integer(),
    population_study_end_day = col_integer(),
    population_study_end_month = col_character(),
    population_study_end_year = col_integer(),
    genome_site = col_character(),
    genomic_sequence_available = col_logical(),
    parameter_class = col_character(),
    covidence_id = col_integer(),
    exponent = col_integer(),
    case_definition = col_character(),
    data_available = col_character(),
    inverse_param = col_logical(),
    parameter_from_figure = col_logical(),
    r_pathway = col_character(),
    seroprevalence_adjusted = col_character(),
    third_sample_param_yn = col_logical(),
    trimester_exposed = col_character(),
    urban_rural_area = col_character(),
    parameter_bounds = col_character(),
    comb_uncertainty_type = col_character(),
    comb_uncertainty = col_character(),
    population_country_original = col_character(),
    delay_short = col_character(),
    genomic_lineage = col_character(),
    prnt_on_elisa = col_logical(),
    metaanalysis_inclusion = col_character(),
    women_or_infants = col_character(),
    pregnancy_outcome_type = col_character(),
    survey_start_date = col_character(),
    survey_end_date = col_character(),
    survey_date = col_character()
  )

  out
}


#' outbreak_column_type
#'
#' This function defines the column types for the outbreaks in the dataset.
#' It returns a list of column types with their corresponding names.
#'
#' @inherit article_column_type details return seealso
#' @export
#' @importFrom vroom col_integer col_character col_double col_logical
#' @keywords dataset, column types
#' @examples
#' outbreak_column_type()
outbreak_column_type <- function() {
  out <- list(
    outbreak_id     = col_character(),
    id = col_character(),
    article_id           = col_integer(),
    outbreak_start_day   = col_double(),
    outbreak_start_month = col_character(),
    outbreak_start_year  = col_double(),
    outbreak_end_day     = col_double(),
    outbreak_end_month   = col_character(),
    outbreak_date_year   = col_double(),
    outbreak_duration_months = col_double(),
    outbreak_size        = col_double(),
    asymptomatic_transmission = col_logical(),
    outbreak_country     = col_character(),
    outbreak_location    = col_character(),
    cases_confirmed      = col_double(),
    cases_mode_detection = col_character(),
    cases_suspected      = col_integer(),
    cases_asymptomatic   = col_integer(),
    deaths               = col_integer(),
    cases_severe_hospitalised = col_integer(),
    covidence_id         = col_integer(),
    cases_severe         = col_integer(),
    cases_unspecified    = col_integer(),
    female_cases         = col_integer(),
    male_cases           = col_integer(),
    ongoing              = col_logical(),
    population_size      = col_integer(),
    pre_outbreak         = col_character(),
    prop_female_cases    = col_double(),
    prop_male_cases      = col_double(),
    type_cases_sex_disagg = col_character(),
    outbreak_start_date = col_character(),
    pathogen = col_character()
  )
  out
}

#' model_column_type
#'
#' This function defines the column types for the models in the dataset.
#' It returns a list of column types with their corresponding names.
#' @inherit article_column_type details return seealso
#'
#' @export
#' @importFrom vroom col_integer col_character col_double col_logical
#' @keywords dataset, column types
#' @examples
#' model_column_type()
model_column_type <- function() {

  out <- list(
    id = col_character(),
    model_data_id       = col_character(),
    article_id          = col_integer(),
    pathogen            = col_character(),
    ebola_variant       = col_character(),
    model_type          = col_character(),
    compartmental_type  = col_character(),
    stoch_deter         = col_character(),
    theoretical_model   = col_logical(),
    interventions_type  = col_character(),
    code_available      = col_logical(),
    transmission_route  = col_character(),
    assumptions         = col_character(),
    covidence_id        = col_integer()
  )

  out
}
