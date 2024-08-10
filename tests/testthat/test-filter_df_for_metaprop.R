df <- load_epidata("lassa")[["params"]]
cfr_df <- df[df$parameter_type %in% "Severity - case fatality rate (CFR)",]
prob <- is.na(cfr_df$parameter_value) & !is.na(cfr_df$parameter_unit)
if (any(prob)) cfr_df <- cfr_df[! prob,]

num_col <- "cfr_ifr_numerator"
denom_col <- "cfr_ifr_denominator"

test_that("filtering parameter dataframe for meta prop works",{

  ## Check that error messages are as expected
  required_cols <- c("parameter_value",
                     "parameter_unit",
                     "cfr_ifr_numerator",
                     "cfr_ifr_denominator")

  for(i in required_cols){
    df1 <- cfr_df[, -grep(i, colnames(cfr_df))]
    expect_error(filter_df_for_metaprop(df1, num_col, denom_col), regexp = i)
  }

  ## Check that rows with missing denominator are removed
  df2 <- filter_df_for_metaprop(cfr_df, num_col, denom_col)
  expect_equal(dim(df2)[1], 74L)

  ## Check that the resulting df has the same columns
  expect_true(all(names(cfr_df) %in% names(df2)))
  expect_true(all(names(df2) %in% names(cfr_df)))

  ## TODO: do we need to add extra checks e.g. when numerator and denominator 
  ## are both NA?
  #cfr_df[1, num_col] <- NA
  #cfr_df[1, denom_col] <- NA
  #out <- filter_df_for_metaprop(cfr_df, num_col, denom_col)

})
