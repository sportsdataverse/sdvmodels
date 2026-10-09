# CLAUDE.md — sdvmodels

`sdvmodels` is the SportsDataverse twin of nflverse's `fastrmodels`: a
**data-only R package** that hosts fitted models so consumers install them
once instead of downloading them. 0.1.0 ships the college football models of
the `cfb_model_artifacts` release of `sportsdataverse/sportsdataverse-data`,
the single bundle both `cfbfastR` and `sportsdataverse-py` score with.
MIT, `main` is the default and release branch.

## Layout

```text
R/data.R                 roxygen for every data object (one block per object)
R/sdvmodels-package.R    package doc + usethis namespace block (importFrom xgboost getinfo)
data/*.rda               LazyData, LazyDataCompression: xz  (~6 MB together)
data-raw/MODELS.R        rebuilds data/ from data-raw/artifacts/ (gitignored download)
tests/testthat/          manifest byte-length + xgboost parse + print snapshots
```

## The data contract

- Every `cfb_*_model` is the **raw UBJ byte vector of the released file**
  (`readBin`, never re-serialised by the local xgboost), so it is byte-identical
  to what sportsdataverse-py scores with. Read one with
  `xgboost::xgb.load.raw()`. Raw vectors survive xgboost serialisation changes;
  R objects did not (fastrmodels NEWS 2.0.0 / 2.1.0).
- Object names are **`cfb_`-prefixed** (`cfb_ep_model`, `cfb_wp_spread_model`,
  ...) so other sports can join later without renames.
- `cfb_model_manifest` is the bundle's `MANIFEST.json`; the tests assert each
  raw vector's length against `assets[[file]]$bytes` and its feature names
  against `assets[[file]]$features`. A new bundle that changes a feature
  contract fails the tests, by design.
- `cfb_model_cards` / `cfb_punt_distribution` / `cfb_field_position_ep` are the
  sidecar JSON / parquet files of the same release.

## Updating the models

```sh
gh release download cfb_model_artifacts --repo sportsdataverse/sportsdataverse-data --dir data-raw/artifacts --clobber
Rscript -e 'source("data-raw/MODELS.R")'   # needs arrow + jsonlite + usethis
Rscript -e 'devtools::document(); devtools::test()'
```

Bump `Version`, add a NEWS bullet naming the bundle `model_version`, and update
the `@format` feature lists in `R/data.R` if a contract changed. Snapshot files
under `tests/testthat/_snaps/` change when a model changes; review the diff.

## CRAN

- `cran-comments.md` carries the data-package size justification (the policy
  paragraph fastrmodels cites). Keep it current with the measured `data/` size.
- `R CMD check --as-cran` on Windows R 4.6.1 shows a spurious `'NULL'` directory
  NOTE (R artifact, not package code) — see the sdvplotR notes in the toolkit.
- CRAN badge URLs 404 until the package is published; `urlchecker` flags them,
  leave them.

## Conventions

- Conventional Commits; **never** add AI co-author trailers.
- `README.md` is knitted from `README.Rmd` (`devtools::build_readme()`).
- Never hand-edit `NAMESPACE` or `man/*.Rd`.
