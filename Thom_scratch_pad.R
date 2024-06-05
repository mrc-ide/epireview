#Thom testing

#THE PRIORITY PATHOGENS FOREST PLOT.

#Load in the data that is exported from the db_compilation task:
articles   <- read_csv("articles.csv")
models     <- read_csv("models.csv")
parameters <- read_csv("parameters.csv")

#Curate here does a bit of tidying
dfs <- curation(articles,tibble(),models,parameters, adjust_for_exponents = FALSE )
#split them up again
articles   <- dfs$articles
models     <- dfs$models
parameters <- dfs$parameters

#Filter down to whatever parameter you want:
d1 <- parameters %>% filter(parameter_type == 'Human delay - incubation period')
d2 <- parameters %>% filter(parameter_type == 'Human delay - symptom onset>admission to care')
d3 <- parameters %>% filter(parameter_type == 'Human delay - time in care (length of stay)' |
                              parameter_type == 'Human delay - admission to care>discharge/recovery' |
                              parameter_type == 'Human delay - admission to care>death')
d4 <- parameters %>% filter(parameter_type == 'Human delay - symptom onset>discharge/recovery' |
                              parameter_type == 'Human delay - symptom onset>death')
d5 <- parameters %>% filter(parameter_type == 'Human delay - serial interval')

#Then make the forest plot
p1 <- forest_plot(d1,'Incubation Period (days)',"parameter_type",c(0,40))

p2 <- forest_plot(d2,'Onset-Admission Delay (days)',"parameter_type",c(0,40))

#Now let's investigate exactly how forest plot works:

forest_plot <- function(df, label, color_column, lims) {
}
#Let's do it line by line, and here:
df <- d1  #the data to use
label <- "Incubation Period (days)" #the plot title
color_column <- "parameter_type" #Which variable do we want to sort by color? Note that all will be blue if only one parameter_type is exported!
lims <- c(0,20)   #x-axis limits, this is very handy to have manual control of

#So firstly it checks that there is only one type of parameter UNIT
stopifnot(length(unique(df$parameter_unit)) == 1)
#refs is the paper reference "Bloggs (2002)"
#But we also want a unique identifier each time that paper is referenced, this does that
#by appending a number at the end if a paper repeats.
df   <- df %>% mutate(urefs = make.unique(refs)) %>%
  mutate(urefs = factor(urefs, levels = rev(unique(urefs))))

#This says, how many options are there for the category we told to do colors by
cats <- length(unique(df[[color_column]]))

gg <- ggplot(df) +
  #This first chunk makes the coloured rectangles showing the lower/upper bounds
  #In ggplot2, .data is a special keyword that refers to the data being used in ggplot(data = x)
  geom_segment(aes(x = parameter_lower_bound, xend = parameter_upper_bound,
                   y = urefs, yend = urefs, color = .data[[color_column]]),
               size = 3, alpha = 0.65) +
  #This next chunk draws the errorbars from the uncertainty lower/uppers (95%CI normally)
  #Importantly though, this actually varies, sometimes its range, sometimes its 95%CI or CrI
  geom_errorbar(aes(xmin=parameter_uncertainty_lower_value, xmax=parameter_uncertainty_upper_value,
                    y = urefs),
                width = 0.15, lwd=0.5, color = "black", alpha = 1) +
  #Lastly, add some points, where the shape of the point is mean/median whatever, and the fill color is previously defined category
  geom_point(aes(x = parameter_value, y = urefs,
                 shape = df$parameter_value_type, fill = .data[[color_column]]),
             size = 3, stroke = 1,
             color = "black", alpha = 1)

#If it's R number, add a line at 1
if (all(df$parameter_class=="Reproduction number")) {gg <- gg + geom_vline(xintercept = 1, linetype = "dashed", colour = "dark grey")}

