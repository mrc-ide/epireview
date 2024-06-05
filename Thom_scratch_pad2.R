#git push origin HEAD
#First, load all packages:
library(devtools)
#devtools::install_deps()
devtools::load_all()

#Now, load some data that we will be testing our functions against:

epi_df <- load_epidata('ebola')
#Despite warning messages, it is successful.

#Extract just the params:
epi_params <- epi_df[["params"]]
#This data looks the same as for the df "parameters" built in priority pathogens workflow

#epi_d1 <- epi_params %>% filter(parameter_type == 'Human delay - incubation period')

#This filters out just the rt and plots it
forest_plot_rt(epi_params, col_by = "parameter_type", shape_by = "parameter_value_type")
#Likewise we plot the incubation periods
forest_plot_incubation_period(epi_params, col_by = "parameter_type", shape_by = "parameter_value_type", ulim = 35)
#These are the two plots we'll be testing against, and seeing how things change as we go


# Preprocess the dataframe to remove bracketed numbers
#df$article_label_clean <- gsub("\\s*\\(\\d+\\)$", "", df$article_label)

#ggsave(filename = "Base_Ebola_R.png", plot = p1, dpi = 300, width = 8, height = 6, units = "in")
#ggsave(filename = "Base_Ebola_incubation.png", plot = p2, dpi = 300, width = 8, height = 6, units = "in")

#There are six forest plot functions in epireview currently:
#1) forest_plot_delay
#2) forest_plot_mutations
#3) forest_plot_other
#4) forest_plot_r
#5) forest_plot_severity
#6) forest_plot
#These are essentially all different wrappers into just #6 forest plot
