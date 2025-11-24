# Inverts the values of selected parameters in a data frame. Sometimes parameters are reported in inverse form (e.g., a delay might be reported as per day instead of days). Here we carry out a very simple transformation to convert these to the correct form by inverting the parameter value and the uncertainty bounds. This may not be appropriate in all cases, and must be checked on a case-by-case basis. This function takes a data frame as input and inverts the values of selected parameters. The selected parameters are identified by the column 'inverse_param'. The function performs the following operations:

- Inverts the parameter values of the selected parameters.

- Swaps the upper and lower bounds of the selected parameters.

- Inverts the uncertainty values of the selected parameters.

- Updates the logical vector to indicate that the parameters are no
  longer inverted.

- Does not change the unit of the parameters, as it remains the same as
  the original parameter.

Inverts the values of selected parameters in a data frame. Sometimes
parameters are reported in inverse form (e.g., a delay might be reported
as per day instead of days). Here we carry out a very simple
transformation to convert these to the correct form by inverting the
parameter value and the uncertainty bounds. This may not be appropriate
in all cases, and must be checked on a case-by-case basis. This function
takes a data frame as input and inverts the values of selected
parameters. The selected parameters are identified by the column
'inverse_param'. The function performs the following operations:

- Inverts the parameter values of the selected parameters.

- Swaps the upper and lower bounds of the selected parameters.

- Inverts the uncertainty values of the selected parameters.

- Updates the logical vector to indicate that the parameters are no
  longer inverted.

- Does not change the unit of the parameters, as it remains the same as
  the original parameter.

## Usage

``` r
invert_inverse_params(df)
```

## Arguments

- df:

  A data frame containing the parameters to be inverted.

## Value

The input data frame with the selected parameters inverted.

## Examples

``` r
df <- data.frame(
  parameter_value = c(2, 3, 4),
  parameter_upper_bound = c(5, 6, 7),
  parameter_lower_bound = c(1, 2, 3),
  parameter_uncertainty_upper_value = c(0.1, 0.2, 0.3),
  parameter_uncertainty_lower_value = c(0.4, 0.5, 0.6),
  inverse_param = c(FALSE, TRUE, FALSE)
)
invert_inverse_params(df)
#>   parameter_value parameter_upper_bound parameter_lower_bound
#> 1       2.0000000                   5.0             1.0000000
#> 2       0.3333333                   0.5             0.1666667
#> 3       4.0000000                   7.0             3.0000000
#>   parameter_uncertainty_upper_value parameter_uncertainty_lower_value
#> 1                               0.1                               0.4
#> 2                               2.0                               5.0
#> 3                               0.3                               0.6
#>   inverse_param
#> 1         FALSE
#> 2         FALSE
#> 3         FALSE
# Output:
```
