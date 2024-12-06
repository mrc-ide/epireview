test_that("check_column_types works as expected", {
  # check_column_types is a helper function used in load_epidata_raw

  # Create the same env as in load_epidata_raw using lassa params as example
  pps <- priority_pathogens()
  fname <- pps[pps$pathogen == "lassa", "params_file"]
  col_types <- parameter_column_type()
  file_path <- system.file("extdata", fname, package = "epireview")
  tmp <- as.data.frame(vroom(file_path, show_col_types = FALSE))

  cols <- intersect(colnames(tmp), names(col_types))
  col_types <- col_types[cols]

  # *--------------------------------- Test 1 ---------------------------------*
  # *---------------------- No type issues in input csv -----------------------*
  # *--------------------------------------------------------------------------*
  expect_no_error(check_column_types(fname, col_types, colnames(tmp)))

  # *--------------------------------- Test 1 ---------------------------------*
  # *--------------------- 1 column, 1 row type mismatch ----------------------*
  # *--------------------------------------------------------------------------*
  # Introduce a type mismatch to tmp and save it
  tmp[tmp$parameter_type == "Seroprevalence - IFA","parameter_value"][1] <- "test"

  tmpfile <- tempfile(fileext = ".csv")
  write_csv(tmp, file=tmpfile)

  tmp <- as.data.frame(vroom(tmpfile, show_col_types = FALSE))

  # Use the problematic tmp file in check_column_types
  # This should throw an opaque vroom warning, we'll suppress it for clarity of
  # the test
  expect_error(suppressWarnings(check_column_types(tmpfile, col_types, colnames(tmp))))

  # *--------------------------------- Test 3 ---------------------------------*
  # *------------------ 1 column, multiple row type mismatch ------------------*
  # *--------------------------------------------------------------------------*
  # update a second row of tmp to be an issue
  # create tmp2 so that tmp can be used for next test
  tmp2 <- tmp
  tmp2[tmp2$parameter_type == "Seroprevalence - IFA","parameter_value"][2] <- "test"

  tmpfile <- tempfile(fileext = ".csv")
  write_csv(tmp2, file=tmpfile)

  tmp2 <- as.data.frame(vroom(tmpfile, show_col_types = FALSE))

  expect_error(suppressWarnings(check_column_types(tmpfile, col_types, colnames(tmp2))))

  # *--------------------------------- Test 4 ---------------------------------*
  # *------------------ multiple column, 1 row type mismatch ------------------*
  # *--------------------------------------------------------------------------*
  tmp[tmp$parameter_type == "Seroprevalence - IFA","covidence_id"][1] <- "test"

  tmpfile <- tempfile(fileext = ".csv")
  write_csv(tmp, file=tmpfile)

  tmp <- as.data.frame(vroom(tmpfile, show_col_types = FALSE))

  expect_error(suppressWarnings(check_column_types(tmpfile, col_types, colnames(tmp))))

  # *--------------------------------- Test 5 ---------------------------------*
  # *-------------- multiple column, multiple row type mismatch ---------------*
  # *--------------------------------------------------------------------------*
  tmp[tmp$parameter_type == "Seroprevalence - IFA","parameter_value"][2] <- "test"
  tmp[tmp$parameter_type == "Seroprevalence - IFA","covidence_id"][2] <- "test"

  tmpfile <- tempfile(fileext = ".csv")
  write_csv(tmp, file=tmpfile)

  tmp <- as.data.frame(vroom(tmpfile, show_col_types = FALSE))

  expect_error(suppressWarnings(check_column_types(tmpfile, col_types, colnames(tmp))))
})

