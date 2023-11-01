## Assert functions:

#------------------------------------------------
# x is one of the existing priority pathogens
#' @noRd
assert_pathogen <- function(x, message = paste("%s must be one of the priority pathogens:",
                                           paste(unique(gsub(pattern = "_.*", replacement = "", x = list.files("../../inst/extdata/"))), sep = ", ")),
                            name = deparse(substitute(x))){
  assert_string(x)

  pps <- unique(gsub(pattern = "_.*", replacement = "", x = list.files("../../inst/extdata/")))
  if(!x %in% pps){
    stop(sprintf(message, name), call. = FALSE)}
  return(TRUE)
}

#------------------------------------------------
# x is a table
#' @noRd
assert_table <- function(x, message = paste("%s must be one of the priority pathogens table options:",
                                            paste("article", "parameter", "outbreak", "model", sep = ", ")),
                         name = deparse(substitute(x))){
  assert_string(x)
  table_names <- c("article", "parameter", "outbreak", "model")
  if(!x %in% table_names){
    stop(sprintf(message, name), call. = FALSE)
  }
    return(TRUE)
}

#------------------------------------------------
# x is character string
#' @noRd
assert_string <- function(x, message = "%s must be character string", name = deparse(substitute(x))) {
  if (!is.character(x)) {
    stop(sprintf(message, name), call. = FALSE)
  }
  return(TRUE)
}
