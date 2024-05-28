#' Ensure that each article gets a unique id
#' @details
#' In some instances, articles with the same covidence id will have different ids.
#' This can lead to unexpected failures because we use the id to join the
#' articles with other dataframes. This section will resolve the issue by
#' first checking if a covidence id is mapped to more than one id. If it is, we
#' will replace one of the two ensuring that the same id is used across
#' articles, models, outbreaks, and parameters.
#' @section Need for article ids
#' Why do we need article ids in the first place? Why not use covidence id?
#' To ease the process of data extraction, we created a separate database for
#' each extractor, with the goal of then merging the databases into a single
#' database. Within each individual databse, the different dataframes are linked
#' by Access generated primary keys. These keys are unique to each database,
#' but are not unique across databases. To merge the databases, we therefore
#' generate a unique id for each article using \code{\link[ids]{random_id}}.
#' Note that we cannot use covidence id for merging tables within each database
#' because covidence id is only present in the articles table.
#' @section Why does an article end up with multiple ids?
#' Articles that have been extracted by two extractors will have multiple ids.
#' In principle, this should not be a problem, because as extractors resolve
#' differences in data extracted, they generate a consensus entry by deleting
#' one of the entries so that only one of the two ids should enter back into the
#' database when the resolved entries are merged with the rest of the data.
#' However, in practice, while resolving conflicts for multiple parameters or
#' models, extractors may delete the row with Id1 in one case and the row with
#' Id2 in another case. This can lead to the same article having multiple ids.
#'
#' @export
make_unique_id <- function(articles, params, models, outbreaks) {
  ## Check if there are any duplicate covidence ids in the articles table.
  ## Generally, you can expect that there won't be any duplicates here.
  dups <- do.call(what = "rbind", args = by(
    articles, articles$covidence_id,
    function(x) {
      data.frame(covidence_id = x$covidence_id[1], n_ids = length(unique(x$id)))
    }
  ))

  ## Check if there are any duplicate covidence ids in the params table.
  dups_p <- do.call(what = "rbind", args = by(
    params, params$covidence_id,
    function(x) {
      data.frame(covidence_id = x$covidence_id[1], n_ids = length(unique(x$id)))
    }
  ))

  ## Check if there are any duplicate covidence ids in the models table.
  dups_m <- do.call(what = "rbind", args = by(
    models, models$covidence_id,
    function(x) {
      data.frame(covidence_id = x$covidence_id[1], n_ids = length(unique(x$id)))
    }
  ))

  ## Check if there are any duplicate covidence ids in the outbreaks table.
  dups_o <- do.call(what = "rbind", args = by(
    outbreaks, outbreaks$covidence_id,
    function(x) {
      data.frame(covidence_id = x$covidence_id[1], n_ids = length(unique(x$id)))
    }
  ))
  dups <- dups[dups$n_ids > 1, ]
  dups_p <- dups_p[dups_p$n_ids > 1, ]
  dups_m <- dups_m[dups_m$n_ids > 1, ]
  dups_o <- dups_o[dups_o$n_ids > 1, ]

  no_dups <- FALSE
  if (nrow(dups) == 0) {
    message("No duplicate covidence ids found in articles")
    no_dups <- TRUE
  }
  if (nrow(dups_p) == 0) {
    message("No duplicate covidence ids found in params")
    no_dups <- no_dups & TRUE
  }
  if (nrow(dups_m) == 0) {
    message("No duplicate covidence ids found in models")
    no_dups <- no_dups & TRUE
  }
  if (nrow(dups_o) == 0) {
    message("No duplicate covidence ids found in outbreaks")
    no_dups <- no_dups & TRUE
  }

  if (no_dups) {
    return(
      list(
        articles = articles, params = params, models = models, 
        outbreaks = outbreaks, 
      )
    )
  }
  ## If there are duplicates, we need to replace one of the ids. We will make
  ## a lookup table of covidence ids to ids and use it to fix all the tables.

  return(list(articles = articles, models = models, outbreaks = outbreaks, 
    params = params))
}
