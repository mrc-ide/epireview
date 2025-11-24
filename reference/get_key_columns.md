# Subset the epidemiological parameter columns by parameter type

Subset the epidemiological parameter columns by parameter type

## Usage

``` r
get_key_columns(
  data,
  parameter_name = c("cfr", "delays", "sero", "risk_factors", "reproduction_number",
    "genomic", "attack_rate", "doubling_time", "growth_rate", "overdispersion",
    "relative_contribution"),
  all_columns = FALSE
)
```

## Arguments

- data:

  The parameter `data.frame` (`$param`) from
  [`load_epidata()`](https://mrc-ide.github.io/epireview/reference/load_epidata.md).

- parameter_name:

  A `character` string with the parameter name. Options are: `"cfr"`,
  `"delay"`, `"sero"`, `"risk"`, `"reproduction_number"`, and
  `"genomic"`.

- all_columns:

  The default is FALSE meaning that only the key columns specified for
  the specific parameter will be retrieved. If TRUE, then all columns in
  the data.frame will be retrieved.

## Value

A `data.frame` with the key columns for the selected parameter.

## Examples

``` r
lassa_data <- load_epidata("lassa")
#> ✔ Data loaded for lassa
lassa_params <- lassa_data$params
cfr_lassa <- get_parameter(
  data = lassa_params,
  parameter_name = "Severity - case fatality rate (CFR)"
)
get_key_columns(data = cfr_lassa, parameter_name = "cfr")
#> # A tibble: 85 × 12
#>    article_label   article_info        population_country population_sample_size
#>    <chr>           <chr>               <chr>                               <int>
#>  1 Webb 1986       Webb 1986 (Transac… Sierra Leone                          225
#>  2 ter Meulen 1998 ter Meulen 1998 (J… Guinea                                 12
#>  3 Shehu 2018      10.3389/fpubh.2018… Nigeria                                11
#>  4 Shaffer 2014    10.1371/journal.pn… Sierra Leone                         1740
#>  5 Roth 2015       10.4269/ajtmh.14-0… Sierra Leone                           21
#>  6 Price 1988 (1)  Price 1988 (Britis… Sierra Leone                           68
#>  7 Price 1988 (2)  Price 1988 (Britis… Sierra Leone                           79
#>  8 White 1972      White 1972 (Transa… Nigeria                                23
#>  9 Okokhere 2018   10.1016/S1473-3099… Nigeria                               284
#> 10 Knobloch 1980   Knobloch 1980 (Tro… Guinea, Liberia, …                     42
#> # ℹ 75 more rows
#> # ℹ 8 more variables: population_sample_type <chr>, population_group <chr>,
#> #   method_disaggregated <lgl>, parameter_type <chr>, parameter_value <dbl>,
#> #   cfr_ifr_numerator <int>, cfr_ifr_denominator <int>, cfr_ifr_method <chr>
```
