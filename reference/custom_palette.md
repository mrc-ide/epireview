# Create a custom color palette.

This utility function creates a named color vector from user-supplied
vectors of labels and color values. The length of the label and color
vectors must be the same. The resulting custom color palette can be used
as the color palette in other plotting functions.

## Usage

``` r
custom_palette(labels, colors)
```

## Arguments

- labels:

  A vector of labels to be used as names for the custom color palette.

- colors:

  A vector of colors to be used for the custom color palette. This can
  be in the form of HEX codes, e.g., "#808080" or color names recognized
  by R, eg "deepskyblue"

## Value

A custom palette in the form of a named color vector.

## Examples

``` r
labels <- c("Liberia", "Guinea", "Sierra Leone")
colors <- c("#5A5156FF", "#E4E1E3FF", "#5050FFFF")

custom_pal <- custom_palette(labels, colors)
custom_pal
#>      Liberia       Guinea Sierra Leone 
#>  "#5A5156FF"  "#E4E1E3FF"  "#5050FFFF" 
```
