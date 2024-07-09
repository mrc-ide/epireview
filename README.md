# epireview

<a href="https://github.com/mrc-ide/epireview"><img src="man/figures/hex-epireview.png" align="right" width="200" style="padding: 20px;"></a>

<!-- badges: start -->
[![R build status](https://github.com/mrc-ide/epireview/workflows/R-CMD-check/badge.svg)](https://github.com/mrc-ide/epireview/actions)
[![DOI](https://zenodo.org/badge/655602716.svg)](https://zenodo.org/badge/latestdoi/655602716)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->


_Please note that epireview is currently under active development. This means that data format, software interface, and features are evolving and are likely to change.
The version used in our publication on Marburg virus disease ([preprint](https://doi.org/10.1101/2023.07.10.23292424)) is tagged as V0.1.0 and is available [here](https://github.com/mrc-ide/epireview/releases/tag/v0.1.0). You can use this version and accompanying data (with appropriate citation) but if you plan to make extensive use of epireview, please first get in touch with by [email](s.bhatia@imperial.ac.uk)._


epireview is a tool to obtain the latest data, figures and tables from the Pathogen Epidemiology Review Group (PERG). This package also contains functions to update pathogen-specific databases with new data from peer-reviewed papers as they become available. This can be submitted via a pull-request and will be checked by our team.

To install the latest version of epireview, use:

```r
remotes::install_github('mrc-ide/epireview')
```
## Quick start

To load pathogen-specific data, do
```r
ebola <- epireview::load_epidata("ebola")
```
At the moment, the package hosts data for Ebola, Marburg and Lassa.

This will load a list consisting of four elements (articles, params, outbreaks, models).

To visualise parameter values,

```r
params <- ebola[["params"]]
forest_plot_rt(params, col_by = "population_country", shape_by = "parameter_value_type")
```

Some other functions of interest are 

```r
forest_plot_r0(params)
forest_plot_serial_interval(params)
forest_plot_incubation_period(params)
forest_plot_infectious_period(params)
```

## Project overview
The COVID-19 pandemic has highlighted the critical role that mathematical modelling can play in supporting evidence-based decision-making during outbreaks (e.g. to project the expected epidemic size, the required hospital capacity and assess the potential population-level impact of interventions). However, early in an epidemic, modelling efforts can be hampered and delayed by the lack of a centralised resource summarising existing model structures and input parameters for the disease of interest. Literature reviews are therefore often conducted during epidemics to identify plausible parameter ranges and/or existing mathematical model structures (e.g. Van Kerkhove et al. Scientific data 2015) and are mostly limited to individual parameters.

A group of ~20 volunteer researchers currently or formerly at Imperial College London with an interest in outbreaks are working together to systematically review the mathematical models and parameters for the nine World Health Organization (WHO) 2019 blue-print priority pathogens: Nairo virus (Crimean-Congo haemorrhagic fever), Ebola virus, Henipa virus, Lassa mammarenavirus, Marburg virus, Middle East respiratory syndrome coronavirus (MERS-CoV), Rift Valley fever virus, Severe Acute Respiratory Syndrome coronavirus (SARS-CoV-1), and Zika virus. These are pathogens, or strains thereof, for which there are no approved vaccines or treatments and hence where we anticipate mathematical modelling is likely to play a major role in supporting the epidemic response. We do not include SARS-CoV-2 because vaccines exist for this pathogen and the body of literature far exceeds the capacity of our team. For each pathogen, we will review published mathematical models, information on transmission, evolution, natural history and severity, as well as seroprevalence studies and reported sizes of previous outbreaks. The quality of each paper will also be assessed as part of the review. This series of systematic reviews is registered with PROSPERO:
 [CRD42023393345](https://www.crd.york.ac.uk/prospero/display_record.php?RecordID&RecordID=393345)

## Pathogen database
One output of this project will be a database initially populated with all the information extracted that can be easily updated with new parameter estimates or information on additional pathogens as these become available. 

1. The code in this repository provides functions to access the data for each pathogen. We will update the repository as we progress through this work. An expected timeline is provided in the below table.
2. We provide functionality to update existing databases with new data as new research (in line with the inclusion and exclusion criteria) becomes available.
3. Tables and figures for each pathogen can be updated once new data is added to the database.
4. Vignettes and the github wiki contain all required information on the data.
5. We will add functionality to create/add new pathogens which are not currently included in the review. 

## Pathogen overview and timeline

| Pathogen  | Titles & Abstracts screened | Contact | Living review | last lit review update | doi|
| --------- |         -------------------:|      -- |           --  | -- | -- |
| Marburg virus | 4,460 | cm401@ic.ac.uk, gc4018@ic.ac.uk | [link](https://mrc-ide.github.io/priority-pathogens/articles/pathogen_marburg.html)|Mar 2023 | https://doi.org/10.1016/S1473-3099(23)00515-7 |
| Ebola virus   | 14,690 | hunwin@ic.ac.uk, rknash@ic.ac.uk|| Jul 2023|https://doi.org/10.1101/2024.03.20.24304571|
| Lassa Mammarenavirus  | 1,760 | pd315@ic.ac.uk, cm401@ic.ac.uk |[link](https://mrc-ide.github.io/priority-pathogens/articles/pathogen_lassa.html)| Aug 2023|https://doi.org/10.1101/2024.03.23.24304596|
| Henipa virus  |           959 | s.bhatia@imperial.ac.uk||2019||
| SARS-CoV-1    |        11,918 | acori@ic.ac.uk, cm401@ic.ac.uk ||Nov 2023||
| Nairo virus (CCHF) |     1,967| dn620@ic.ac.uk, svanelsl@ic.ac.uk||2019||
| Zika virus|              4,518| kem22@ic.ac.uk||Feb 2024||
| Rift Valley Fever Virus| 3,341| gc4018@ic.ac.uk||2019||
| MERS-CoV|               10,382| rom116@ic.ac.uk||2019||
| Comprehensive paper comparing pathogens |47,115| acori@ic.ac.uk||||

If you are interested in adding any other pathogen to the database please feel free to [contact us](s.bhatia@imperial.ac.uk).
