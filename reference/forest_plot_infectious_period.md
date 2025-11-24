# Create forest plot for infectious period

Create forest plot for infectious period

## Usage

``` r
forest_plot_infectious_period(df, ulim = 30, reorder_studies = TRUE, ...)
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

## Details

This function is a wrapper for
[`forest_plot_delay_int`](https://mrc-ide.github.io/epireview/reference/forest_plot_delay_int.md)
that is specifically for the infectious period.
