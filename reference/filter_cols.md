# Filter columns of a data frame based on specified conditions.

This function filters the rows of a data frame based on specified
conditions for selected columns.

## Usage

``` r
filter_cols(x, cols, funs = c("in", "==", ">", "<"), vals)
```

## Arguments

- x:

  A data frame.

- cols:

  A character vector specifying the columns to be filtered.

- funs:

  A character vector specifying the filter functions for each column.
  Each function must be one of "in", "==", "\>", "\<" in quotes.

- vals:

  A list of values to be used for filtering columns in `cols`.

## Value

A data frame with rows filtered based on the specified conditions.

## Examples

``` r
x <- load_epidata("marburg")
#> Warning: There is 1 article with missing first author surname.
#> Warning: There is 1 article with missing first author surname and first author first
#> name.
#> Warning: There is 1 article with missing year of publication.
#> Warning: Unknown or uninitialised column: `other_delay_start`.
#> Warning: Unknown or uninitialised column: `other_delay_end`.
#> Note: the params dataframe does not have a covidence_id column
#> Note: the models dataframe does not have a covidence_id column
#> Note: the outbreaks dataframe does not have a covidence_id column
#> ✔ Data loaded for marburg
p <- x$params
filter_cols(p, "parameter_type", "==", "Attack rate")
#> # A tibble: 1 × 61
#>   parameter_data_id     article_id parameter_type parameter_value parameter_unit
#>   <chr>                      <int> <chr>                    <dbl> <chr>         
#> 1 aaee8bee0e1498de490f…         21 Attack rate                 21 Percentage (%)
#> # ℹ 56 more variables: parameter_lower_bound <dbl>,
#> #   parameter_upper_bound <dbl>, parameter_value_type <chr>,
#> #   parameter_uncertainty_single_value <dbl>,
#> #   parameter_uncertainty_singe_type <chr>,
#> #   parameter_uncertainty_lower_value <dbl>,
#> #   parameter_uncertainty_upper_value <dbl>, parameter_uncertainty_type <chr>,
#> #   cfr_ifr_numerator <int>, cfr_ifr_denominator <int>, …
filter_cols(
  p, "parameter_type", "in",
  list(parameter_type = c("Attack rate", "Seroprevalence - IFA"))
)
#> # A tibble: 11 × 61
#>    parameter_data_id    article_id parameter_type parameter_value parameter_unit
#>    <chr>                     <int> <chr>                    <dbl> <chr>         
#>  1 9b3a85f48c60fd7f46d…          5 Seroprevalenc…            NA   NA            
#>  2 aaee8bee0e1498de490…         21 Attack rate               21   Percentage (%)
#>  3 ce78f707a585d8bb23a…         22 Seroprevalenc…             0   Percentage (%)
#>  4 ca720828fd6ccb18844…         22 Seroprevalenc…             0   NA            
#>  5 61fbb9dfc021abf5bd1…         22 Seroprevalenc…             0   Percentage (%)
#>  6 8cc2b414c713a0ea293…         24 Seroprevalenc…            NA   NA            
#>  7 89a22c901bff8cd51e7…         43 Seroprevalenc…             0   Percentage (%)
#>  8 ea4eadb1df08fcda05f…          7 Seroprevalenc…             3.2 Percentage (%)
#>  9 1723916e6c477bd15e4…         55 Seroprevalenc…             0   NA            
#> 10 899e4984d6c23191208…         47 Seroprevalenc…             1.3 Percentage (%)
#> 11 7d1da61c69b1e13950b…          8 Seroprevalenc…             1.7 Percentage (%)
#> # ℹ 56 more variables: parameter_lower_bound <dbl>,
#> #   parameter_upper_bound <dbl>, parameter_value_type <chr>,
#> #   parameter_uncertainty_single_value <dbl>,
#> #   parameter_uncertainty_singe_type <chr>,
#> #   parameter_uncertainty_lower_value <dbl>,
#> #   parameter_uncertainty_upper_value <dbl>, parameter_uncertainty_type <chr>,
#> #   cfr_ifr_numerator <int>, cfr_ifr_denominator <int>, …
```
