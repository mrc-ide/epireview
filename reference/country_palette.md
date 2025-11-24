# country_palette Function

This function returns a color palette for countries.

## Usage

``` r
country_palette(x = NULL)
```

## Arguments

- x:

  A vector of country names. If provided, the function will return a
  color palette for the specified countries.

## Value

A color palette for the specified countries.

## Examples

``` r
# Get color palette for all countries
country_palette()
#>                  Liberia                   Guinea             Sierra Leone 
#>              "#5050FFFF"              "#CE3D32FF"              "#749B58FF" 
#>                  Nigeria                  Senegal                     Mali 
#>              "#F0E685FF"              "#466983FF"              "#BA6338FF" 
#>                      DRC                    Gabon                   Uganda 
#>              "#5DB1DDFF"              "#802268FF"              "#6BD76BFF" 
#>              South Sudan                    Kenya                 Ethiopia 
#>              "#D595A7FF"              "#924822FF"              "#837B8DFF" 
#>                 Cameroon Central African Republic    Republic of the Congo 
#>              "#C75127FF"              "#D58F5CFF"              "#7A65A5FF" 
#>                    Sudan               \n    Chad                    Benin 
#>              "#E4AF69FF"              "#3B1B53FF"              "#CDDEB7FF" 
#>                     Togo                    Ghana             Burkina Faso 
#>              "#612A79FF"              "#AE1F63FF"              "#E7C76FFF" 
#>              Ivory Coast        Equatorial Guinea                   Angola 
#>              "#5A655EFF"              "#CC9900FF"              "#99CC00FF" 
#>             South Africa                   Zambia                 Tanzania 
#>              "#A9A9A9FF"              "#CC9900FF"              "#99CC00FF" 
#>                 Djibouti                  Somalia               Mozambique 
#>              "#33CC00FF"              "#00CC33FF"              "#00CC99FF" 
#>               Madagascar                   Malawi                 Zimbabwe 
#>              "#0099CCFF"              "#0A47FFFF"              "#4775FFFF" 
#>           United Kingdom              Unspecified 
#>              "#FFC20AFF"              "#FFD147FF" 
#' # Get color palette for specific countries
country_palette(c("Liberia", "Guinea", "Sierra Leone"))
#>      Liberia       Guinea Sierra Leone 
#>  "#5050FFFF"  "#CE3D32FF"  "#749B58FF" 

country_palette()
#>                  Liberia                   Guinea             Sierra Leone 
#>              "#5050FFFF"              "#CE3D32FF"              "#749B58FF" 
#>                  Nigeria                  Senegal                     Mali 
#>              "#F0E685FF"              "#466983FF"              "#BA6338FF" 
#>                      DRC                    Gabon                   Uganda 
#>              "#5DB1DDFF"              "#802268FF"              "#6BD76BFF" 
#>              South Sudan                    Kenya                 Ethiopia 
#>              "#D595A7FF"              "#924822FF"              "#837B8DFF" 
#>                 Cameroon Central African Republic    Republic of the Congo 
#>              "#C75127FF"              "#D58F5CFF"              "#7A65A5FF" 
#>                    Sudan               \n    Chad                    Benin 
#>              "#E4AF69FF"              "#3B1B53FF"              "#CDDEB7FF" 
#>                     Togo                    Ghana             Burkina Faso 
#>              "#612A79FF"              "#AE1F63FF"              "#E7C76FFF" 
#>              Ivory Coast        Equatorial Guinea                   Angola 
#>              "#5A655EFF"              "#CC9900FF"              "#99CC00FF" 
#>             South Africa                   Zambia                 Tanzania 
#>              "#A9A9A9FF"              "#CC9900FF"              "#99CC00FF" 
#>                 Djibouti                  Somalia               Mozambique 
#>              "#33CC00FF"              "#00CC33FF"              "#00CC99FF" 
#>               Madagascar                   Malawi                 Zimbabwe 
#>              "#0099CCFF"              "#0A47FFFF"              "#4775FFFF" 
#>           United Kingdom              Unspecified 
#>              "#FFC20AFF"              "#FFD147FF" 
```
