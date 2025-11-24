# Prepare parameter dataframe for meta analysis of means

Prepare parameter dataframe for meta analysis of means

## Usage

``` r
filter_df_for_metamean(df)
```

## Arguments

- df:

  a parameter dataframe. This must have columns for each of the
  following: parameter_value, parameter_unit, population_sample_size,
  parameter_value_type, parameter_uncertainty_singe_type,
  parameter_uncertainty_type, parameter_uncertainty_lower_value,
  parameter_uncertainty_upper_value. This will typically be the `params`
  data.frame from the output of `load_epidata`.

## Value

a parameter dataframe with relevant rows selected and additional columns
added to facilitate the meta analysis of means. The additional columns
are: xbar, median, q1, q3, min, max.

## Details

The function checks that the format of df is adequate for conducting a
meta analysis of means. It filters the dataframe to only include rows
that meet the required format. We can only conduct a meta analysis for a
parameter if its estimates have been reported as (a) mean and standard
deviation, (b) median and interquartile range, or (c) median and range.
This function filters the parameter dataframe to only include rows that
meet these criteria. It also checks that the parameter values are all in
the same units; and that the sample size is reported for each parameter
value.

## Examples

``` r
## preparing data for meta analyses of delay from symptom onset to
## hospitalisation for Lassa

df <- load_epidata("lassa")[["params"]]
#> ✔ Data loaded for lassa
o2h_df <- df[df$parameter_type %in% "Human delay - symptom onset>admission to care", ]
o2h_df_filtered <- filter_df_for_metamean(o2h_df)
#> parameter_value must be present if parameter_unit is present. 1 row with non-NA
#> parameter_value and NA parameter_unit will be removed.
## o2h_df_filtered could then be used directly in meta analyses as:
## mtan <- metamean(data = o2h_df_filtered, ...)
```
