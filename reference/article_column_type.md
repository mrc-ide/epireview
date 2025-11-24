# Define the column types for the article data frame

This function defines the column types for the article data frame used
in the epireview package. vroom is generally good at guessing the column
types, but it is better to be explicit. Moreover, it reads a column of
NAs as a logical vector, which is particularly undesirable for us. This
function is intended to be used internally by `load_epidata_raw` where
the files are being read.

## Usage

``` r
article_column_type(pathogen)
```

## Arguments

- pathogen:

  name of pathogen. This argument is case-insensitive. Must be one of
  the priority pathogens You can get a list of the priority pathogens
  currently included in the package by calling the function
  [`priority_pathogens`](https://mrc-ide.github.io/epireview/reference/priority_pathogens.md).

## Value

A list of column types for the article data frame

## See also

parameter_column_type, outbreak_column_type, model_column_type
