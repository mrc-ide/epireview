#' Plotting theme for epireview
#' A standard theme for figures in epireview.
#' @inheritParams ggplot2::theme_bw
#' @export
theme_epireview <- function(
  base_size = 11,
  base_family = "",
  base_line_size = base_size / 22,
  base_rect_size = base_size / 22
) {
  update_geom_defaults("point", list(size = 3))
  update_geom_defaults("segment", list(lwd = 5, alpha = 0.4))
  update_geom_defaults("errorbar", list(lwd = 1, width = 0.4))
  th <- theme_bw(base_size, base_family, base_line_size, base_rect_size)
  th <- th + theme(
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5),
    plot.margin = margin(10, 20, 10, 20),
    panel.spacing = unit(1.5, "lines"),
    legend.position = "bottom",
    legend.title = element_blank()
  )
  th
}

#' country_palette Function
#'
#' This function returns a color palette for countries.
#'
#' @param x A vector of country names. If provided, the function will return a color palette for the specified countries.
#' @return A color palette for the specified countries.
#' @examples
#' # Get color palette for all countries
#' country_palette()
#'
#' # Get color palette for specific countries
#' country_palette(c('Liberia', 'Guinea', 'Sierra Leone'))
#'
#' @importFrom paletteer paletteer_d
#' @importFrom pals polychrome
#'
#' @export
country_palette <- function(x = NULL) {
  pal <- paletteer::paletteer_d("pals::polychrome")
  class(pal) <- NULL
  countries <- c(
    'Liberia', 'Guinea', 'Sierra Leone', 'Nigeria', 'Senegal', 'Mali',
    'DRC', 'Gabon', 'Uganda', 'South Sudan', 'Kenya', 'Ethiopia',
    'Cameroon', 'Central African Republic', 'Republic of the Congo',
    'Sudan', 'Chad', 'Benin', 'Togo', 'Ghana', 'Burkina Faso', 'Ivory Coast',
    'Equatorial Guinea', 'Angola', 'South Africa', 'Zambia', 'Tanzania',
    'Djibouti', 'Somalia', 'Mozambique', 'Madagascar', 'Malawi', 'Zimbabwe',
    'United Kingdom', 'Unspecified'
  )
  if (missing(x) | length(x) == 0) {
    x <- countries
  } else {
    if (length(x) > length(pal)) {
      stop(paste0("More than", length(pal)," countries provided. Please provide a vector of length", length(pal)," or less"))
    } else {
      pal <- pal[1:length(x)]
    }
  }
  names(pal) <- x
  pal[x]
}

##' Define a consistent color palette for use in
##' figures
##'
##'
##' @param x a list of parameters. Optional. If missing, the entire
##' palette is returned.
##' @return a named list of colors that can be used
##' in forest plots for manually setting colors
##' with for example
##' \code{\link{ggplot2:scale_color_manual}{scale_color_manual}}
##' @author Sangeeta Bhatia
parameter_palette <- function(x) {
  out <- list(
    "Basic (R0)" = "#D95F02",
    "Reproduction number (Basic R0)" = "#D95F02",
    "Effective (Re)" = "#7570B3",
    "Reproduction number (Effective, Re)" = "#7570B3"
  )
  n_colrs <- length(unique(out))
  colrs <- unique(out)
  if (missing(x) | length(x) == 0) {
    x <- names(out)
  } else {
    if (length(x) < n_colrs) {
      out <- colrs[seq_along(x)]
      names(out) <- x
    } else {
      stop(paste0("Pre-defined palette has only ", n_colrs, " colors. Please provide a vector of length ", n_colrs, " or less"))
    }
  }
  out[x]
}

