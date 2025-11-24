# Plotting theme for epireview A standard theme for figures in epireview.

Plotting theme for epireview A standard theme for figures in epireview.

## Usage

``` r
theme_epireview(
  base_size = 11,
  base_family = "",
  header_family = NULL,
  base_line_size = base_size/22,
  base_rect_size = base_size/22
)
```

## Arguments

- base_size:

  base font size, given in pts.

- base_family:

  base font family

- header_family:

  font family for titles and headers. The default, `NULL`, uses theme
  inheritance to set the font. This setting affects axis titles, legend
  titles, the plot title and tag text.

- base_line_size:

  base size for line elements

- base_rect_size:

  base size for rect elements
