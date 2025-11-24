
#' Intended for internal use only; setting desirable defaults for reading in
#' data files.
#' @param fname The name of the file to be read in.
#' @param ... Additional arguments to be passed to \code{\link[vroom]{vroom}}.
#' @return A data frame read in from the file.
#' @details This function is intended for internal use only. It is used to read
#' in data files shipped with the package. The idea is to set desirable defaults
#' in a single place. Mostly it makes reading files quiet by setting show_col_types
#' to FALSE.
#' @importFrom vroom vroom
#' @author Sangeeta Bhatia
epireview_read_file <- function(fname, ...) {
  vroom(
    system.file("extdata", fname, package = "epireview"),
    show_col_types = FALSE, ...
  )
}
#' Sanity checks before meta-analysis
#' @details
#' The function carries out a series of checks on the parameter dataframe to
#' ensure that it is in the correct format for conducting a meta-analysis.
#' It checks that the input (1) consists of a single parameter type; (2) has the
#' columns required for the meta-analysis; (3) does not have any row where a
#' value is present but the unit is missing, or vice versa. All such rows are
#' removed; and (4) has the same unit across all values of the parameter. The
#' function will throw an error if either there is more than one value of
#' parameter_type, or if the columns needed for the meta-analysis are missing,
#' or if the parameter_unit is not the same across all values of the parameter.
#' @inheritParams filter_df_for_metaprop
#' @param cols_needed a character vector specifying the names of the columns
#' required for the meta-analysis.
#' @return a parameter dataframe with offending rows removed.
#' @export
check_df_for_meta <- function(df, cols_needed) {
  ## Ensure that there is a single parameter type present
  if (length(unique(df$parameter_type)) != 1) {
    cli_abort("parameter_type must be the same across all values.", call = NULL)
  }

  if (!all(cols_needed %in% colnames(df))) {
    cols_missing <- cols_needed[!cols_needed %in% colnames(df)]
    cli_abort(
      "df must have columns named: {cols_needed}.
      Column{?s} missing: {cols_missing}",
      call = NULL
    )
  }

  ## First check that there are no rows where a value is present but unit is
  ## missing, or vice versa
  idx <- is.na(df$parameter_value) & !is.na(df$parameter_unit)
  remove <- sum(idx)
  if (any(idx)) {
    cli_inform("parameter_value must be present if parameter_unit is present.
            {remove} row{?s} with non-NA parameter_value and NA parameter_unit
            will be removed.")
    df <- df[!(is.na(df$parameter_value) & !is.na(df$parameter_unit)), ]
  }

  idx <- !is.na(df$parameter_value) & is.na(df$parameter_unit)
  remove <- sum(idx)
  if (any(idx)) {
    cli_inform("parameter_unit is missing but parameter_value is present.
            {remove} row{?s} with non-NA parameter_value and NA parameter_unit
            will be removed.")
    df <- df[!(is.na(df$parameter_value) & !is.na(df$parameter_unit)), ]
  }

  # values of the parameter must all have the same units
  if (length(unique(df$parameter_unit[!is.na(df$parameter_unit)])) != 1) {
    msg1 <- "parameter_unit must be the same across all values."
    msg2 <- "Consider calling delays_to_days() if you are working with delays."
    cli_abort(paste(msg1, msg2), call = NULL)
  }



  df
}
#' Check upper limit of parameter values
#'
#' @details
#' Each forest plot has a default upper limit for the parameter values, based on
#' the expected range of the parameter. This function checks the upper limit of
#' parameter values in a data frame and compares it with the default limit.
#' If the maximum parameter value
#' exceeds the specified upper limit, a warning message is displayed. The
#' function also returns the suggested upper limit. It is used internally by
#' the forest plot functions (only for warning the user). You can also use it
#' directly to update the default upper limit in the forest plot functions.
#'
#' @param df A data frame containing the parameter values.
#' @param ulim The specified upper limit for the parameter values.
#' @param param The name of the parameter.
#'
#' @return The suggested upper limit for the parameter values.
#'
#' @examples
#' df <- data.frame(parameter_value = c(10, 20, 30))
#' check_ulim(df, 25, "parameter")
#' @importFrom cli cli_warn
#' @export
check_ulim <- function(df, ulim, param) {
  ulim_data <- max(df$parameter_value, na.rm = TRUE)
  if (ulim_data > ulim) {
    msg <- paste(
      "The maximum", param, "is ", ulim_data,
      "; the ulim is set to ", ulim,
      ". Some points may not be plotted. Consider increasing ulim."
    )
    cli_warn(msg)
  }
  ## Return suggested ulim = max of parameter_value rounded to nearest 10
  round(ulim_data, -1)
}

#' Update parameter uncertainty columns in a data frame
#'
#' This function updates the parameter uncertainty columns in a data frame
#' when the uncertainty is given by a single value (standard deviation or
#' standard error). It creates new columns called `low' (parameter central
#' value - uncertainty) and `high' (parameter central value + uncertainty).
#' These columns are used by \code{\link{forest_plot}} to plot the
#' uncertainty intervals. If the uncertainty is given by a range, the
#' midpoint of the range is used as the central value (mid) and the lower and
#' upper bounds are used as the low and high values respectively.
#' @param df A data frame containing the parameter uncertainty columns.
#' This will typically be the output of \code{\link{load_epidata}}.
#' @return The updated data frame with parameter uncertainty columns
#'
#' @examples
#' df <- data.frame(
#'   parameter_value = c(10, 20, 30),
#'   parameter_uncertainty_single_value = c(1, 2, 3),
#'   parameter_uncertainty_lower_value = c(5, 15, 25),
#'   parameter_uncertainty_upper_value = c(15, 25, 35),
#'   parameter_uncertainty_type = c(NA, NA, NA),
#'   parameter_uncertainty_singe_type = c("Standard Deviation", "Standard Error", NA)
#' )
#' updated_df <- param_pm_uncertainty(df)
#' updated_df
#'
#' @export
param_pm_uncertainty <- function(df) {
  ## We want to assign 'low', 'mid' and 'high' values to each parameter in a
  ## a `sensible' way. In the forest plot, parameters will be ordered by the
  ## `mid' value, even if choose to not plot some of them; see notes below.
  ## We deal with the easy case first. If parameter value is extraccted, that's
  ## the central value.
  mid_not_na <- !is.na(df$parameter_value)

  ## If parameter value is not extracted, then there are a few cases to consider.
  ## 1. paired uncertainty is extracted. In this case, we plot the uncertainty
  ## and use its width to order the parameters in the forest plot. single
  ## uncertainty is not going to make sense I think without a central value. so
  ## we don't consider that combination here.
  paired_not_na <- !is.na(df$parameter_uncertainty_lower_value) &
    !is.na(df$parameter_uncertainty_upper_value)
  ## 2. both single and paired uncertainty are NA but parameter_lower_bound and
  ## parameter_upper_bound are extracted. In this case, we set the midpoint
  ## of the range as a mid value and the range as the low and high values. mid
  ## value is used to order the parameters in the forest plot, but not plotted
  ## because it is not an estimate in any sense.
  range_not_na <- !is.na(df$parameter_lower_bound) &
    !is.na(df$parameter_upper_bound)

  ## Start with NAs and then update
  df$low <- NA
  df$mid <- NA
  df$high <- NA

  df$mid[mid_not_na] <- df$parameter_value[mid_not_na]
  x <- df$parameter_uncertainty_lower_value +
    (df$parameter_uncertainty_upper_value - df$parameter_uncertainty_lower_value) / 2
  df$mid[(!mid_not_na) & paired_not_na] <- x[(!mid_not_na) & paired_not_na]

  x <- df$parameter_lower_bound +
    (df$parameter_upper_bound - df$parameter_lower_bound) / 2
  df$mid[!mid_not_na & !paired_not_na & range_not_na] <-
    x[!mid_not_na & !paired_not_na & range_not_na]

  ## Create a variable that captures the type of "mid" value so that we can
  ## choose not to plot those that don't make sense.
  df$mid_type <- NA
  df$mid_type[mid_not_na] <- "Extracted"
  df$mid_type[!mid_not_na & paired_not_na] <- "Uncertainty width"
  df$mid_type[!mid_not_na & !paired_not_na & range_not_na] <- "Range midpoint"

  ## Now we can calculate low and high values
  ## If parameter_uncertainty_single_value is not NA, we use it to calculate
  ## low and high values
  single_uc_not_na <- !is.na(df$parameter_uncertainty_single_value)
  df$low[single_uc_not_na] <- df$mid[single_uc_not_na] -
    df$parameter_uncertainty_single_value[single_uc_not_na]

  df$high[single_uc_not_na] <- df$mid[single_uc_not_na] +
    df$parameter_uncertainty_single_value[single_uc_not_na]

  ## If paired uncertainty is not NA, we use it to calculate low and high values
  df$low[paired_not_na] <- df$parameter_uncertainty_lower_value[paired_not_na]
  df$high[paired_not_na] <- df$parameter_uncertainty_upper_value[paired_not_na]

  ## Finally, if neither single nor paired uncertainty is non-NA but range is
  ## available, we use it to set low and high values
  df$low[!paired_not_na & range_not_na] <-
    df$parameter_lower_bound[!paired_not_na & range_not_na]
  df$high[!paired_not_na & range_not_na] <-
    df$parameter_upper_bound[!paired_not_na & range_not_na]

  df$uncertainty_type <- NA
  df$uncertainty_type[single_uc_not_na] <-
    df$parameter_uncertainty_singe_type[single_uc_not_na]
  df$uncertainty_type[paired_not_na] <-
    df$parameter_uncertainty_type[paired_not_na]
  df$uncertainty_type[!paired_not_na & range_not_na] <- "Range**"

  df
}


#' Reparameterize Gamma Distribution
#'
#' This function reparameterizes the gamma distribution in a given data frame.
#' If a parameter has been expressed as a gamma distribution with shape and scale,
#' we convert these to mean and standard deviation for plotting.
#'
#'
#'
#' @param df A data frame with updated columns for parameter value and uncertainty.
#' @return data.frame modified data frame with reparameterized gamma distributions.
#' @importFrom epitrix gamma_shapescale2mucv
#'
#' @export
reparam_gamma <- function(df) {
  ## get rows whre parameter_value is na, and distribution_type is gamma
  ## and distribution_par1_type is Shape and distribution_par2_type is Scale
  ## and distribution_par1_value is not na and distribution_par2_value is not na
  idx <- which(
    is.na(df$parameter_value) &
      df$distribution_type == "Gamma" &
      df$distribution_par1_type == "Shape" &
      df$distribution_par2_type == "Scale" &
      !is.na(df$distribution_par1_value) &
      !is.na(df$distribution_par2_value)
  )
  ## for these rows, set parameter_value_type to "Mean"
  df$parameter_value_type[idx] <- "Mean"
  ## for these rows, set parameter_uncertainty_singe_type to "Standard Deviation"
  df$parameter_uncertainty_singe_type[idx] <- "Standard Deviation"
  ## for these rows, get mean and cv using gamma_shapescale2mucv
  new_params <- gamma_shapescale2mucv(
    df$distribution_par1_value[idx],
    df$distribution_par2_value[idx]
  )
  mus <- new_params$mu
  sds <- new_params$cv * mus
  df$parameter_uncertainty_single_value[idx] <- sds
  df$parameter_value[idx] <- mus

  ## If we have a gamma distribution with Mead sd,
  ## we set the parameter_uncertainty_single_value to distribution_par2_value
  idx <- which(
    df$distribution_type == "Gamma" &
      is.na(df$parameter_uncertainty_singe_type) &
      df$distribution_par2_type == "Mean sd"
  )
  df$parameter_uncertainty_single_value[idx] <- df$distribution_par2_value[idx]
  df$parameter_uncertainty_singe_type[idx] <- "Standard Deviation"

  df
}

## Throwaway function to add id column to marburg files;
## need not be exported. I am only putting it here for
## the sake of record keeping.
# process_marburg_files <- function() {
#   a <- load_epidata_raw("marburg", "article")
#   p <- load_epidata_raw("marburg", "parameter")
#   o <- load_epidata_raw("marburg", "outbreak")
#   m <- load_epidata_raw("marburg", "model")
#
#   a$id <- ids::random_id(nrow(a), use_openssl = FALSE)
#   m$model_data_id <- ids::random_id(nrow(m), use_openssl = FALSE)
#   p$parameter_data_id <- ids::random_id(nrow(p), use_openssl = FALSE)
#   o$outbreak_data_id <- ids::random_id(nrow(o), use_openssl = FALSE)
#
# m <- left_join(
#       m,
#       a[, c("article_id", "id", "pathogen", "covidence_id")],
#       by = "article_id"
#     )
#
# o <- left_join(
#       o,
#       a[, c("article_id", "id", "pathogen", "covidence_id")],
#       by = "article_id"
#     )
#
# p <- left_join(
#       p,
#       a[, c("article_id", "id", "pathogen", "covidence_id")],
#       by = "article_id"
#     )
#
# readr::write_csv(m, "inst/extdata/marburg_model.csv")
# readr::write_csv(o, "inst/extdata/marburg_outbreak.csv")
# readr::write_csv(p, "inst/extdata/marburg_parameter.csv")
# readr::write_csv(a, "inst/extdata/marburg_article.csv")
#
# }
