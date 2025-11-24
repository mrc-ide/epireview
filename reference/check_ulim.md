# Check upper limit of parameter values

Check upper limit of parameter values

## Usage

``` r
check_ulim(df, ulim, param)
```

## Arguments

- df:

  A data frame containing the parameter values.

- ulim:

  The specified upper limit for the parameter values.

- param:

  The name of the parameter.

## Value

The suggested upper limit for the parameter values.

## Details

Each forest plot has a default upper limit for the parameter values,
based on the expected range of the parameter. This function checks the
upper limit of parameter values in a data frame and compares it with the
default limit. If the maximum parameter value exceeds the specified
upper limit, a warning message is displayed. The function also returns
the suggested upper limit. It is used internally by the forest plot
functions (only for warning the user). You can also use it directly to
update the default upper limit in the forest plot functions.

## Examples

``` r
df <- data.frame(parameter_value = c(10, 20, 30))
check_ulim(df, 25, "parameter")
#> Warning: The maximum parameter is 30 ; the ulim is set to 25 . Some points may not be
#> plotted. Consider increasing ulim.
#> [1] 30
```
