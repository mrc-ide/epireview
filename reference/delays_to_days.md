# This function converts delays in different units (hours, weeks, months) to days. It checks if all delays are in days and warns the user if not. It then converts hours to days by dividing by 24, weeks to days by multiplying by 7, and months to days by multiplying by 30.

This function converts delays in different units (hours, weeks, months)
to days. It checks if all delays are in days and warns the user if not.
It then converts hours to days by dividing by 24, weeks to days by
multiplying by 7, and months to days by multiplying by 30.

## Usage

``` r
delays_to_days(df)
```

## Arguments

- df:

  A data.frame containing delays and their units. This will typically be
  a subset of parameters from the data frame returned by
  [`load_epidata`](https://mrc-ide.github.io/epireview/reference/load_epidata.md).

## Value

Updated data.frame with delays converted to days.

## Examples

``` r
df <- data.frame(
  parameter_value = c(24, 7, 1),
  parameter_unit = c("Hours", "Weeks", "Months")
)
delays_to_days(df)
#> ! Not all delays are in days. Other units are: hours, weeks, months
#> ℹ We will attempt the following conversions:
#> 
#> ── hours -> days ──
#> 
#> 1. NA (n=)
#> 2.  (n=)
#> 
#> ── weeks -> days ──
#> 
#> 1. NA (n=)
#> 2.  (n=)
#>   parameter_value parameter_unit
#> 1               1           Days
#> 2              49          Weeks
#> 3              30         Months
# Output:
#   parameter_value parameter_unit
# 1               1           Days
# 2              49           Days
# 3              30           Days
```
