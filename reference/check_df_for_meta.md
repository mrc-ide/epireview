# Sanity checks before meta-analysis

Sanity checks before meta-analysis

## Usage

``` r
check_df_for_meta(df, cols_needed)
```

## Arguments

- df:

  a parameter dataframe. This must have columns for each of the
  following: parameter_value, parameter_unit, plus two columns for the
  numerator and the denominator of the proportion of interest. This
  dataframe will typically be the `params` data.frame from the output of
  [`load_epidata`](https://mrc-ide.github.io/epireview/reference/load_epidata.md).

- cols_needed:

  a character vector specifying the names of the columns required for
  the meta-analysis.

## Value

a parameter dataframe with offending rows removed.

## Details

The function carries out a series of checks on the parameter dataframe
to ensure that it is in the correct format for conducting a
meta-analysis. It checks that the input (1) consists of a single
parameter type; (2) has the columns required for the meta-analysis; (3)
does not have any row where a value is present but the unit is missing,
or vice versa. All such rows are removed; and (4) has the same unit
across all values of the parameter. The function will throw an error if
either there is more than one value of parameter_type, or if the columns
needed for the meta-analysis are missing, or if the parameter_unit is
not the same across all values of the parameter.
