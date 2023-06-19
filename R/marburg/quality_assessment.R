#' marburg_quality_assessment_plots
#'
#' @return plot of quality assessment
#' @examples
#' marburg_quality_assessment_plots()
#' @export (the export tag just allows the function to be exported)

library(ggplot2)
library(tidyverse)
library(patchwork)

marburg_quality_assessment_plots <- function(location_prepend='')
{
  quality <- read_csv(paste0(location_prepend,"data/marburg/quality_final.csv"))
  article <- read_csv(paste0(location_prepend,"data/marburg/article_final.csv"))
  quality <- quality %>% rowwise() %>% mutate(score = mean(c(qa_m1,qa_m2,qa_a3,qa_a4,qa_d5,qa_d6,qa_d7),na.rm=TRUE)) %>%
    left_join(article,by=c('article_id','covidence_id','pathogen'))


  # time series plot
  QA_time_series <- quality %>% filter(!is.na(year_publication) & !is.na(pathogen)) %>%
    ggplot(aes(x=year_publication,y=score)) +
    geom_point() + geom_smooth(span = 2) + theme_bw() +
    xlab("Year of publication") + ylab("Quality assessment score") +
    scale_x_continuous(breaks = seq(1970, 2023, by=10))

  # count plot by question
  answers <- quality %>%
    filter(!is.na(year_publication) & !is.na(pathogen)) %>%
    dplyr::select(covidence_id,qa_m1,qa_m2,qa_a3,qa_a4,qa_d5,qa_d6,qa_d7) %>%
    pivot_longer(-covidence_id,names_to = "Question",values_to= "Assessment") %>% mutate(Assessment=as.factor(as.character(Assessment)),
                                                                                         Assessment=case_when(Assessment == '1' ~ 'Yes',
                                                                                                              Assessment == '0' ~ 'No')) %>%
    mutate(Question=case_when(Question=="qa_m1"~"Q1 Method: \nClear & reproducible",
                              Question=="qa_m2"~"Q2 Method: \nRobust & appropriate",
                              Question=="qa_a3"~"Q3 Assumption: \nClear & reproducible",
                              Question=="qa_a4"~"Q4 Assumption: \nRobust & appropriate",
                              Question=="qa_d5"~"Q5 Data: \nClear & reproducible",
                              Question=="qa_d6"~"Q6 Data: \nIssues acknowledged",
                              Question=="qa_d7"~"Q7 Data: \nIssues accounted for"))

  answers$Question <- factor(answers$Question, levels=rev(c("Q1 Method: \nClear & reproducible",
                                                            "Q2 Method: \nRobust & appropriate",
                                                            "Q3 Assumption: \nClear & reproducible",
                                                            "Q4 Assumption: \nRobust & appropriate",
                                                            "Q5 Data: \nClear & reproducible",
                                                            "Q6 Data: \nIssues acknowledged",
                                                            "Q7 Data: \nIssues accounted for")))

  answers$Assessment[is.na(answers$Assessment)] <- "NA"
  answers$Assessment <- factor(answers$Assessment,levels=c("NA","No","Yes"))

  QA_answers <- answers %>%
    group_by(Question,Assessment) %>% summarize(count=n()) %>% ungroup() %>%
    ggplot(aes(fill=Assessment, y=count, x=Question)) +
    geom_bar(position="stack", stat="identity") + theme_bw() +
    scale_fill_manual(values = c("darkolivegreen2","coral1","grey70"),aesthetics = "fill",name="",breaks=c('Yes', 'No','NA')) +
    xlab("") + ylab("Count of papers") +
    coord_flip() + theme(legend.position = 'bottom')

  return( QA_answers + labs(tag="A") + QA_time_series +labs(tag="B") )# 900x450
}


