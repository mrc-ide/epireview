# Checks that the column types of the input csv matches the column types expected by epireview.

This function creates a vroom object (the same type created by read_csv)
and checks if there are any problems with the file. If there are it will
provide the offending columns and the number problematic rows (per
column). A csv with the details of the issue will be written to a tmp
file and the location will be provided. This function will prevent data
from being loaded until all column types are correct.

## Usage

``` r
check_column_types(fname, col_types, raw_colnames)
```

## Arguments

- fname:

  The name of the csv file for which the column types are to be checked

- col_types:

  The column types expected by epireview. These are specified in the
  column type functions (e.g., article_column_type,
  parameter_column_type) and are used to read in the data.

- raw_colnames:

  The column names of the csv file

## Details

The function is intended to be used internally by `load_epidata_raw`
where the files are being read.

## See also

article_column_type parameter_column_type, outbreak_column_type,
model_column_type
