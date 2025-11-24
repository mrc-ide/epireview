# model_column_type

This function defines the column types for the models in the dataset. It
returns a list of column types with their corresponding names.

## Usage

``` r
model_column_type()
```

## Value

A list of column types for the article data frame

## See also

parameter_column_type, outbreak_column_type, model_column_type

## Examples

``` r
model_column_type()
#> $id
#> <collector_character>
#> 
#> $model_data_id
#> <collector_character>
#> 
#> $article_id
#> <collector_integer>
#> 
#> $pathogen
#> <collector_character>
#> 
#> $ebola_variant
#> <collector_character>
#> 
#> $model_type
#> <collector_character>
#> 
#> $compartmental_type
#> <collector_character>
#> 
#> $stoch_deter
#> <collector_character>
#> 
#> $theoretical_model
#> <collector_logical>
#> 
#> $interventions_type
#> <collector_character>
#> 
#> $code_available
#> <collector_logical>
#> 
#> $transmission_route
#> <collector_character>
#> 
#> $assumptions
#> <collector_character>
#> 
#> $covidence_id
#> <collector_integer>
#> 
```
