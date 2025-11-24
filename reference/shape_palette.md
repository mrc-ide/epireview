# shape_palette function

This function generates a shape palette based on the specified shape_by
parameter.

## Usage

``` r
shape_palette(shape_by = c("parameter_value_type"), ...)
```

## Arguments

- shape_by:

  A character vector specifying the parameter to shape the palette by.
  Currently, only "value_type" is supported.

- ...:

  Additional arguments to be passed to the underlying palette function.
  These are treated as names of the palette elements.

## Value

A shape palette based on the specified shape_by parameter.

## Examples

``` r
shape_palette("parameter_value_type")
#> $Mean
#> [1] 16
#> 
#> $mean
#> [1] 16
#> 
#> $average
#> [1] 16
#> 
#> $Median
#> [1] 15
#> 
#> $median
#> [1] 15
#> 
#> $`Std Dev`
#> [1] 17
#> 
#> $`std dev`
#> [1] 17
#> 
#> $sd
#> [1] 17
#> 
#> $other
#> [1] 18
#> 
#> $Other
#> [1] 18
#> 
#> $Unspecified
#> [1] 5
#> 
#> $unspecified
#> [1] 5
#> 
```
