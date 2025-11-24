# Distinguish multiple estimates from the same study

Distinguish multiple estimates from the same study

## Usage

``` r
mark_multiple_estimates(
  df,
  col = "parameter_type",
  label_type = c("letters", "numbers")
)
```

## Arguments

- df:

  The data frame containing the estimates.

- col:

  The column name that identifies multiple enteries for a study.
  Duplicate values in this column for a study will be marked with a
  suffix. Although the user can choose any column here, the most logical
  choices are: for parameters - "parameter_type"; for models -
  "model_type"; for outbreaks - "outbreak_country".

- label_type:

  Type of labels to add to distinguish multiple estimates. Must be one
  of "letters" or "numbers".

## Value

The modified data frame with updated article_label

## Details

If a study has more than one estimate/model/outbreak for the same
parameter_type/model/outbreak, we add a suffix to the article_label to
distinguish them otherwise they will be plotted on the same line in the
forest plot. Say we have two estimates for the same parameter_type (p)
from the same study (s), they will then be labeled as s 1 and s 2.

## Examples

``` r
df <- data.frame(
  article_label = c("A", "A", "B", "B", "C"),
  parameter_type = c("X", "X", "Y", "Y", "Z")
)
mark_multiple_estimates(df, label_type = "numbers")
#>   article_label parameter_type
#> 1         A (1)              X
#> 2         A (2)              X
#> 3         B (1)              Y
#> 4         B (2)              Y
#> 5             C              Z
```
