# priority_pathogens

This data set gives the list of WHO priority pathogens for which the
Pathogen Epidemiology Review Group (PERG) has carried out a systematic
review. The data set gives the name of the pathogen as used in the
package and associated information with the review.

## Usage

``` r
priority_pathogens()
```

## Value

data.frame with the following fields

- pathogen: name of the pathogen as used in the package

- articles_screened: number of titles and abstracts screened for
  inclusion

- articles_extracted: number of articles from which data were extracted

- doi: doi of the accompanying systematic review

## Details

Data on the priority pathogens included in the systematic review

## Examples

``` r
priority_pathogens()
#>   pathogen articles_screened articles_extracted                           doi
#> 1  marburg              4460                 42 10.1016/S1473-3099(23)00515-7
#> 2    ebola              9563                520 10.1016/S1473-3099(24)00374-8
#> 3    lassa              5414                157   10.1101/2024.03.23.24304596
#> 4     sars             14929                288   10.1101/2024.08.13.24311934
#> 5     zika             27491                574   10.1101/2025.07.10.25331254
#>         articles_file           params_file       models_file
#> 1 marburg_article.csv marburg_parameter.csv marburg_model.csv
#> 2  ebola_articles.csv  ebola_parameters.csv  ebola_models.csv
#> 3  lassa_articles.csv  lassa_parameters.csv  lassa_models.csv
#> 4   sars_articles.csv   sars_parameters.csv   sars_models.csv
#> 5   zika_articles.csv   zika_parameters.csv   zika_models.csv
#>         outbreaks_file
#> 1 marburg_outbreak.csv
#> 2                 <NA>
#> 3  lassa_outbreaks.csv
#> 4                 <NA>
#> 5   zika_outbreaks.csv
```
