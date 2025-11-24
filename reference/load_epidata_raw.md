# Loads raw data for a particular pathogen

Loads raw data for a particular pathogen

## Usage

``` r
load_epidata_raw(
  pathogen,
  table = c("article", "parameter", "outbreak", "model", "param_name")
)
```

## Arguments

- pathogen:

  name of pathogen. This argument is case-insensitive. Must be one of
  the priority pathogens You can get a list of the priority pathogens
  currently included in the package by calling the function
  [`priority_pathogens`](https://mrc-ide.github.io/epireview/reference/priority_pathogens.md).

- table:

  the table to be loaded. Must be one of "article", "parameter",
  "outbreak", "model" or "param_name"

## Value

data.frame reading in the csv the specified pathogen table

## Details

This function will return the raw data as a data.frame. The csv files of
the models, outbreaks, and parameters for a pathogen do not contain
information on the source but only an "article_id" that can be used to
merge them with the articles. If you wish to retrieve linked information
or multiple tables at the same time, use `load_epidata` instead.

## See also

[`load_epidata()`](https://mrc-ide.github.io/epireview/reference/load_epidata.md)
for a more user-friendly interface

## Examples

``` r
load_epidata_raw(pathogen = "marburg", table = "outbreak")
#> Warning: The following columns were not specified in col_types: covidence_id.x,
#> outbreak_data_id, covidence_id.y
#> Warning: These columns will be read in as character vectors.
#> Warning: Data contributors: please carefully check that this does not lead to loss of
#> information. If it does, please update the column types in the epireview
#> package and submit a PR.
#> # A tibble: 23 × 24
#>    outbreak_id article_id outbreak_start_day outbreak_start_month
#>    <chr>            <int>              <dbl> <chr>               
#>  1 4                   20                 NA Aug                 
#>  2 5                   23                 18 Aug                 
#>  3 6                   23                 18 Oct                 
#>  4 7                   21                 NA Oct                 
#>  5 10                  33                 NA NA                  
#>  6 12                  42                 NA Jul                 
#>  7 13                  45                 NA Oct                 
#>  8 14                  49                 10 Jun                 
#>  9 17                  57                 NA Oct                 
#> 10 19                  60                 12 Feb                 
#> # ℹ 13 more rows
#> # ℹ 20 more variables: outbreak_start_year <dbl>, outbreak_end_day <dbl>,
#> #   outbreak_end_month <chr>, outbreak_date_year <dbl>,
#> #   outbreak_duration_months <dbl>, outbreak_size <dbl>,
#> #   asymptomatic_transmission <lgl>, outbreak_country <chr>,
#> #   outbreak_location <chr>, cases_confirmed <dbl>, cases_mode_detection <chr>,
#> #   cases_suspected <int>, cases_asymptomatic <int>, deaths <int>, …
```
