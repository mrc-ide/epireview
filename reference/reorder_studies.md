# Reorder articles based on parameter value

This function takes a dataframe as input (this will typically be params
data.frame from the output of
[`load_epidata`](https://mrc-ide.github.io/epireview/reference/load_epidata.md))
and reorders it to provide a sensible order for plotting. For each
country, studies are ordered by the parameter value or the midpoint of
the parameter range if the parameter value is missing. It creates a new
column 'y' which is an ordered factor with levels corresponding to the
article_label. To order the studies in some other way, set
reorder_studies to FALSE in the parameter specific forest plot functions
(e.g.
[`forest_plot_rt`](https://mrc-ide.github.io/epireview/reference/forest_plot_rt.md)).

## Usage

``` r
reorder_studies(df, reorder_by = "population_country")
```

## Arguments

- df:

  The input dataframe to be reordered

- reorder_by:

  character. The name of the column to reorder the data by. Default is
  "population_country"

## Value

The reordered dataframe

## See also

[`forest_plot_rt`](https://mrc-ide.github.io/epireview/reference/forest_plot_rt.md)
[`forest_plot_r0`](https://mrc-ide.github.io/epireview/reference/forest_plot_r0.md)

## Examples

``` r
ebola <- load_epidata("ebola")
#> ℹ ebola does not have any extracted outbreaks
#> information. Outbreaks will be set to NULL.
#> ✔ Data loaded for ebola
params <- ebola$params
rt <- params[params$parameter_type == "Reproduction number (Effective, Re)", ]

reorder_studies(param_pm_uncertainty(rt))
#> # A tibble: 91 × 83
#>    id     parameter_data_id covidence_id pathogen parameter_type parameter_value
#>    <chr>  <chr>                    <int> <chr>    <chr>                    <dbl>
#>  1 472ee… a97b0a0cd787228e…        23719 Ebola v… Reproduction …            0.33
#>  2 f22ca… baf56944162b6acc…          404 Ebola v… Reproduction …            0.73
#>  3 59052… f09308ea7f9dfa18…        17881 Ebola v… Reproduction …           NA   
#>  4 54159… 9254ff2db0ac53e8…         3138 Ebola v… Reproduction …            0.84
#>  5 d03ce… 028c5c53f6ba5d73…        19035 Ebola v… Reproduction …            0.9 
#>  6 aca68… 0fdc709369f7d292…         6003 Ebola v… Reproduction …            1.03
#>  7 59052… bd021cac38430bdf…        17881 Ebola v… Reproduction …            1.03
#>  8 07c43… dd6de5f34483b208…        17206 Ebola v… Reproduction …            1.06
#>  9 59544… 94e97cdb2fcc3029…        19291 Ebola v… Reproduction …            1.11
#> 10 8d70f… fd15f4e8f5d66c97…        17192 Ebola v… Reproduction …            1.14
#> # ℹ 81 more rows
#> # ℹ 77 more variables: exponent <int>, parameter_unit <chr>,
#> #   parameter_lower_bound <dbl>, parameter_upper_bound <dbl>,
#> #   parameter_value_type <chr>, parameter_uncertainty_single_value <dbl>,
#> #   parameter_uncertainty_singe_type <chr>,
#> #   parameter_uncertainty_lower_value <dbl>,
#> #   parameter_uncertainty_upper_value <dbl>, …
```
