# retrieve all parameters of specified type or class

retrieve all parameters of specified type or class

## Usage

``` r
get_parameter(data, parameter_name)
```

## Arguments

- data:

  parameter dataframe output from
  [`load_epidata`](https://mrc-ide.github.io/epireview/reference/load_epidata.md)

- parameter_name:

  name of the parameter type or parameter class to retrieve, ensuring
  the name matches that in data

## Value

dataframe with all parameter estimates and columns

## Examples

``` r
df <- load_epidata(pathogen = "ebola")
#> ℹ ebola does not have any extracted outbreaks
#> information. Outbreaks will be set to NULL.
#> ✔ Data loaded for ebola
get_parameter(data = df$params, parameter_name = "Human delay - serial interval")
#> # A tibble: 19 × 78
#>    id     parameter_data_id covidence_id pathogen parameter_type parameter_value
#>    <chr>  <chr>                    <int> <chr>    <chr>                    <dbl>
#>  1 f49a9… 466f684ff8286fbd…          506 Ebola v… Human delay -…            12  
#>  2 c1e68… cb37cc4599953d47…         1471 Ebola v… Human delay -…            19.4
#>  3 08e06… 20eb9e7d7714183c…         1876 Ebola v… Human delay -…            11  
#>  4 5a250… 115c169147af31f7…         1891 Ebola v… Human delay -…            11.1
#>  5 54159… 6fca288e3bca7dc0…         3138 Ebola v… Human delay -…            16.1
#>  6 f044b… 89e334ec3622ed27…         3776 Ebola v… Human delay -…            14  
#>  7 df908… e62da97ac8648211…         4966 Ebola v… Human delay -…            14.2
#>  8 df908… d46ff8b0c2ff67b7…         4966 Ebola v… Human delay -…             7.1
#>  9 1b9d9… abb8b6aabf43ac86…         5924 Ebola v… Human delay -…            13.7
#> 10 39354… 2b270d400af4fcce…         5939 Ebola v… Human delay -…            NA  
#> 11 39354… 8a18cde4823cf9f7…         5939 Ebola v… Human delay -…            NA  
#> 12 39354… 10f3384f1550a778…         5939 Ebola v… Human delay -…            NA  
#> 13 50dea… 631ec65830a82fbe…         6346 Ebola v… Human delay -…            15.3
#> 14 86e39… 5c8d68c39d1c3b98…        15896 Ebola v… Human delay -…            15.3
#> 15 40a29… 7f4ab651c48511df…        17077 Ebola v… Human delay -…            15.3
#> 16 b76dc… 0c3e02f80addfccc…        17730 Ebola v… Human delay -…            12  
#> 17 b76dc… c2e0739d6bc652e9…        17730 Ebola v… Human delay -…            11.7
#> 18 74b62… e2a59f5aa40ddbdf…        18536 Ebola v… Human delay -…            12.3
#> 19 66e1b… 4da557e3c2c22a10…        19083 Ebola v… Human delay -…            NA  
#> # ℹ 72 more variables: exponent <int>, parameter_unit <chr>,
#> #   parameter_lower_bound <dbl>, parameter_upper_bound <dbl>,
#> #   parameter_value_type <chr>, parameter_uncertainty_single_value <dbl>,
#> #   parameter_uncertainty_singe_type <chr>,
#> #   parameter_uncertainty_lower_value <dbl>,
#> #   parameter_uncertainty_upper_value <dbl>, parameter_uncertainty_type <chr>,
#> #   cfr_ifr_numerator <int>, cfr_ifr_denominator <int>, …
df <- load_epidata(pathogen = "marburg")
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
get_parameter(data = df$params, parameter_name = "Attack rate")
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
```
