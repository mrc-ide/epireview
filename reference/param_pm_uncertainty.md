# Update parameter uncertainty columns in a data frame

This function updates the parameter uncertainty columns in a data frame
when the uncertainty is given by a single value (standard deviation or
standard error). It creates new columns called
`low' (parameter central value - uncertainty) and `high' (parameter
central value + uncertainty). These columns are used by
[`forest_plot`](https://mrc-ide.github.io/epireview/reference/forest_plot.md)
to plot the uncertainty intervals. If the uncertainty is given by a
range, the midpoint of the range is used as the central value (mid) and
the lower and upper bounds are used as the low and high values
respectively.

## Usage

``` r
param_pm_uncertainty(df)
```

## Arguments

- df:

  A data frame containing the parameter uncertainty columns. This will
  typically be the output of
  [`load_epidata`](https://mrc-ide.github.io/epireview/reference/load_epidata.md).

## Value

The updated data frame with parameter uncertainty columns

## Examples

``` r
df <- data.frame(
  parameter_value = c(10, 20, 30),
  parameter_uncertainty_single_value = c(1, 2, 3),
  parameter_uncertainty_lower_value = c(5, 15, 25),
  parameter_uncertainty_upper_value = c(15, 25, 35),
  parameter_uncertainty_type = c(NA, NA, NA),
  parameter_uncertainty_singe_type = c("Standard Deviation", "Standard Error", NA)
)
updated_df <- param_pm_uncertainty(df)
updated_df
#>   parameter_value parameter_uncertainty_single_value
#> 1              10                                  1
#> 2              20                                  2
#> 3              30                                  3
#>   parameter_uncertainty_lower_value parameter_uncertainty_upper_value
#> 1                                 5                                15
#> 2                                15                                25
#> 3                                25                                35
#>   parameter_uncertainty_type parameter_uncertainty_singe_type low mid high
#> 1                         NA               Standard Deviation   5  10   15
#> 2                         NA                   Standard Error  15  20   25
#> 3                         NA                             <NA>  25  30   35
#>    mid_type uncertainty_type
#> 1 Extracted             <NA>
#> 2 Extracted             <NA>
#> 3 Extracted             <NA>
```
