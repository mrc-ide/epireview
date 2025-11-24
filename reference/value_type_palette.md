# Define a consistent shape palette for use in forest plots We map shape aesthetic to value type i.e., mean, median etc. This function defines a shape palette that can be used in forest plots

Define a consistent shape palette for use in forest plots We map shape
aesthetic to value type i.e., mean, median etc. This function defines a
shape palette that can be used in forest plots

## Usage

``` r
value_type_palette(x = NULL)
```

## Arguments

- x:

  a list of parameters

## Value

a named list of shapes where names are value types (mean, median, std
dev etc.)

## Author

Sangeeta Bhatia

## Examples

``` r
value_type_palette()
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
