# Package index

## All functions

- [`article_column_type()`](https://mrc-ide.github.io/epireview/reference/article_column_type.md)
  : Define the column types for the article data frame

- [`assign_qa_score()`](https://mrc-ide.github.io/epireview/reference/assign_qa_score.md)
  : Assign quality assessment score to each article

- [`check_column_types()`](https://mrc-ide.github.io/epireview/reference/check_column_types.md)
  : Checks that the column types of the input csv matches the column
  types expected by epireview.

- [`check_df_for_meta()`](https://mrc-ide.github.io/epireview/reference/check_df_for_meta.md)
  : Sanity checks before meta-analysis

- [`check_ulim()`](https://mrc-ide.github.io/epireview/reference/check_ulim.md)
  : Check upper limit of parameter values

- [`color_palette()`](https://mrc-ide.github.io/epireview/reference/color_palette.md)
  : Define a consistent color palette for use in figures. Palettes are
  currently defined for parameters and countries. Any other variable
  will return NULL

- [`country_palette()`](https://mrc-ide.github.io/epireview/reference/country_palette.md)
  : country_palette Function

- [`custom_palette()`](https://mrc-ide.github.io/epireview/reference/custom_palette.md)
  : Create a custom color palette.

- [`delays_to_days()`](https://mrc-ide.github.io/epireview/reference/delays_to_days.md)
  : This function converts delays in different units (hours, weeks,
  months) to days. It checks if all delays are in days and warns the
  user if not. It then converts hours to days by dividing by 24, weeks
  to days by multiplying by 7, and months to days by multiplying by 30.

- [`epireview_read_file()`](https://mrc-ide.github.io/epireview/reference/epireview_read_file.md)
  : Intended for internal use only; setting desirable defaults for
  reading in data files.

- [`filter_cols()`](https://mrc-ide.github.io/epireview/reference/filter_cols.md)
  : Filter columns of a data frame based on specified conditions.

- [`filter_df_for_metamean()`](https://mrc-ide.github.io/epireview/reference/filter_df_for_metamean.md)
  : Prepare parameter dataframe for meta analysis of means

- [`filter_df_for_metaprop()`](https://mrc-ide.github.io/epireview/reference/filter_df_for_metaprop.md)
  : Prepare parameter dataframe for meta analysis of proportions

- [`forest_plot()`](https://mrc-ide.github.io/epireview/reference/forest_plot.md)
  : Basic forest plot

- [`forest_plot_delay_int()`](https://mrc-ide.github.io/epireview/reference/forest_plot_delay_int.md)
  : Create forest plot for human delays

- [`forest_plot_doubling_time()`](https://mrc-ide.github.io/epireview/reference/forest_plot_doubling_time.md)
  : Forest plot for doubling time

- [`forest_plot_incubation_period()`](https://mrc-ide.github.io/epireview/reference/forest_plot_incubation_period.md)
  : Create forest plot for incubation period

- [`forest_plot_infectious_period()`](https://mrc-ide.github.io/epireview/reference/forest_plot_infectious_period.md)
  : Create forest plot for infectious period

- [`forest_plot_r0()`](https://mrc-ide.github.io/epireview/reference/forest_plot_r0.md)
  : forest_plot_r0 function

- [`forest_plot_rt()`](https://mrc-ide.github.io/epireview/reference/forest_plot_rt.md)
  : Generate a forest plot for effective reproduction number (Rt)

- [`forest_plot_serial_interval()`](https://mrc-ide.github.io/epireview/reference/forest_plot_serial_interval.md)
  : Create forest plot for serial interval

- [`get_key_columns()`](https://mrc-ide.github.io/epireview/reference/get_key_columns.md)
  : Subset the epidemiological parameter columns by parameter type

- [`get_parameter()`](https://mrc-ide.github.io/epireview/reference/get_parameter.md)
  : retrieve all parameters of specified type or class

- [`get_incubation_period()`](https://mrc-ide.github.io/epireview/reference/get_specific.md)
  [`get_serial_interval()`](https://mrc-ide.github.io/epireview/reference/get_specific.md)
  [`get_generation_time()`](https://mrc-ide.github.io/epireview/reference/get_specific.md)
  [`get_delays()`](https://mrc-ide.github.io/epireview/reference/get_specific.md)
  [`get_cfr()`](https://mrc-ide.github.io/epireview/reference/get_specific.md)
  [`get_risk_factors()`](https://mrc-ide.github.io/epireview/reference/get_specific.md)
  [`get_genomic()`](https://mrc-ide.github.io/epireview/reference/get_specific.md)
  [`get_reproduction_number()`](https://mrc-ide.github.io/epireview/reference/get_specific.md)
  [`get_seroprevalence()`](https://mrc-ide.github.io/epireview/reference/get_specific.md)
  [`get_doubling_time()`](https://mrc-ide.github.io/epireview/reference/get_specific.md)
  [`get_attack_rate()`](https://mrc-ide.github.io/epireview/reference/get_specific.md)
  [`get_growth_rate()`](https://mrc-ide.github.io/epireview/reference/get_specific.md)
  [`get_overdispersion()`](https://mrc-ide.github.io/epireview/reference/get_specific.md)
  [`get_relative_contribution()`](https://mrc-ide.github.io/epireview/reference/get_specific.md)
  : Retrieve all incubation period parameters for a given pathogen

- [`invert_inverse_params()`](https://mrc-ide.github.io/epireview/reference/invert_inverse_params.md)
  :

  Inverts the values of selected parameters in a data frame. Sometimes
  parameters are reported in inverse form (e.g., a delay might be
  reported as per day instead of days). Here we carry out a very simple
  transformation to convert these to the correct form by inverting the
  parameter value and the uncertainty bounds. This may not be
  appropriate in all cases, and must be checked on a case-by-case basis.
  This function takes a data frame as input and inverts the values of
  selected parameters. The selected parameters are identified by the
  column 'inverse_param'. The function performs the following
  operations:

  - Inverts the parameter values of the selected parameters.

  - Swaps the upper and lower bounds of the selected parameters.

  - Inverts the uncertainty values of the selected parameters.

  - Updates the logical vector to indicate that the parameters are no
    longer inverted.

  - Does not change the unit of the parameters, as it remains the same
    as the original parameter.

- [`load_epidata()`](https://mrc-ide.github.io/epireview/reference/load_epidata.md)
  : Retrieve pathogen-specific data

- [`load_epidata_raw()`](https://mrc-ide.github.io/epireview/reference/load_epidata_raw.md)
  : Loads raw data for a particular pathogen

- [`make_unique_id()`](https://mrc-ide.github.io/epireview/reference/make_unique_id.md)
  : Ensure that each article gets a unique id across all tables

- [`marburg_article`](https://mrc-ide.github.io/epireview/reference/marburg_article.md)
  : Data on the articles identified and included in the systematic
  review of articles related to Marburg virus disease.

- [`marburg_dropdown_models`](https://mrc-ide.github.io/epireview/reference/marburg_dropdown_models.md)
  : Dropdown menu options for model extractions in the systematic review
  of articles related to Marburg virus disease (MVD).

- [`marburg_dropdown_outbreaks`](https://mrc-ide.github.io/epireview/reference/marburg_dropdown_outbreaks.md)
  : Dropdown menu options for outbreak extractions in the systematic
  review of articles related to Marburg virus disease (MVD).

- [`marburg_dropdown_parameters`](https://mrc-ide.github.io/epireview/reference/marburg_dropdown_parameters.md)
  : Dropdown menu options for parameter extractions in the systematic
  review of articles related to Marburg virus disease (MVD).

- [`marburg_model`](https://mrc-ide.github.io/epireview/reference/marburg_model.md)
  : Data on the models identified in the systematic review of articles
  related to Marburg virus disease.

- [`marburg_outbreak`](https://mrc-ide.github.io/epireview/reference/marburg_outbreak.md)
  : Data on the outbreaks identified in the systematic review of
  articles related to Marburg virus disease.

- [`marburg_parameter`](https://mrc-ide.github.io/epireview/reference/marburg_parameter.md)
  : Data on the parameters identified in the systematic review of
  articles related to Marburg virus disease.

- [`mark_multiple_estimates()`](https://mrc-ide.github.io/epireview/reference/mark_multiple_estimates.md)
  : Distinguish multiple estimates from the same study

- [`model_column_type()`](https://mrc-ide.github.io/epireview/reference/model_column_type.md)
  : model_column_type

- [`outbreak_column_type()`](https://mrc-ide.github.io/epireview/reference/outbreak_column_type.md)
  : outbreak_column_type

- [`param_pm_uncertainty()`](https://mrc-ide.github.io/epireview/reference/param_pm_uncertainty.md)
  : Update parameter uncertainty columns in a data frame

- [`parameter_column_type()`](https://mrc-ide.github.io/epireview/reference/parameter_column_type.md)
  : parameter_column_type

- [`parameter_palette()`](https://mrc-ide.github.io/epireview/reference/parameter_palette.md)
  : Define a consistent color palette for use in figures

- [`pretty_article_label()`](https://mrc-ide.github.io/epireview/reference/pretty_article_label.md)
  : Make pretty labels for articles

- [`priority_pathogens()`](https://mrc-ide.github.io/epireview/reference/priority_pathogens.md)
  : priority_pathogens

- [`qa_questions()`](https://mrc-ide.github.io/epireview/reference/qa_questions.md)
  : Quality assessment questionnaire This function returns the list of 7
  questions used to assess quality of articles.

- [`reorder_studies()`](https://mrc-ide.github.io/epireview/reference/reorder_studies.md)
  : Reorder articles based on parameter value

- [`reparam_gamma()`](https://mrc-ide.github.io/epireview/reference/reparam_gamma.md)
  : Reparameterize Gamma Distribution

- [`shape_palette()`](https://mrc-ide.github.io/epireview/reference/shape_palette.md)
  : shape_palette function

- [`short_parameter_type()`](https://mrc-ide.github.io/epireview/reference/short_parameter_type.md)
  : Short labels parameters for use in figures

- [`theme_epireview()`](https://mrc-ide.github.io/epireview/reference/theme_epireview.md)
  : Plotting theme for epireview A standard theme for figures in
  epireview.

- [`update_article_info()`](https://mrc-ide.github.io/epireview/reference/update_article_info.md)
  : Include key article information when DOI is missing

- [`value_type_palette()`](https://mrc-ide.github.io/epireview/reference/value_type_palette.md)
  : Define a consistent shape palette for use in forest plots We map
  shape aesthetic to value type i.e., mean, median etc. This function
  defines a shape palette that can be used in forest plots