#Now the tidy up,
gg <- gg +
  #start by changing colours to nice lancet colors
  scale_fill_lancet(palette = "lanonc") + scale_color_lancet(palette = "lanonc") +
  #Then manually decide what shapes are assigned to what, NOTE THAT THIS JUST THEN HAS NO SHAPE FOR OTHERS THAT HAVE SNUCK THROUGH LIKE SD OR OTHER
  ##TODO: Think of a way to maybe catch these SDs early
  scale_shape_manual(name = "Parameter Type",values = c(Mean = 21, Median = 22, Unspecified = 24)) +
  #Next, impose the desired limits
  ##TODO: Make this optional, so it uses default if no lims given
  scale_x_continuous(limits = lims, expand = c(0, 0)) +
  #Changes names back to remove the .x numbers on repeat refs
  scale_y_discrete(labels = setNames(df$refs, df$urefs)) +
  #Impose the given x-axis label and no label on y axis
  labs(x = label, y = NULL) +
  theme_minimal() +
  #Add a box around the plot
  theme(panel.border = element_rect(color = "black", size = 1.25, fill = NA))
if (cats == 1) {
  #If there's only one category of color, then strike it from the legend, and remove legend title too
  gg <- gg + guides(fill = "none", color = FALSE, shape = guide_legend(title = NULL,order = 1))
} else {
  gg <- gg + guides(fill = "none", color = guide_legend(title = NULL,order = 1), shape = guide_legend(title = NULL,order = 2))}

return(gg)


###########################
#ON TO EPIREVIEW
#Get some data:
epi_df <- epireview::load_epidata('ebola')
#Some strange errors, but it appears to have worked!
#Extract just the params:
epi_params <- epi_df[["params"]]
#This data looks the same as for the df "parameters" built above for SARS
epi_d1 <- epi_params %>% filter(parameter_type == 'Human delay - incubation period')

#This filters out just the rt and plots it
epireview::forest_plot_rt(epi_params, col_by = "parameter_type", shape_by = "parameter_value_type")

#There are six forest plot functions in epireview currently:
#1) forest_plot_delay
#2) forest_plot_mutations
#3) forest_plot_other
#4) forest_plot_r
#5) forest_plot_severity
#6) forest_plot
#These are essentially all different wrappers into just #6 forest plot

epireview::forest_plot_incubation_period(epi_params, col_by = "parameter_type", shape_by = "parameter_value_type")

#Error, let's try and unpick what's going on, stepping through the above function:.
df <- epi_params
ulim <- 30

x <- df[df$parameter_type %in% c("Human delay - incubation period",
                                 "Human delay - incubation period  (inverse parameter)"), ]
#This returns 10, the suggest upper limit. Which seems bonkers to me
epireview::check_ulim(x, ulim, "incubation period")
#Then this
#p <- forest_plot_delay_int(x, ulim, reorder_studies, ...) +
#  labs(x = "Incubation period (days)")
#Let's step in
df <- epireview::reparam_gamma(x) |>
  epireview::invert_inverse_params() |>
  epireview::delays_to_days() |>
  #This function is KEY, it turns our uncertainty into the low mid high format
  #It adds 5 new columns: low, mid, high, mid_type, uncertainty_type
  epireview::param_pm_uncertainty()

#reorder_studies <- TRUE
#if (reorder_studies) df <- epireview::reorder_studies(df)

#Let's step in
#p <- forest_plot(df, ...)
##TODO: Can we not add the param_pm_uncertainty inside of forest plot?

#forest_plot <- function(df, facet_by = NA, shape_by = NA, col_by = NA,
#                        shp_palette = NA,
#                        col_palette = NA) {

## ggplot2 will put all article labels on the y-axis
## even if mid, low, and high are NA. We will filter them out
## here to avoid that.
## We want at least one of mid, low, or high to be non-NA
## for each row
rows <- apply(df, 1, function(x) {
  any(!is.na(x[c("mid", "low", "high")]))
}, simplify = TRUE)
df <- df[rows, ]
## We don't want to plot rows where mid_type is "Range midpoint" or
## "Uncertainty width".
df$mid[df$mid_type %in% c("Range midpoint")] <- NA

## uncertainty_type was created by us in param_pm_uncertainty
## so the user has no visibility of this variable. The main thing
## is that we want to distinguish Range** which is slightly different
## from the other types of uncertainty
uc_types <- unique(df$uncertainty_type)
lty_map <- rep("solid", length(uc_types))
names(lty_map) <- uc_types
lty_map[["Range**"]] <- "dotted"
## note that if you use dashed linetype here, then the legend only shows
## a single dash, which is of course indisguishable from a solid line.

