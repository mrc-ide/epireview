# Define a consistent color palette for use in figures

Define a consistent color palette for use in figures

## Usage

``` r
parameter_palette(x = NULL)
```

## Arguments

- x:

  a list of parameters. Optional. If missing, the entire palette is
  returned.

## Value

a named list of colors that can be used in forest plots for manually
setting colors with for example
[`scale_color_manual`](https://ggplot2.tidyverse.org/reference/scale_manual.html)

## Author

Sangeeta Bhatia

## Examples

``` r
parameter_palette()
#> $`Basic (R0)`
#> [1] "#D95F02"
#> 
#> $`Reproduction number (Basic R0)`
#> [1] "#D95F02"
#> 
#> $`Effective (Re)`
#> [1] "#7570B3"
#> 
#> $`Reproduction number (Effective, Re)`
#> [1] "#7570B3"
#> 
```