##' Define a consistent shape palette for use in forest plots
##'
##' We map shape aesthetic to value type i.e., mean, median etc.
##' This function defines a shape palette that can be used in forest
##' plots
##' @param x a list of parameters
##' @return a named list of shapes where names are value types (mean,
##' median, std dev etc.)
##'
##' @author Sangeeta Bhatia
value_type_palette <- function(x = NULL) {
  out <- list(
    Mean = 16,
    mean = 16,
    average = 16,
    Median = 15,
    median = 15,
    `Std Dev` = 17,
    `std dev` = 17,
    sd = 17,
    other = 18,
    Other = 18,
    Unspecified = 5,
    unspecified = 5
  )
  n_shapes <- length(unique(out))
  shapes <- unique(out)
  if (missing(x) | length(x) == 0) {
    x <- names(out)
  } else {
    if (length(x) < n_shapes) {
      out <- shapes[seq_along(x)]
      names(out) <- x
    } else {
      stop(paste0("Pre-defined palette has only ", n_shapes, " shapes. Please provide a vector of length ", n_shapes, " or less"))
    }
  }
  out[x]
}

##' Define a consistent color palette for use in
##' figures. Palettes are currently defined for
##' parameters and countries. Any other variable will
##' return NULL
##' @param col_by a character vector specifying the parameter to color the palette by.
##' @param ... additional arguments to be passed to the underlying palette function.
##' These are treated as names of the palette elements.
##' @return a named list of colors that can be used in forest plots for manually setting colors
##' @export
color_palette <- function(col_by = c("parameter_type", "population_country"), ...) {
  match.arg(col_by)
  other_args <- list(...)
  col_palette <- NULL
  if (col_by == "parameter_type") {
    col_palette <- parameter_palette(other_args)
  } 
  if (col_by == "population_country") {
    col_palette <- country_palette(other_args)
  }
  col_palette
}

## Synonym for color_palette
colour_palette <- function(col_by = c("parameter_type", "population_country"), ...) {
  color_palette(col_by, ...)
}

#' shape_palette function
#'
#' This function generates a shape palette based on the specified shape_by parameter.
#'
#' @param shape_by A character vector specifying the parameter to shape the palette by.
#'   Currently, only "value_type" is supported.
#' @param ... Additional arguments to be passed to the underlying palette function.
#' These are treated as names of the palette elements.
#'
#' @return A shape palette based on the specified shape_by parameter.
#'
#' @examples
#' shape_palette("value_type")
#'
#' @export
shape_palette <- function(shape_by = c("parameter_value_type"), ...) {
  match.arg(shape_by)
  other_args <- list(...)
  shape_palette <- NULL
  if (shape_by == "parameter_value_type") {
    shape_palette <- value_type_palette(other_args)
  }
  shape_palette
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
  mid_not_na <- ! is.na(df$parameter_value)

  ## If parameter value is not extracted, then there are a few cases to consider.
  ## 1. paired uncertainty is extracted. In this case, we plot the uncertainty
  ## and use its width to order the parameters in the forest plot. single 
  ## uncertainty is not going to make sense I think without a central value. so
  ## we don't consider that combination here.
  paired_not_na <- !is.na(df$parameter_uncertainty_lower_value) &
    ! is.na(df$parameter_uncertainty_upper_value)
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
  df$mid[(! mid_not_na) & paired_not_na] <- x[(! mid_not_na) & paired_not_na]

  x <- df$parameter_lower_bound + 
    (df$parameter_upper_bound - df$parameter_lower_bound) / 2
  df$mid[! mid_not_na & ! paired_not_na & range_not_na] <- 
    x[! mid_not_na & ! paired_not_na & range_not_na]

  ## Create a variable that captures the type of "mid" value so that we can 
  ## choose not to plot those that don't make sense.
  df$mid_type <- NA
  df$mid_type[mid_not_na] <- "Extracted"
  df$mid_type[! mid_not_na & paired_not_na] <- "Uncertainty width"
  df$mid_type[! mid_not_na & ! paired_not_na & range_not_na] <- "Range midpoint"

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
  df$low[! paired_not_na & range_not_na] <- 
    df$parameter_lower_bound[! paired_not_na & range_not_na]
  df$high[! paired_not_na & range_not_na] <- 
    df$parameter_upper_bound[! paired_not_na & range_not_na]
  
  df$uncertainty_type <- NA
  df$uncertainty_type[paired_not_na] <- 
    df$parameter_uncertainty_type[paired_not_na]
  df$uncertainty_type[single_uc_not_na] <- 
    df$parameter_uncertainty_singe_type[single_uc_not_na]
  df$uncertainty_type[! paired_not_na & range_not_na] <- "Range**"

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
