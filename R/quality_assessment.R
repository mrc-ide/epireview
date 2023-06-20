#' Plots for the quality assessment of the included studies
#'
#' @param pathogen pathogen data set to consider
#' @return two plots for quality assessment
#' @importFrom readr read_csv
#' @importFrom dplyr %>% filter group_by ungroup count n starts_with mutate
#' case_when summarize
#' @importFrom readr read_csv
#' @importFrom tidyr pivot_longer
#' @importFrom ggplot2 ggplot aes geom_point geom_smooth theme_bw xlab ylab
#' scale_x_continuous geom_bar scale_fill_manual coord_flip theme labs ggplot_add
#' @examples
#' quality_assessment_plots(pathogen = "marburg")
#' @export


quality_assessment_plots <- function(pathogen = NA)
  {

  if(is.na(pathogen)){
    stop("pathogen name must be supplied")
  }

  quality <- read_csv(system.file("data",
                                  paste0(pathogen, "_article.csv"),
                                  package = "epireview"))

  # time series plot
  QA_time_series <- quality %>%
    filter(!is.na(year_publication) & !is.na(pathogen)) %>%
    ggplot(aes(x = year_publication, y = score)) +
    geom_point() +
    geom_smooth(span = 2) +
    theme_bw() +
    xlab("Year of publication") +
    ylab("Quality assessment score") +
    scale_x_continuous(
      # x axis determined by nearest decade to first publication and current year
      breaks = seq(round(min(quality$year_publication, na.rm = TRUE), -1),
                   as.double(substring(Sys.time(), 1, 4)),
                   by = 10))

  # count plot by question
  answers <- quality %>%
    filter(!is.na(year_publication) & !is.na(pathogen)) %>%
    dplyr::select(covidence_id, starts_with("qa")) %>%
    pivot_longer(-covidence_id, names_to = "Question", values_to = "Assessment") %>%
    mutate(Assessment = as.factor(as.character(Assessment)),
           Assessment = case_when(Assessment == '1' ~ 'Yes',
                                  Assessment == '0' ~ 'No')) %>%
    mutate(Question = case_when(
      Question == "qa_m1" ~ "Q1 Method: \nClear & reproducible",
      Question == "qa_m2" ~ "Q2 Method: \nRobust & appropriate",
      Question == "qa_a3" ~ "Q3 Assumption: \nClear & reproducible",
      Question == "qa_a4" ~ "Q4 Assumption: \nRobust & appropriate",
      Question == "qa_d5" ~ "Q5 Data: \nClear & reproducible",
      Question == "qa_d6" ~ "Q6 Data: \nIssues acknowledged",
      Question == "qa_d7" ~ "Q7 Data: \nIssues accounted for"))

  answers$Question <- factor(answers$Question,
                             levels = rev(levels(factor(answers$Question))))

  answers$Assessment[is.na(answers$Assessment)] <- "NA"
  answers$Assessment <- factor(answers$Assessment,levels = c("NA", "No", "Yes"))

  QA_answers <- answers %>%
    group_by(Question, Assessment) %>% summarize(count=n()) %>% ungroup() %>%
    ggplot(aes(fill = Assessment, y = count, x = Question)) +
    geom_bar(position = "stack", stat = "identity") +
    theme_bw() +
    scale_fill_manual(values = c("darkolivegreen2", "coral1", "grey70"),
                      aesthetics = "fill", name = "",
                      breaks = c('Yes', 'No','NA')) +
    xlab("") +
    ylab("Count of papers") +
    coord_flip() +
    theme(legend.position = 'bottom')

  return(QA_answers + labs(tag = "A") + QA_time_series + labs(tag = "B"))
}


