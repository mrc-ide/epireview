# Define a consistent color palette for use in figures. Palettes are currently defined for parameters and countries. Any other variable will return NULL

Define a consistent color palette for use in figures. Palettes are
currently defined for parameters and countries. Any other variable will
return NULL

## Usage

``` r
color_palette(col_by = c("parameter_type", "population_country"), ...)
```

## Arguments

- col_by:

  a character vector specifying the parameter to color the palette by.

- ...:

  additional arguments to be passed to the underlying palette function.
  These are treated as names of the palette elements.

## Value

a named list of colors that can be used in forest plots for manually
setting colors

## Examples

``` r
color_palette("parameter_type")
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
