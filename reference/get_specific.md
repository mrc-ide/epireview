# Retrieve all incubation period parameters for a given pathogen

Retrieve all incubation period parameters for a given pathogen

Retrieve all serial interval estimates for a given pathogen

Retrieve all generation time estimates for a given pathogen

Retrieve all delay parameters for a given pathogen

Retrieve all CFR parameters for a given pathogen

Retrieve all risk factor parameters for a given pathogen

Retrieve all genomic parameters for a given pathogen

Retrieve all reproduction number parameters for a given pathogen

Retrieve all seroprevalence parameters for a given pathogen

Retrieve all doubling time parameters for a given pathogen

Retrieve all attack rate parameters for a given pathogen

Retrieve all growth rate parameters for a given pathogen

Retrieve all overdispersion parameters for a given pathogen

Retrieve all overdispersion parameters for a given pathogen

## Usage

``` r
get_incubation_period(data, all_columns)

get_serial_interval(data, all_columns)

get_generation_time(data, all_columns)

get_delays(data, all_columns)

get_cfr(data, all_columns)

get_risk_factors(data, all_columns)

get_genomic(data, all_columns)

get_reproduction_number(data, all_columns)

get_seroprevalence(data, all_columns)

get_doubling_time(data, all_columns)

get_attack_rate(data, all_columns)

get_growth_rate(data, all_columns)

get_overdispersion(data, all_columns)

get_relative_contribution(data, all_columns)
```

## Arguments

- data:

  parameter dataframe output from
  [`load_epidata`](https://mrc-ide.github.io/epireview/reference/load_epidata.md)

- all_columns:

  The default is FALSE meaning that only the key columns specified for
  the specific parameter will be retrieved. If TRUE, then all columns in
  the data.frame will be retrieved.

## Value

dataframe with all parameter estimates of this type and key columns (see
[`get_key_columns`](https://mrc-ide.github.io/epireview/reference/get_key_columns.md))

## Examples

``` r
df <- load_epidata(pathogen = "lassa")
#> ✔ Data loaded for lassa
get_incubation_period(data = df$params, all_columns = FALSE)
#> # A tibble: 5 × 15
#>   article_label     article_info       population_country population_sample_size
#>   <chr>             <chr>              <chr>                               <int>
#> 1 Frame 1970        Frame 1970 (Ameri… Nigeria                                 3
#> 2 Ajayi 2013        10.1016/j.ijid.20… Nigeria                                20
#> 3 Akhmetzhanov 2019 10.1098/rstb.2018… Nigeria                                NA
#> 4 Joseph 2019       Joseph 2019 (Anna… Nigeria                                62
#> 5 Mertens 1973      10.4269/ajtmh.197… Liberia                                11
#> # ℹ 11 more variables: population_sample_type <chr>, population_group <chr>,
#> #   method_disaggregated <lgl>, parameter_type <chr>, parameter_value <dbl>,
#> #   parameter_unit <chr>, distribution_type <chr>,
#> #   distribution_par1_value <dbl>, distribution_par2_value <dbl>,
#> #   other_delay_start <chr>, other_delay_end <chr>
```
