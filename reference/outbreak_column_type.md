# outbreak_column_type

This function defines the column types for the outbreaks in the dataset.
It returns a list of column types with their corresponding names.

## Usage

``` r
outbreak_column_type()
```

## Value

A list of column types for the article data frame

## See also

parameter_column_type, outbreak_column_type, model_column_type

## Examples

``` r
outbreak_column_type()
#> $outbreak_id
#> <collector_character>
#> 
#> $id
#> <collector_character>
#> 
#> $article_id
#> <collector_integer>
#> 
#> $outbreak_start_day
#> <collector_double>
#> 
#> $outbreak_start_month
#> <collector_character>
#> 
#> $outbreak_start_year
#> <collector_double>
#> 
#> $outbreak_end_day
#> <collector_double>
#> 
#> $outbreak_end_month
#> <collector_character>
#> 
#> $outbreak_date_year
#> <collector_double>
#> 
#> $outbreak_duration_months
#> <collector_double>
#> 
#> $outbreak_size
#> <collector_double>
#> 
#> $asymptomatic_transmission
#> <collector_logical>
#> 
#> $outbreak_country
#> <collector_character>
#> 
#> $outbreak_location
#> <collector_character>
#> 
#> $cases_confirmed
#> <collector_double>
#> 
#> $cases_mode_detection
#> <collector_character>
#> 
#> $cases_suspected
#> <collector_integer>
#> 
#> $cases_asymptomatic
#> <collector_integer>
#> 
#> $deaths
#> <collector_integer>
#> 
#> $cases_severe_hospitalised
#> <collector_integer>
#> 
#> $covidence_id
#> <collector_integer>
#> 
#> $cases_severe
#> <collector_integer>
#> 
#> $cases_unspecified
#> <collector_integer>
#> 
#> $female_cases
#> <collector_integer>
#> 
#> $male_cases
#> <collector_integer>
#> 
#> $ongoing
#> <collector_logical>
#> 
#> $population_size
#> <collector_integer>
#> 
#> $pre_outbreak
#> <collector_character>
#> 
#> $prop_female_cases
#> <collector_double>
#> 
#> $prop_male_cases
#> <collector_double>
#> 
#> $type_cases_sex_disagg
#> <collector_character>
#> 
#> $outbreak_start_date
#> <collector_character>
#> 
#> $pathogen
#> <collector_character>
#> 
```
