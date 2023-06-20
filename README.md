# epireview

<!-- badges: start -->
[![R build status](https://github.com/mrc-ide/EpiEstim/workflows/R-CMD-check/badge.svg)](https://github.com/mrc-ide/epireview/actions)
<!-- badges: end -->

epireview is a tool to obtain the latest data from the Priority Pathogen Review Group (PERG) and contains tools to update data from new, peer-reviewed papers for existing pathogens in the database or to add entirely new pathogens.
To install the latest version, use:
```r
devtools::install_github("mrc-ide/epireview", build_vignettes = TRUE)
```

## Project overview
The COVID-19 pandemic has highlighted the critical role that mathematical modelling can play in supporting evidence-based decision-making during outbreaks (e.g. to project the expected epidemic size, the required hospital capacity and assess the potential population-level impact of interventions). However, early in an epidemic, modelling efforts can be hampered and delayed by the lack of a centralised resource summarising existing model structures and input parameters for the disease of interest. Literature reviews are therefore often conducted during epidemics to identify plausible parameter ranges and/or existing mathematical model structures (e.g. Van Kerkhove et al. Scientific data 2015) and are mostly limited to individual parameters.

We propose that such literature reviews would be best conducted in advance of the next epidemic and be comprehensive across all relevant transmission and modelling parameters, with results stored in a dynamic database that could be updated as new information becomes available. This would streamline real-time modelling pipelines and in turn enable more rapid generation of evidence to support timely decision making.

A group of ~20 volunteer researchers currently or formerly at Imperial College London with an interest in outbreaks are working together to systematically review the mathematical models and parameters for the nine World Health Organization (WHO) 2019 blue-print priority pathogens: Nairo virus (Crimean-Congo haemorrhagic fever), Ebola virus, Henipa virus, Lassa mammarenavirus, Marburg virus, Middle East respiratory syndrome coronavirus (MERS-CoV), Rift Valley fever virus, Severe Acute Respiratory Syndrome coronavirus (SARS-CoV-1), and Zika virus. These are pathogens, or strains thereof, for which there are no approved vaccines or treatments and hence where we anticipate mathematical modelling is likely to play a major role in supporting the epidemic response. We do not include SARS-CoV-2 because vaccines exist for this pathogen and the body of literature far exceeds the capacity of our team. For each pathogen, we will review published mathematical models, information on transmission, evolution, natural history and severity, as well as seroprevalence studies and reported sizes of previous outbreaks (see Table 1). The quality of each paper will also be assessed as part of the review. 

## Pathogen database
One output of this project will be a database initially populated with all the information extracted that can be easily updated with new parameter estimates or information on additional pathogens as these become available. In collaboration with WHO, the data will be stored in a central, open access, repository ensuring that this can be a useful resource to the global infectious disease epidemiology modelling community.

In addition, we will write a series of 11 papers including one overview paper comparing pathogens, one paper for each priority pathogen describing pathogen specific characteristics, and a paper on reporting guidelines and quality assessment. Our work will fill two knowledge gaps. First, it will provide an up-to-date comprehensive picture of pathogen-specific knowledge and understanding of disease transmission mechanisms, background levels of immunity, previously modelled interventions, and characteristics affecting the risk of infection or severe outcome, which could be used to target resources effectively. Second, this systematic review intends to collate all necessary information for effective real-time epidemic modelling. 

1. The code in this repository provides functions to access the data for each pathogen. We will update the repository as we progress through this work. An expected timeline is provided in the below table.
2. We provide functionality to update existing databases with new data as new research (in line with the inclusion and exclusion criteria) becomes available.
3. Tables and figures for each pathogen can be updated once new data is added to the database.
4. Vignettes and the github wiki contain all required information on the data.
5. We will add functionality to create/add new pathogens which are not currently included in the review. 


## Pathogen overview and time-line

| Pathogen       | Titles & Abstracts screened | Expected pre-print | Contact | doi|
| ------------- | -------------:| -----:| -- |-- |
| Marburg virus |         4,460 | June 2023      | cm401@ic.ac.uk, gc4018@ic.ac.uk||
| Ebola virus   |         9,563 | September 2023 | hunwin@ic.ac.uk, rknash@ic.ac.uk||
| Lassa Mammarenavirus  | 1,760 | October 2023   | pd315@ic.ac.uk ||
| Henipa virus  |           959 | December 2023  | cw1716@ic.ac.uk ||
| SARS-CoV-1    |        11,918 | January 2024   | acori@ic.ac.uk, cm401@ic.ac.uk || 
| Nairo virus (CCHF) |     1,967| March 2024     |dn620@ic.ac.uk, svanelsl@ic.ac.uk||
| Zika virus|              4,518| May 2024       |kem22@ic.ac.uk||
| Rift Valley Fever Virus| 3,341| June 2024      |gc.4018@ic.ac.uk||
| MERS-CoV|               10,382| July 2024      |acori@ic.ac.uk||
| Comprehensive paper comparing pathogens |47,115|September 2024|acori@ic.ac.uk||





