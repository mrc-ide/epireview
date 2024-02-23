#' Create forest plot for human delays
#' @details There are a number of 'delays' that are relevant to the pathogens
#' we study. Some of the more commonly, and hence likely to be extracted for 
#' most pathogens, are infectious period, incubation period, and
#' serial interval. However, there are many others reported by relatively few
#' studies or relevant to only a few pathogens. This function is intended
#' to serve as a template for creating forest plots for these delays. It will
#' first reparameterise any delays reported in terms of the gamma distribution
#' to the mean and standard deviation (see \code{\link{reparam_gamma}}). Then, 
#' any parameters reported as inverse (e.g., per day instead of days) will be
#' inverted (see \code{\link{invert_inverse_params}}). Finally, all delays will
#' be converted to days (see \code{\link{delays_to_days}}) before 
#' reordering the studies (if requested) and plotting the forest plot.
#' We also provide some utility functions for the commonly used delays that are
#' simply wrapper for this function. If however you are interested in 
#' some other delay, you will need to use this function directly, ensuring that
#' the data frame you provide has only the relevant delays.
#' @inheritParams forest_plot_rt
#' @seealso \code{\link{forest_plot_serial_interval}}
#' 
#' @return returns plot with a summary of the human delays
#' @importFrom ggplot2 aes theme_bw geom_point scale_y_discrete
#' 
#' 
#' @export 
forest_plot_delay_int <- function(df, ulim, reorder_studies, ...) {

  df <- reparam_gamma(df) |> 
    invert_inverse_params() |> 
    delays_to_days() |>
    param_pm_uncertainty() 
    
  if (reorder_studies) df <- reorder_studies(df)
  p <- forest_plot(df, ...)
  p <- p +       
    scale_x_continuous(
      limits = c(0, ulim), expand = c(0, 0), oob = scales::squish,
      breaks = seq(0, ulim, by = 7) ## every week
     ) 
  p
}

#' Create forest plot for serial interval
#' @details This function is a wrapper for \code{\link{forest_plot_delay_int}}
#' that is specifically for the serial interval.
#' @inheritParams forest_plot_delay_int
#' @export 
forest_plot_serial_interval <- function(df, ulim = 30, reorder_studies = TRUE, ...) {
  
  check_ulim(df, ulim, "serial interval")
  x <- df[df$parameter_type == "Human delay - serial interval", ]
  p <- forest_plot_delay_int(x, ulim, reorder_studies, ...) + 
    labs(x = "Serial interval (days)")
  p
}

