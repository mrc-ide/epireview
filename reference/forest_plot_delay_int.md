# Create forest plot for human delays

Create forest plot for human delays

## Usage

``` r
forest_plot_delay_int(df, ulim, reorder_studies, ...)
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

returns plot with a summary of the human delays

## Details

There are a number of 'delays' that are relevant to the pathogens we
study. Some of the more commonly, and hence likely to be extracted for
most pathogens, are infectious period, incubation period, and serial
interval. However, there are many others reported by relatively few
studies or relevant to only a few pathogens. This function is intended
to serve as a template for creating forest plots for these delays. It
will first reparameterise any delays reported in terms of the gamma
distribution to the mean and standard deviation (see
[`reparam_gamma`](https://mrc-ide.github.io/epireview/reference/reparam_gamma.md)).
Then, any parameters reported as inverse (e.g., per day instead of days)
will be inverted (see
[`invert_inverse_params`](https://mrc-ide.github.io/epireview/reference/invert_inverse_params.md)).
Finally, all delays will be converted to days (see
[`delays_to_days`](https://mrc-ide.github.io/epireview/reference/delays_to_days.md))
before reordering the studies (if requested) and plotting the forest
plot. We also provide some utility functions for the commonly used
delays that are simply wrapper for this function. If however you are
interested in some other delay, you will need to use this function
directly, ensuring that the data frame you provide has only the relevant
delays.

## See also

[`forest_plot_serial_interval`](https://mrc-ide.github.io/epireview/reference/forest_plot_serial_interval.md)
