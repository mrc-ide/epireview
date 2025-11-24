# Prepare parameter dataframe for meta analysis of proportions

Prepare parameter dataframe for meta analysis of proportions

## Usage

``` r
filter_df_for_metaprop(df, num_col, denom_col)
```

## Arguments

- df:

  a parameter dataframe. This must have columns for each of the
  following: parameter_value, parameter_unit, plus two columns for the
  numerator and the denominator of the proportion of interest. This
  dataframe will typically be the `params` data.frame from the output of
  [`load_epidata`](https://mrc-ide.github.io/epireview/reference/load_epidata.md).

- num_col:

  a string specifying the column name for the column containing the
  numerator of the proportion of interest.

- denom_col:

  a string specifying the column name for the column containing the
  denominator of the proportion of interest.

## Value

a parameter dataframe with relevant rows selected to enable meta
analysis of proportions.

## Details

The function checks that the format of df is adequate for conducting a
meta analysis of proportions. It filters the dataframe to only include
rows that meet the required format by (1) removing rows where the
denominator is missing, and (2) removing rows where both the numerator
column or parameter value are missing. If the numerator column is
missing and the parameter value is present, the numerator is imputed as
the parameter value divided by 100 times the denominator.

## Examples

``` r
## preparing data for meta analyses of CFR for Lassa

df <- load_epidata("lassa")[["params"]]
#> ✔ Data loaded for lassa
cfr_df <- df[df$parameter_type %in% "Severity - case fatality rate (CFR)", ]
cfr_filtered <- filter_df_for_metaprop(cfr_df,
  num_col = "cfr_ifr_numerator", denom_col = "cfr_ifr_denominator"
)
#> parameter_value must be present if parameter_unit is present. 6 rows with
#> non-NA parameter_value and NA parameter_unit will be removed.
## cfr_filtered could then be used directly in meta analyses as:
## mtan <- metaprop(data = cfr_filtered, ...)
```