check_ulim <- function(df, ulim, param) {
  ulim_data <- max(df$parameter_value, na.rm = TRUE)
  if (ulim_data > ulim) {
    msg <- paste("The maximum", param, "is ", ulim_data,
                 "; the ulim is set to ", ulim, 
                 ". Some points may not be plotted. Consider increasing the 
                 upper limit.")
    warning(msg)
  } ## else do nothing
}
#' Create forest plot for incubation period
#' @details This function is a wrapper for \code{\link{forest_plot_delay_int}}
#' that is specifically for the incubation period.
#' @inheritParams forest_plot_delay_int
#' @export
forest_plot_incubation_period <- function(df, ulim = 30, reorder_studies = TRUE, ...) {
  
  ## Warn user is max incubation period is greater than ulim
  check_ulim(df, ulim, "incubation period")
  x <- df[df$parameter_type %in% c("Human delay - incubation period", 
  "Human delay - incubation period  (inverse parameter)"), ]
  p <- forest_plot_delay_int(x, ulim, reorder_studies, ...) + 
    labs(x = "Incubation period (days)")
  p
}

#' Create forest plot for infectious period
#' @details This function is a wrapper for \code{\link{forest_plot_delay_int}}
#' that is specifically for the infectious period.
#' @inheritParams forest_plot_delay_int
#' @export
forest_plot_infectious_period <- function(df, ulim = 30, reorder_studies = TRUE, ...) {
  
  check_ulim(df, ulim, "infectious period")
  x <- df[df$parameter_type %in% c("Human delay - infectious period", 
  "Human delay - infectious period  (inverse parameter)"), ]
  p <- forest_plot_delay_int(x, ulim, reorder_studies, ...) + 
    labs(x = "Infectious period (days)")
  p
}

#' Inverts the values of selected parameters in a data frame.
#' Sometimes parameters are reported in inverse form (e.g., a delay might be 
#' reported as per day instead of days). Here we carry out a very simple
#' transformation to convert these to the correct form by inverting the parameter
#' value and the uncertainty bounds. This may not be appropriate in all cases,
#' and must be checked on a case-by-case basis.
#' This function takes a data frame as input and inverts the values of selected parameters.
#' The selected parameters are identified by the column 'inverse_param'.
#' The function performs the following operations:
#'   - Inverts the parameter values of the selected parameters.
#'   - Swaps the upper and lower bounds of the selected parameters.
#'   - Inverts the uncertainty values of the selected parameters.
#'   - Updates the logical vector to indicate that the parameters are no longer inverted.
#'   - Does not change the unit of the parameters, as it remains the same as the original parameter.
#'
#' @param df A data frame containing the parameters to be inverted.
#' @return The input data frame with the selected parameters inverted.
#' @examples
#' df <- data.frame(parameter_value = c(2, 3, 4),
#'                  parameter_upper_bound = c(5, 6, 7),
#'                  parameter_lower_bound = c(1, 2, 3),
#'                  parameter_uncertainty_upper_value = c(0.1, 0.2, 0.3),
#'                  parameter_uncertainty_lower_value = c(0.4, 0.5, 0.6),
#'                  inverse_param = c(FALSE, TRUE, FALSE))
#' invert_inverse_params(df)
#' # Output:
#' @export
invert_inverse_params <- function(df) {

  idx <- df$inverse_param ## Already a logical vector
  if (!any(idx)) {
    warning("No parameters to invert.")
    return(df)
  }

  df$parameter_value[idx] <- 1 / df$parameter_value[idx]
  tmp <- df$parameter_upper_bound[idx]
  df$parameter_upper_bound[idx] <- 1 / df$parameter_lower_bound[idx]
  df$parameter_lower_bound[idx] <- 1 / tmp

  tmp <- df$parameter_uncertainty_upper_value[idx]
  df$parameter_uncertainty_upper_value[idx] <- 
    1 / df$parameter_uncertainty_lower_value[idx]
  df$parameter_uncertainty_lower_value[idx] <- 1 / tmp
  df$inverse_param[idx] <- FALSE

  ## Even when a parameter has been extracted as inverse, its unit is the 
  ## same as the original parameter because of the database design.
  ## So we don't need to change the unit.
  df  
}
#'
#' This function converts delays in different units (hours, weeks, months) to days.
#' It checks if all delays are in days and warns the user if not. It then converts
#' hours to days by dividing by 24, weeks to days by multiplying by 7, and months
#' to days by multiplying by 30. 
#'
#' @param df A data.frame containing delays and their units. This will typically
#' be a subset of parameters from the data frame returned by 
#' \code{\link{load_epidata}}.
#' @return Updated data.frame with delays converted to days.
#' @examples
#' df <- data.frame(parameter_value = c(24, 7, 1),
#'                  parameter_unit = c("Hours", "Weeks", "Months"))
#' delays_to_days(df)
#' # Output:
#' #   parameter_value parameter_unit
#' # 1               1           Days
#' # 2              49           Days
#' # 3              30           Days
#' @export
delays_to_days <- function(df) {

  ## Check that all parameters have the same units (days)
  ## and warn the user if this is not the case
  units <- tolower(df$parameter_unit)
  not_days <- unique(units[!units %in% "days"])
  if (!all(units %in% "days")) {
    warning("Not all delays are in days. Other units are:", 
                  paste(not_days, collapse = ", "))
    warning("We will attempt to convert hours and weeks to days.")
  }
  ## Hours to days
  hours <- df$parameter_unit %in% "Hours"
  df$parameter_value[hours] <- df$parameter_value[hours] / 24
  df$parameter_uncertainty_lower_value[hours] <- 
    df$parameter_uncertainty_lower_value[hours] / 24
  df$parameter_uncertainty_upper_value[hours] <- 
    df$parameter_uncertainty_upper_value[hours] / 24
  df$parameter_unit[hours] <- "Days"

  ## Weeks to days
  weeks <- df$parameter_unit %in% c("Weeks", "Week", "week", "weeks")
  df$parameter_value[weeks] <- df$parameter_value[weeks] * 7
  df$parameter_uncertainty_lower_value[weeks] <- 
    df$parameter_uncertainty_lower_value[weeks] * 7
  df$parameter_uncertainty_upper_value[weeks] <- 
    df$parameter_uncertainty_upper_value[weeks] * 7

## months to days
  months <- df$parameter_unit %in% c("Months", "Month", "month", "months")
  df$parameter_value[months] <- df$parameter_value[months] * 30
  df$parameter_uncertainty_lower_value[months] <- 
    df$parameter_uncertainty_lower_value[months] * 30
  df$parameter_uncertainty_upper_value[months] <- 
    df$parameter_uncertainty_upper_value[months] * 30

  df
}


