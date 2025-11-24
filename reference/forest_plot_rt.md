# Generate a forest plot for effective reproduction number (Rt)

This function generates a forest plot for the effective reproduction
number (Rt) using the provided data frame.

## Usage

``` r
forest_plot_rt(df, ulim = 10, reorder_studies = TRUE, ...)
```

## Arguments

- df:

  The data frame containing the necessary data for generating the forest
  plot.

- ulim:

  The upper limit for the x-axis of the plot. Default is 10.

- reorder_studies:

  Logical. If TRUE, the studies will be reordered using the
  [`reorder_studies`](https://mrc-ide.github.io/epireview/reference/reorder_studies.md)
  function. Default is TRUE.

- ...:

  Additional arguments to be passed to the
  [`forest_plot`](https://mrc-ide.github.io/epireview/reference/forest_plot.md)
  function.

## Value

A ggplot2 object representing the forest plot for effective reproduction
number (Rt).

## Examples

``` r
df <- load_epidata("ebola")[["params"]]
#> ℹ ebola does not have any extracted outbreaks
#> information. Outbreaks will be set to NULL.
#> ✔ Data loaded for ebola
forest_plot_rt(df)
#> Warning: Removed 24 rows containing missing values or values outside the scale range
#> (`geom_point()`).

```