p <- ggplot(df) +
  geom_point(aes(x = .data[['mid']], y = .data[['article_label']])) +
  geom_errorbar(
    aes(xmin = .data[['low']], xmax = .data[['high']], y = .data[['article_label']],
        lty = uncertainty_type)
  ) +
  scale_linetype_manual(values = lty_map, breaks = "Range**") +
  ##scale_y_discrete(breaks = df$article_label, labels = df$article_label) +
  epireview::theme_epireview()

#Remove y axis label
p <- p + theme(axis.title.y = element_blank())

if (!is.na(facet_by)) {
  p <- p + facet_col(
    ~.data[[facet_by]], scales = "free_y", space = "free"
  )
}

#Test out shape_by here
shape_by <- "parameter_value_type"
shp_palette <- NA

if (!is.na(shape_by)) {
  p <- p + aes(shape = .data[[shape_by]])
  ## use the palette if provided, otherwise use the default
  ## as defined in epireview
  ## if neither is provided, use the default palette
  if (!is.na(shp_palette)) {
    p <- p + scale_shape_manual(values = shp_palette)
  } else {
    shp_palette <- epireview::shape_palette(shape_by)
    if (! is.null(epireview::shape_palette)) {
      p <- p + scale_shape_manual(values = shp_palette)
    } else {
      ## if no palette is found, use the default and issue a warning
      warning(paste("No palette was provided or found for ", shape_by, ".
          Using default palette"))
    }


  }
}

col_by <- "parameter_type"
col_palette <- NA

if (!is.na(col_by)) {
  p <- p + aes(col = .data[[col_by]])
  ## use the palette if provided, otherwise use the default
  ## as defined in epireview
  ## if neither is provided, use the default palette
  if (!is.na(col_palette)) {
    p <- p + scale_color_manual(values = col_palette)
  } else {
    col_palette <- epireview::color_palette(col_by) #this currently returns only R number options?
    if (! is.null(col_palette)) {
      p <- p + scale_color_manual(values = col_palette)
    } else {
      ## if the palette is not found, use the default and issue a warning
      warning(paste("No palette was provided or found for ", col_by, ".
        Using default palette"))
    }

  }
}
p




#SO, ALL TOGETHER NOW:
#PP VERSION:

#Load in the data that is exported from the db_compilation task:
articles   <- read_csv("articles.csv")
models     <- read_csv("models.csv")
parameters <- read_csv("parameters.csv")

#Curate here does a bit of tidying
dfs <- curation(articles,tibble(),models,parameters, adjust_for_exponents = FALSE )
#split them up again
articles   <- dfs$articles
models     <- dfs$models
parameters <- dfs$parameters

#Filter down to whatever parameter you want:
d1 <- parameters %>% filter(parameter_type == 'Human delay - incubation period')

p1 <- forest_plot(d1,'Incubation Period (days)',"parameter_type",c(0,20))
p1

#EPIREVIEW VERSION
epireview::forest_plot_incubation_period(d1)
#fails
epireview::forest_plot_incubation_period(d1, reorder_studies = FALSE)
#Error here where we have done the ref and uref thing instead

#ebola <- epireview::load_epidata('ebola')
#ebola <- ebola$params
#ebola$article_label  EXISTS

#so, have to run:
d1   <- d1 %>% mutate(article_label = make.unique(refs)) %>%
  mutate(article_label = factor(article_label, levels = rev(unique(article_label))))

d1$article_label

epireview::forest_plot_incubation_period(d1)
epireview::forest_plot_incubation_period(d1, reorder_studies = FALSE) #not sure difference
epireview::forest_plot_incubation_period(d1, reorder_studies = FALSE, shape_by = "parameter_value_type")
epireview::forest_plot_incubation_period(d1, reorder_studies = FALSE, shape_by = "parameter_value_type", ulim = 20)

#Looks like there's an issue with some of the uncertainties being interpretted differently between the two
#And need to check that business with the color too in the epireview version, it only wants for R number
epireview::forest_plot_incubation_period(d1, reorder_studies = FALSE, shape_by = "parameter_value_type", ulim = 20, col_by = "parameter_type")

#TODO list:
# can we scoop up the low/mid/high into the function itself?
# need to fix the colors business (epireview version only works for R atm)
# Need to implement some functionality on picking up SDs and other options
# get to the bottom of these funky ranges and how we display these
# Implement some limit functionality e.g. c(0,20)
# Will have to add version increase
