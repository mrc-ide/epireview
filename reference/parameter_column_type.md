# parameter_column_type

This function defines the column types for the parameters in the
dataset. It returns a list of column types with their corresponding
names.

## Usage

``` r
parameter_column_type()
```

## Value

A list of column types for the article data frame

## See also

parameter_column_type, outbreak_column_type, model_column_type

## Examples

``` r
parameter_column_type()
#> $parameter_data_id
#> <collector_character>
#> 
#> $id
#> <collector_character>
#> 
#> $article_id
#> <collector_integer>
#> 
#> $parameter_type
#> <collector_character>
#> 
#> $parameter_value
#> <collector_double>
#> 
#> $parameter_unit
#> <collector_character>
#> 
#> $parameter_lower_bound
#> <collector_double>
#> 
#> $parameter_upper_bound
#> <collector_double>
#> 
#> $parameter_value_type
#> <collector_character>
#> 
#> $parameter_uncertainty_single_value
#> <collector_double>
#> 
#> $parameter_uncertainty_singe_type
#> <collector_character>
#> 
#> $parameter_uncertainty_lower_value
#> <collector_double>
#> 
#> $parameter_uncertainty_upper_value
#> <collector_double>
#> 
#> $parameter_uncertainty_type
#> <collector_character>
#> 
#> $cfr_ifr_numerator
#> <collector_integer>
#> 
#> $cfr_ifr_denominator
#> <collector_integer>
#> 
#> $distribution_type
#> <collector_character>
#> 
#> $distribution_par1_value
#> <collector_double>
#> 
#> $distribution_par1_type
#> <collector_character>
#> 
#> $distribution_par1_uncertainty
#> <collector_logical>
#> 
#> $distribution_par2_value
#> <collector_double>
#> 
#> $distribution_par2_type
#> <collector_character>
#> 
#> $distribution_par2_uncertainty
#> <collector_logical>
#> 
#> $method_from_supplement
#> <collector_logical>
#> 
#> $method_moment_value
#> <collector_character>
#> 
#> $cfr_ifr_method
#> <collector_character>
#> 
#> $method_r
#> <collector_character>
#> 
#> $method_disaggregated_by
#> <collector_character>
#> 
#> $method_disaggregated
#> <collector_logical>
#> 
#> $method_disaggregated_only
#> <collector_logical>
#> 
#> $riskfactor_outcome
#> <collector_character>
#> 
#> $riskfactor_name
#> <collector_character>
#> 
#> $riskfactor_occupation
#> <collector_character>
#> 
#> $riskfactor_significant
#> <collector_character>
#> 
#> $riskfactor_adjusted
#> <collector_character>
#> 
#> $population_sex
#> <collector_character>
#> 
#> $population_sample_type
#> <collector_character>
#> 
#> $population_group
#> <collector_character>
#> 
#> $population_age_min
#> <collector_double>
#> 
#> $population_age_max
#> <collector_double>
#> 
#> $population_sample_size
#> <collector_integer>
#> 
#> $population_country
#> <collector_character>
#> 
#> $population_location
#> <collector_character>
#> 
#> $population_study_start_day
#> <collector_integer>
#> 
#> $population_study_start_month
#> <collector_character>
#> 
#> $population_study_start_year
#> <collector_integer>
#> 
#> $population_study_end_day
#> <collector_integer>
#> 
#> $population_study_end_month
#> <collector_character>
#> 
#> $population_study_end_year
#> <collector_integer>
#> 
#> $genome_site
#> <collector_character>
#> 
#> $genomic_sequence_available
#> <collector_logical>
#> 
#> $parameter_class
#> <collector_character>
#> 
#> $covidence_id
#> <collector_integer>
#> 
#> $exponent
#> <collector_integer>
#> 
#> $case_definition
#> <collector_character>
#> 
#> $data_available
#> <collector_character>
#> 
#> $inverse_param
#> <collector_logical>
#> 
#> $parameter_from_figure
#> <collector_logical>
#> 
#> $r_pathway
#> <collector_character>
#> 
#> $seroprevalence_adjusted
#> <collector_character>
#> 
#> $third_sample_param_yn
#> <collector_logical>
#> 
#> $trimester_exposed
#> <collector_character>
#> 
#> $urban_rural_area
#> <collector_character>
#> 
#> $parameter_bounds
#> <collector_character>
#> 
#> $comb_uncertainty_type
#> <collector_character>
#> 
#> $comb_uncertainty
#> <collector_character>
#> 
#> $population_country_original
#> <collector_character>
#> 
#> $delay_short
#> <collector_character>
#> 
#> $genomic_lineage
#> <collector_character>
#> 
#> $prnt_on_elisa
#> <collector_logical>
#> 
#> $metaanalysis_inclusion
#> <collector_character>
#> 
#> $women_or_infants
#> <collector_character>
#> 
#> $pregnancy_outcome_type
#> <collector_character>
#> 
#> $survey_start_date
#> <collector_character>
#> 
#> $survey_end_date
#> <collector_character>
#> 
#> $survey_date
#> <collector_character>
#> 
#> $article_qa_score
#> <collector_double>
#> 
```
