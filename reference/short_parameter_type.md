# Short labels parameters for use in figures

Short labels parameters for use in figures

## Usage

``` r
short_parameter_type(x, parameter_type_full, parameter_type_short)
```

## Arguments

- x:

  data.frame containing a column called "parameter_type", This will
  typically be the `params` data.frame from the output of
  [`load_epidata`](https://mrc-ide.github.io/epireview/reference/load_epidata.md).

- parameter_type_full:

  optional. User can specify the full name of a parameter type not
  already included in the function.

- parameter_type_short:

  optional. Shorter value of parameter_type_full

## Value

data.frame with a new column called "parameter_type_short"

## Details

This function assigns short labels to otherwise very long parameter
names. It is generally not intended to be called directly but is used by
[`load_epidata`](https://mrc-ide.github.io/epireview/reference/load_epidata.md)
when the data is loaded. The short parameter names are read from the
file "param_name.csv" in the package. If you want to supply your own
short names, you can do so by specifying the parameter_type_full and
parameter_type_short arguments. Note however that if parameter_type_full
does not contain all the parameter types in the data, the short label
(parameter_type_short) will be NA for missing values. It is therefore
easier and recommended that you update the column parameter_type_short
once the data are loaded via
[`load_epidata`](https://mrc-ide.github.io/epireview/reference/load_epidata.md).

## Author

Sangeeta Bhatia
