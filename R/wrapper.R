#' @export
naive_synthesis_with_dist <- function(df) {

    with_dist <- df[! is.na(df$distribution_type), ]
    out <- vector(mode = "list", length = nrow(with_dist))
    ## TODO: check that dist is one of distributions supported by epiparameter
    for (row in seq_len(nrow(out))) {
      if (with_dist$distribution_type[[row]] %in% "Gamma") {
        ## Update it to R names
        with_dist$distribution_type[[row]] <- "gamma"
        ## Could be mean and sd
        ## could be mean and cv
        if (with_dist$distribution_par1_type[[row]] %in% "Mean" &
          with_dist$distribution_par2_type[[row]] %in% "Mean sd") {
           params <- epiparameter::convert_summary_stats_to_params(
            "gamma", mean = with_dist$distribution_par1_value[[row]],
              sd = with_dist$distribution_par2_value[[row]]
          )
        } else if (with_dist$distribution_par1_type[[row]] %in% "Mean" &
          with_dist$distribution_par2_type[[row]] %in% "CV") (
           params <- convert_summary_stats_to_params(
            "gamma", mean = with_dist$distribution_par1_value[[row]],
              cv = with_dist$distribution_par2_value[[row]]
          )
        )
        ## could be shape and scale
        ## could be shape and rate
      } 
      out[[row]] <- epiparameter::epidist(
        disease = paste(with_dist$pathogen[[row]], "disease", sep = " "),
        pathogen = with_dist$pathogen[[row]],
        epi_dist = with_dist$parameter_type_short[[row]],
        prob_distribution = with_dist$distribution_type[[row]],
        prob_distribution_params = unlist(params),
      )
    }
  out
}


naive_synthesis_without_dist <- function(df) {
    
} 