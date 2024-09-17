#' Ensure that each article gets a unique id across all tables
#' @details
#' In some instances, an article is associated with more than one id in the
#' parameters, models, or outbreaks tables. 
#' This can lead to unexpected failures because we use the id to join the
#' articles with other dataframes. This function will resolve the issue by
#' first checking if a covidence id is mapped to more than one id. If it is, we
#' replace one of the two ensuring that the same id is used across
#' articles, models, outbreaks, and parameters. This function is not expected to
#' be used directly by the user, but is called by \code{\link{load_epidata}}. Hence
#' checks on arguments are not implemented.
#' @section Need for article ids: 
#' Why do we need article ids in the first place? Why not use covidence id?
#' To ease the process of data extraction, we created a separate database for
#' each extractor, with the goal of then merging the databases into a single
#' database. Within each individual database, the different dataframes are linked
#' by Access generated primary keys. These keys are unique to each database,
#' but are not unique across databases. To merge the databases, we therefore
#' generate a unique id for each article using \code{\link[ids]{random_id}}.
#' Note that we cannot use covidence id for merging tables within each database
#' because covidence id is only present in the articles table.
#' @section Why does an article end up with multiple ids? :
#' Articles that have been extracted by two extractors will have multiple ids.
#' In principle, this should not be a problem because as extractors resolve
#' differences in data extracted, they generate a consensus entry by deleting
#' one of the entries so that only one of the two ids should enter back into the
#' database when the resolved entries are merged with the rest of the data.
#' However, in practice, while resolving conflicts for multiple parameters or
#' models, extractors may delete the row with Id1 in one case and the row with
#' Id2 in another case. This can lead to the same article having multiple ids
#' in parameters, models, or outbreaks.
#' Because an article that has been double extracted will have been aasigned two
#' ids, it is also possible that the retained id in articles is not the same as
#' the retained id in parameters, models, or outbreaks. This can lead to rows
#' in parameters, models, or outbreaks that are not linked to any article. 
#' @param articles A dataframe with the articles table
#' @param df A dataframe with the table that needs to be checked for duplicate
#' covidence ids. Both articles and df will be loaded through 
#' \code{\link{load_epidata}}.
#' @param df_name A the name of the df that will be loaded through 
#' \code{\link{load_epidata}}.
#' 
#' @return A dataframe with the same structure as df, but with unique ids for
#' each covidence id.
#' @importFrom cli cli_inform
#'
make_unique_id <- function(articles, df, df_name) {
  ## Can happen for marburg
  if (! "covidence_id" %in% colnames(df)) {
    cli_inform(sprintf("Note: the %s dataframe does not have a covidence_id column",
                       df_name))
    return(df)
  }
  ## Check if there are any duplicate covidence ids in the articles table.
  ## Generally, you can expect that there won't be any duplicates in articles
  ## and duplicates in one or all of the other tables. 
  dups <- do.call(what = "rbind", args = by(
    df, df$covidence_id,
    function(x1) {
      data.frame(
        covidence_id = x1$covidence_id[1], n_ids = length(unique(x1$id))
      )
    }
  ))
  
  dups <- dups[dups$n_ids > 1, ]
  
  if (nrow(dups) == 0) {
    return(df)
  }
  
  ## If there are duplicates, we need to replace one of the ids. We will make
  ## a lookup table of covidence ids to ids and use it to fix all the tables.
  dups$id <- articles$id[match(dups$covidence_id, articles$covidence_id)]

  ## Now find ids in df that are not present in articles; these also need to be
  ## fixed.
  missing_ids <- setdiff(df$id, articles$id)
  cov_ids <- unique(df$covidence_id[df$id %in% missing_ids])
  cov_ids <- cov_ids[!cov_ids %in% dups$covidence_id]
  more_fixes <- data.frame(
    covidence_id = cov_ids,
    n_ids = 0, ## Not used; adding so that we can rbind
    id = articles$id[match(cov_ids, articles$covidence_id)]
  )
  dups <- rbind(dups, more_fixes)
  ## For each covidence id in dups, find all rows in df with that 
  ## covidence id and replace the id with the id in dups.
  for (i in 1:nrow(dups)) {
    cov_id <- dups$covidence_id[i]
    id <- dups$id[i]
    df$id[df$covidence_id == cov_id] <- id
  }
  df
}
