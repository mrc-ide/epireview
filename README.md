# Private fork of epireview

This is a provate fork of epireview. To contribute

* create a new branch from the 'develop' branch of this repo (note,
  not from the main branch)
* push your changes to your branch
* When you're happy with your work, and ready to merge, raise a PR to
  merge into develop branch, and assign Sangeeta, Rebecca or Ettie as
  reviewers.
* Before raising a PR, make sure `devtools::document()` and
  `devtools::check()` run without any warning, errors or notes. If you
  don't know what this means, message Sangeeta or Rebecca.
* If you working on an issue, add a comment to note this and assign it
  to yourself, to avoid duplication of work.

# epireview

<a href="https://github.com/mrc-ide/epireview"><img src="man/figures/hex-epireview.png" align="right" width="200" style="padding: 20px;"></a>

<!-- badges: start -->
[![R build status](https://github.com/mrc-ide/epireview/workflows/R-CMD-check/badge.svg)](https://github.com/mrc-ide/epireview/actions)
[![DOI](https://zenodo.org/badge/655602716.svg)](https://zenodo.org/badge/latestdoi/655602716)
<!-- badges: end -->

epireview is a tool to obtain the latest data, figures and tables from the Pathogen Epidemiology Review Group (PERG). This package also contains functions to update pathogen-specific databases with new data from peer-reviewed papers as they become available. This can be submitted via a pull-request and will be checked by our team.

To install the latest version of epireview, use:

```r
install.packages('epireview', repos = c('https://mrc-ide.r-universe.dev',
                                        'https://cloud.r-project.org'))
```

## Project overview
The COVID-19 pandemic has highlighted the critical role that mathematical modelling can play in supporting evidence-based decision-making during outbreaks (e.g. to project the expected epidemic size, the required hospital capacity and assess the potential population-level impact of interventions). However, early in an epidemic, modelling efforts can be hampered and delayed by the lack of a centralised resource summarising existing model structures and input parameters for the disease of interest. Literature reviews are therefore often conducted during epidemics to identify plausible parameter ranges and/or existing mathematical model structures (e.g. Van Kerkhove et al. Scientific data 2015) and are mostly limited to individual parameters.

A group of ~20 volunteer researchers currently or formerly at Imperial College London with an interest in outbreaks are working together to systematically review the mathematical models and parameters for the nine World Health Organization (WHO) 2019 blue-print priority pathogens: Nairo virus (Crimean-Congo haemorrhagic fever), Ebola virus, Henipa virus, Lassa mammarenavirus, Marburg virus, Middle East respiratory syndrome coronavirus (MERS-CoV), Rift Valley fever virus, Severe Acute Respiratory Syndrome coronavirus (SARS-CoV-1), and Zika virus. These are pathogens, or strains thereof, for which there are no approved vaccines or treatments and hence where we anticipate mathematical modelling is likely to play a major role in supporting the epidemic response. We do not include SARS-CoV-2 because vaccines exist for this pathogen and the body of literature far exceeds the capacity of our team. For each pathogen, we will review published mathematical models, information on transmission, evolution, natural history and severity, as well as seroprevalence studies and reported sizes of previous outbreaks. The quality of each paper will also be assessed as part of the review. 

## Pathogen database
One output of this project will be a database initially populated with all the information extracted that can be easily updated with new parameter estimates or information on additional pathogens as these become available. 

1. The code in this repository provides functions to access the data for each pathogen. We will update the repository as we progress through this work. An expected timeline is provided in the below table.
2. We provide functionality to update existing databases with new data as new research (in line with the inclusion and exclusion criteria) becomes available.
3. Tables and figures for each pathogen can be updated once new data is added to the database.
4. Vignettes and the github wiki contain all required information on the data.
5. We will add functionality to create/add new pathogens which are not currently included in the review. 

## Pathogen overview and timeline

| Pathogen  | Titles & Abstracts screened | Contact | doi|
| --------- |         -------------------:|      -- | -- |
| Marburg virus | 4,460 | cm401@ic.ac.uk, gc4018@ic.ac.uk | https://doi.org/10.1101/2023.07.10.23292424||
| Ebola virus   | 9,563 | hunwin@ic.ac.uk, rknash@ic.ac.uk||
| Lassa Mammarenavirus  | 1,760 | pd315@ic.ac.uk ||
| Henipa virus  |           959 | cw1716@ic.ac.uk ||
| SARS-CoV-1    |        11,918 | acori@ic.ac.uk, cm401@ic.ac.uk || 
| Nairo virus (CCHF) |     1,967| dn620@ic.ac.uk, svanelsl@ic.ac.uk||
| Zika virus|              4,518| kem22@ic.ac.uk||
| Rift Valley Fever Virus| 3,341| gc.4018@ic.ac.uk||
| MERS-CoV|               10,382| acori@ic.ac.uk||
| Comprehensive paper comparing pathogens |47,115| acori@ic.ac.uk||

If you are interested in adding any other pathogen to the database please feel free to [contact us](cm401@ic.ac.uk).
