# Retrieve pathogen-specific data

Retrieve pathogen-specific data

## Usage

``` r
load_epidata(pathogen, mark_multiple = TRUE)
```

## Arguments

- pathogen:

  name of pathogen. This argument is case-insensitive. Must be one of
  the priority pathogens You can get a list of the priority pathogens
  currently included in the package by calling the function
  [`priority_pathogens`](https://mrc-ide.github.io/epireview/reference/priority_pathogens.md).

- mark_multiple:

  logical. If TRUE, multiple studies from the same author in the same
  year will be marked with an numeric suffix to distinguish them. See
  [`mark_multiple_estimates`](https://mrc-ide.github.io/epireview/reference/mark_multiple_estimates.md)
  for more details.

## Value

a list of length 4. The first element is a data.frame called "articles"
which contains all of the information about the articles extracted for
this pathogen. The second element is a data.frame called "params" with
articles information (authors, publication year, doi) combined with the
parameters. The third element is a data.frame called "models" with all
transmission models extracted for this pathogen including articles
information as above. The fourth element is a data.frame called
"outbreaks" which contains all of the outbreaks extracted for this
pathogen, where available. If no data is available for a particular
table, the corresponding element in the list will be NULL.

## Details

The data extracted in the systematic review has been stored in four
files - one each for articles, parameters, outbreaks, and transmission
models. Data in these files can be linked using article identifier. This
function will read in the pathogen-specific files and join them into a
data.frame. This function also creates user-friendly short labels for
the "parameter_type" column in params data.frame. See
[`short_parameter_type`](https://mrc-ide.github.io/epireview/reference/short_parameter_type.md)
for more details.
