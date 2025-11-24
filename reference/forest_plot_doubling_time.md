# Forest plot for doubling time

This function calculates the doubling time and creates a forest plot to
visualize the results.

## Usage

``` r
forest_plot_doubling_time(df, ulim = 30, reorder_studies = TRUE, ...)
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

A forest plot object.

## Examples

``` r
df <- load_epidata("ebola")[["params"]]
#> ℹ ebola does not have any extracted outbreaks
#> information. Outbreaks will be set to NULL.
#> ✔ Data loaded for ebola
forest_plot_doubling_time(df, ulim = 20, reorder_studies = TRUE)
#> Warning: The maximum doubling time is 61 ; the ulim is set to 20 . Some points may not
#> be plotted. Consider increasing ulim.
#> Warning: No parameters to invert.
#> Warning: Removed 2 rows containing missing values or values outside the scale range
#> (`geom_point()`).
```
