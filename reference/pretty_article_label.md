# Make pretty labels for articles

This function generates pretty labels for articles. The labels are
created by combining the surname of the first year and year of
publication of an article. If the surname is missing, we will use the
first name. If both are missing, a warning is issued and the Covidence
ID is used instead.

## Usage

``` r
pretty_article_label(articles, mark_multiple)
```

## Arguments

- articles:

  A data frame containing information about the articles. This will
  typically be the output of `load_epidata_raw`.

- mark_multiple:

  logical. If TRUE, multiple studies from the same author in the same
  year will be marked with an numeric suffix to distinguish them. See
  [`mark_multiple_estimates`](https://mrc-ide.github.io/epireview/reference/mark_multiple_estimates.md)
  for more details.

## Value

A modified data frame with an additional column "article_label"
containing the generated labels.

## Examples

``` r
articles <- data.frame(
  first_author_surname = c("Smith", NA, "Johnson"),
  first_author_first_name = c(NA, "John", NA),
  year_publication = c(2010, NA, 2022),
  covidence_id = c("ABC123", "DEF456", "GHI789")
)
pretty_article_label(articles, mark_multiple = TRUE)
#> Warning: There is 1 article with missing first author surname.
#> Warning: There is 1 article with missing year of publication.
#>   first_author_surname first_author_first_name year_publication covidence_id
#> 1                Smith                    <NA>             2010       ABC123
#> 2                 <NA>                    John               NA       DEF456
#> 3              Johnson                    <NA>             2022       GHI789
#>   article_label
#> 1    Smith 2010
#> 2   John DEF456
#> 3  Johnson 2022
```
