To add a new pathogen to epireview,

1. Update the data.frame in the function priority_pathogens adding pathogen name and the filenames for articles, models, parameters, and outbreaks.
2. If necesary, update the functions article_column_types, parameter_column_types, model_column_types, and outbreak column types. These updates are needed if the corresponding files have column(s) that are not clready defined in the functions. This is most likely to happen in the parameters file.
Add tests.