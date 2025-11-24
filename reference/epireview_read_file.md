# Intended for internal use only; setting desirable defaults for reading in data files.

Intended for internal use only; setting desirable defaults for reading
in data files.

## Usage

``` r
epireview_read_file(fname, ...)
```

## Arguments

- fname:

  The name of the file to be read in.

- ...:

  Additional arguments to be passed to
  [`vroom`](https://vroom.r-lib.org/reference/vroom.html).

## Value

A data frame read in from the file.

## Details

This function is intended for internal use only. It is used to read in
data files shipped with the package. The idea is to set desirable
defaults in a single place. Mostly it makes reading files quiet by
setting show_col_types to FALSE.

## Author

Sangeeta Bhatia
