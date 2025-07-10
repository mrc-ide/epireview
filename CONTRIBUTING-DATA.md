# Contributing Guidelines

Thank you for your interest in contributing to {epireview}. Please follow the steps below when adding data for a new pathogen.

## Adding Data for a New Pathogen

1. **Create a New Branch**
   - Base your branch off the `develop` branch.
   - Use a descriptive name for the branch (e.g. `add-pathogen-x-data`).

2. **Add Data Files**
   - Place your data files in `inst/extdata/`.
   - Follow existing naming conventions, e.g. `pathogen_name_articles.csv`, `pathogen_name_extracted.csv`, etc.

3. **Update `priority_pathogens()`**
   - In `R/data.R`, edit the `priority_pathogens()` function:
     - Add your new pathogen as a valid argument.
     - Update the number of studies **screened** and **extracted**.
     - Include the DOI if available. If not, use `NA`.

4. **Ensure Column Consistency**
   - Make sure the column names in the new files match those in existing files.
   - If you add new columns or use different names:
     - Update the appropriate function in `R/load_epidata_raw.R`. These are: `article_column_type` for articles, `parameter_column_type` for parameters, `outbreak_column_type` for outbreaks, and `model_column_type` for models. 
     

5. **Optional, but highly recommended - Write or Update Tests**
   - Add new tests if needed in `tests/testthat/`.
   - At minimum, test for the expected number of rows for your new pathogen. If we have these tests in place, we can modify our pipleline or {epireview} with confidence that we are not accidentally breaking something.

6.  Ensure that {epireview} can load the data. Start a new R session in {epireview} and run

```{r}
devtools::document()
devtools::load_all()
load_epidata(<your pathogen name>)
```

You should not say any errors (and ideally no warnings).

7. **Package Maintenance** Before raising a PR to add the data in {epireview}:
   - Increment the package version in `DESCRIPTION`.
   - Add a note to `NEWS.md` describing the change.
   - Run `devtools::document()` to regenerate documentation.
   - Run `devtools::check()` and ensure there are no errors or warnings.

7. **Submit a Pull Request**
   - Open a pull request (PR) to merge your branch into `develop`.
   - Include a brief summary of your changes and what data was added.

---

Please follow the coding and documentation style used in the existing codebase. If you have any questions, feel free to open an issue or reach out via the repository discussion board.

