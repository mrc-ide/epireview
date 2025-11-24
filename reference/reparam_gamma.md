# Reparameterize Gamma Distribution

This function reparameterizes the gamma distribution in a given data
frame. If a parameter has been expressed as a gamma distribution with
shape and scale, we convert these to mean and standard deviation for
plotting.

## Usage

``` r
reparam_gamma(df)
```

## Arguments

- df:

  A data frame with updated columns for parameter value and uncertainty.

## Value

data.frame modified data frame with reparameterized gamma distributions.
