# Include key article information when DOI is missing

This function appends pretty_article_label to include the journal and we
use this information to fill in any entry where the DOI is missing.
(Note: DOIs were introduced in the late 1990s and so articles from
before this time often do not have one.)

## Usage

``` r
update_article_info(articles)
```

## Arguments

- articles:

  A data frame containing information about the articles. This will
  typically be the output of `load_epidata_raw`.

## Value

A modified data frame with an updated column "doi" with NA values
replaced with either (1) article_label appended to include journal where
available or (2) just article_label when journal entry is NA.

## Examples

``` r
articles <- data.frame(
  doi = c("10.123", NA, "10.234"),
  article_label = c("Smith 2020", "Smith 1979", "Smith 2023"),
  journal = c("Science", "Nature", "The Lancet")
)
update_article_info(articles)
#>      doi article_label    journal        article_info
#> 1 10.123    Smith 2020    Science              10.123
#> 2   <NA>    Smith 1979     Nature Smith 1979 (Nature)
#> 3 10.234    Smith 2023 The Lancet              10.234
```
