% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pretty_article_label.R
\name{pretty_article_label}
\alias{pretty_article_label}
\title{Make pretty labels for articles}
\usage{
pretty_article_label(articles, mark_multiple)
}
\arguments{
\item{articles}{A data frame containing information about the articles. This
will typically be the output of \code{load_epidata_raw}.}

\item{mark_multiple}{logical. If TRUE, multiple studies from the same
author in the same year will be marked with a suffix to distinguish them.}
}
\value{
A modified data frame with an additional column "article_label"
containing the generated labels.
}
\description{
This function generates pretty labels for articles.
The labels are created by combining the surname of the first year and
year of publication of an article.
If the surname is missing, we will use the first name. If both are missing,
a warning is issued and the Covidence ID is used instead.
}
\examples{
articles <- data.frame(
  first_author_surname = c("Smith", NA, "Johnson"),
  first_author_first_name = c(NA, "John", NA),
  year_publication = c(2010, NA, 2022),
  covidence_id = c("ABC123", "DEF456", "GHI789")
)
pretty_article_label(articles, mark_multiple = TRUE)
}
