# Data on the models identified in the systematic review of articles related to Marburg virus disease.

This data set provides all extracted data for mathematical models
applied to Marburg virus disease (MVD).

## Format

A csv file containing the following parameters:

- model_data_id = ID variable for the model.

- article_id = ID variable for the article the model came from.

- model_type = whether the model was compartmental, branching process,
  agent/individual based, other, or unspecified.

- compartmental_type = if the model is compartmental, whether the model
  is SIS, SIR, SEIR, or "other".

- stoch_deter = whether the article specified whether the model was
  stochastic, deterministic, or both.

- theoretical_model = "TRUE" or "FALSE". "TRUE" if the model is not fit
  to data.

- interventions_type = interventions modelled e.g. vaccination,
  quarantine, vector control, treatment, contact tracing, hospitals,
  treatment centres, safe burials, behaviour changes, other, or
  unspecified.

- code_available = whether the code was made available in the article.

- transmission_route = which transmission route was modelled, e.g.
  airborne or close contact, human to human, vector to human, animal to
  human, sexual, or unspecified.

- assumptions = assumptions used in the model e.g. homogenous mixing,
  latent period is the same as incubation period, heterogeneity in
  transmission rates between groups or over time, age dependent
  susceptibility, or unspecified.

- covidence_id = article identifier used by the Imperial team.

## Source

Cuomo-Dannenburg G, McCain K, McCabe R, Unwin HJT, Doohan P, Nash RK, et
al. Marburg Virus Disease outbreaks, mathematical models, and disease
parameters: a Systematic Review. medRxiv; 2023. 2023.07.10.23292424.
Available from:
https://www.medrxiv.org/content/10.1101/2023.07.10.23292424v1
