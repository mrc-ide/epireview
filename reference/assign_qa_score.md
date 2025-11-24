# Assign quality assessment score to each article

Assign quality assessment score to each article

## Usage

``` r
assign_qa_score(articles, ignore_errors = FALSE)
```

## Arguments

- articles:

  data.frame loaded from `load_epidata` function

- ignore_errors:

  logical; if `TRUE`, the function will assign QA scores where possible
  (i.e. where all answers to quality assessment questions are not NA)
  and set the QA score to NAfor articles where all answers are NA. If
  `FALSE`, an error is thrown instead.

## Value

a named list consisting of two elements. The first element of the list
is the article data.frame with an updated column containing three new
columns: `qs_denominator` (total number of questions answered),
`qs_numerator` (number of questions answered 'yes') and `qa_score` (QA
score). The second element of the list (named errors) is a data.frame
containing articles with all NA answers.

## Details

We have used a bespoke 7 question quality assessment (QA) questionnaire
to assess the quality of articles. The questions can be retrieved using
the `qa_questions` function. The function assigns a QA score to each
article as the number of questions answered 'yes' divided by the total
number of questions answered (an answer might be NA if the question is
not relevant to the article under consideration). Articles with all NA
answers are excluded from the QA unless `ignore_errors` is set to
`TRUE`.

## See also

[`qa_questions`](https://mrc-ide.github.io/epireview/reference/qa_questions.md)

## Examples

``` r
lassa <- load_epidata("lassa")
#> ✔ Data loaded for lassa
lassa_qa <- assign_qa_score(lassa$articles, ignore_errors = FALSE)
head(lassa_qa$articles[, c("qa_denominator", "qa_numerator", "qa_score")])
#> # A tibble: 6 × 3
#>   qa_denominator qa_numerator qa_score
#>            <int>        <int>    <dbl>
#> 1              5            2      0.4
#> 2              5            2      0.4
#> 3              2            2      1  
#> 4              5            1      0.2
#> 5              5            2      0.4
#> 6              5            2      0.4
```
