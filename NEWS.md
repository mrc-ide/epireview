# epireview 1.4.3

* BUG FIX: Corrected author first/last name in lassa data

# epireview 1.4.2

* Code tidy-up and reduce dependancies

# epireview 1.4.1

* Consistent handling of how files are read in to provide a smoother user experience.

# epireview 1.4.0

* MAJOR RELEASE
  - Bug fixes
  - SARS-CoV-1 data release
  - Minor fixes to Ebola data

# epireview 1.3.6
* FEATURE: The default color palette is updated with a new one from ggsci and introduces a custom_palette() function to support multi-country label visualization.

* BUG FIX: Functionality to supply custom colour palette now works as expected.

# epireview 1.3.5

* BUG-FIX: Fixes #117. NA rows were being created because filter_df_for_metamean used == to compare strings, leading to NAs being created when the RHS was NA. Comparison now is being done using %in%.

# epireview 1.3.4

* DATA: Adds SARS-CoV-1 data (articles, models, and parameters). Outbreaks were not extracted.

# epireview 1.3.3

* FEATURE: The argument to load_epidata is made case-insensitive. Addresses #96

# epireview 1.3.2

* BUG-FIX: Fixes #86 by removing a duplicated row. Also fixes an incorrectly entered method type for CFR, and incorrectly
extracted population sizes. 

# epireview 1.3.1

* BUG-FIX: Fixes #104 using readr::read_delim to read in parameter type short names

# epireview 1.3.0

* FEATURE
  - Updated lassa data available following updated literature search

# epireview 1.3.0

* MAJOR RELEASE
  - Improved messages when loading data via load_epidata
  - User-friendly getters for key epi parameters
  - Bug fixes
  
# epireview 1.2.13

* FEATURE: new function to format parameter dataset so that it can be input into
meta-analysis of proportions.

# epireview 1.2.12

* FEATURE: Addresses #98 by including article_info as key column returned when parameter specific getters are invoked.

# epireview 1.2.11

* FEATURE: Adds a R-user friendly parameter name to the params table loaded via
load_epidata. This also makes parameter names consistent across pathogens. Addresses #59.

# epireview 1.2.10

* FEATURE: Moves error logging cli package and improves warnings addressing #57 and #21

# epireview 1.2.9

* FEATURE: functions to get specific parameters for a given pathogen.

# epireview 1.2.8
* BUG FIX: Fixes #73 which caused rows of the params dataset to be dropped during if reordering the population  
country was NA.
* FEATURE: reorder_studies can now reorder by any column in the params dataset

# epireview 1.2.7

* FEATURE: filter_df_for_metamean now includes rows with uncertainty types introduced specifically for SARS.

# epireview 1.2.6

* FEATURE: Added custom axis-label functionality to forest_plot()
* BUG FIX: Fixed a bug whereby single uncertainty names would be used for paired uncertainty values.

# epireview 1.2.5

* FEATURE: addresses #80 by including doi in article columns merged with other key dfs.

# epireview 1.2.4

* BUG FIX: Updated outbreak and parameter column types. Fixes warnings being issued when lassa or ebola data were loaded.

# epireview 1.2.3

* BUG-FIX: Fixes Issue #56 where some article labels were NA because of an article being associated with multiple ids.

# epireview 1.2.2

* BUG-FIX: Fixes #71; file names are changed to match function names for consistency.

# epireview 1.2.1

* FEATURE: New function to assign QA score to articles in a simple and consistent manner.

# epireview 1.2.0

* Major release adding new features from versions 1.1.1, 1.1.2, and 1.13.

# epireview 1.1.3

* FEATURE: Add a function to extract parameters.

# epireview 1.1.2

* FEATURE: Add a function to create pretty article labels

# epireview 1.1.1

* FEATURE: Add filter_df_for_metamean function
