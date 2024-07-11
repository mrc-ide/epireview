# first attempt at naive synthesis

naive_synthesis_get_raw_data <- function(pathogen, parameter_name)
{
  data   <- load_epidata(pathogen)
  params <- data$params

  rows   <- get_parameter(params, parameter_name)

  return(rows)
}

# pre-process
convert_no_unit_to_percent <- function(df)
{
  df <- df %>% mutate(parameter_value = case_when(parameter_unit=='No units' ~ parameter_value * 10^exponent * 100,
                                           TRUE ~ parameter_value),
               parameter_unit = case_when(parameter_unit=='No units' ~ 'Percentage (%)',
                                          TRUE ~ parameter_unit) )
  return(df)
}

naive_synthesis_no_dist <- function(rows)
{
  if(length(unique(rows$parameter_unit))>1)
    break

  return(mean(rows$parameter_value))
}

df <- naive_synthesis_get_raw_data('lassa','Attack rate')
df <- convert_no_unit_to_percent(df)
naive_synthesis_no_dist(df)
