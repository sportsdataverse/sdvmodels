# Contributing to sdvmodels

Thanks for helping. sdvmodels is a data package: it re-packages the fitted
models that the [sportsdataverse-py](https://github.com/sportsdataverse/sportsdataverse-py)
pipeline trains and publishes, so most changes are either a new bundle or a
fix to how the bundle is packaged and documented.

## Filing an issue

* **A model will not load, an object is missing, or install fails:** use the
  **Bug report** template, with a minimal reprex and `sessionInfo()`.
* **A model's predictions look wrong:** that is the training pipeline; open the
  issue in [sportsdataverse-py](https://github.com/sportsdataverse/sportsdataverse-py/issues).
* **A model or table sdvmodels should ship:** use the **Model request** template.

## Development setup

```r
install.packages(c("devtools", "roxygen2", "testthat", "pkgdown", "arrow", "jsonlite", "usethis"))
devtools::load_all()
devtools::test()
devtools::document()
devtools::check()
```

## Updating the models

```sh
gh release download cfb_model_artifacts --repo sportsdataverse/sportsdataverse-data --dir data-raw/artifacts --clobber
Rscript -e 'source("data-raw/MODELS.R")'
Rscript -e 'devtools::document(); devtools::test()'
```

Every `cfb_*_model` must stay the raw UBJ byte vector of the released file
(`readBin`, never re-serialised by the local xgboost), so it is byte-identical
to what sportsdataverse-py scores with. Parquet-derived tables must be
materialised before saving; see `CLAUDE.md` for why.

## The logo and the site

* The hex logo, favicons and social card are drawn by `data-raw/hex-logo/`
  (`npm install && npm run build`); never edit the PNGs by hand.
* The pkgdown site deploys from `main` to the `gh-pages` branch through
  `.github/workflows/pkgdown.yaml`. Preview locally with
  `pkgdown::build_site()`.

## Commits and pull requests

* Use [Conventional Commits](https://www.conventionalcommits.org/)
  (`data:`, `feat:`, `fix:`, `docs:`, `test:`, `chore:`, `ci:`).
* One logical change per commit, on a branch, through a pull request.
* Never list AI tools as co-authors; the human author is the sole contributor
  of record.

## Code of conduct

This project follows the [Contributor Covenant](CODE_OF_CONDUCT.md). By
participating you agree to abide by its terms.
