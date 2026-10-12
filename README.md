
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sdvmodels <a href='https://sdvmodels.sportsdataverse.org'><img src="man/figures/logo.png" alt="sdvmodels hex logo" align="right" width="120" /></a>

<!-- badges: start -->

[![CRAN
version](https://img.shields.io/cran/v/sdvmodels?label=CRAN&logo=R&style=for-the-badge)](https://CRAN.R-project.org/package=sdvmodels)
[![Version-Number](https://img.shields.io/github/r-package/v/sportsdataverse/sdvmodels?label=sdvmodels&logo=R&style=for-the-badge)](https://github.com/sportsdataverse/sdvmodels/)
[![R-CMD-check](https://img.shields.io/github/actions/workflow/status/sportsdataverse/sdvmodels/R-CMD-check.yaml?branch=main&label=R-CMD-Check&logo=R&logoColor=white&style=for-the-badge)](https://github.com/sportsdataverse/sdvmodels/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg?style=for-the-badge&logo=github)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![License:
MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](https://github.com/sportsdataverse/sdvmodels/blob/main/LICENSE.md)
[![X
Follow](https://img.shields.io/twitter/follow/saiemgilani?color=blue&label=%40saiemgilani&logo=x&style=for-the-badge)](https://x.com/saiemgilani)
[![X
Follow](https://img.shields.io/twitter/follow/SportsDataverse?color=blue&label=%40SportsDataverse&logo=x&style=for-the-badge)](https://x.com/SportsDataverse)
[![Contributors](https://img.shields.io/github/contributors/sportsdataverse/sdvmodels?style=for-the-badge)](https://github.com/sportsdataverse/sdvmodels/graphs/contributors)
<!-- badges: end -->

A data package that hosts the fitted models used by
[cfbfastR](https://cfbfastR.sportsdataverse.org/) and the wider
SportsDataverse ecosystem, in the way
[fastrmodels](https://github.com/nflverse/fastrmodels) hosts the models
of nflfastR. The models are the `cfb_model_artifacts` release of
[sportsdataverse-data](https://github.com/sportsdataverse/sportsdataverse-data),
the single bundle that both cfbfastR and
[sportsdataverse-py](https://py.sportsdataverse.org/) score with,
re-packaged byte for byte.

Data freshness and pipeline status for every SportsDataverse dataset:
[sportsdataverse.org/status](https://sportsdataverse.org/status).

## **Installation**

You can install the released version of sdvmodels from
[CRAN](https://CRAN.R-project.org/package=sdvmodels) with:

``` r
install.packages("sdvmodels")
```

And the development version from
[GitHub](https://github.com/sportsdataverse/sdvmodels) with:

``` r
# install.packages("pak")
pak::pak("sportsdataverse/sdvmodels")
```

## **What is in it**

| Object                  | Model                                                            | Objective                    |
| ----------------------- | ---------------------------------------------------------------- | ---------------------------- |
| `cfb_ep_model`          | Expected points (next score)                                     | `multi:softprob`, 7 classes  |
| `cfb_wp_spread_model`   | Win probability with the point spread                            | `binary:logistic`            |
| `cfb_wp_naive_model`    | Win probability without the spread                               | `binary:logistic`            |
| `cfb_fg_model`          | Field goal make probability                                      | `binary:logistic`            |
| `cfb_fd_model`          | Fourth down yards-gained distribution                            | `multi:softprob`, 76 classes |
| `cfb_two_pt_model`      | Two point conversion                                             | `binary:logistic`            |
| `cfb_xpass_model`       | Expected pass                                                    | `binary:logistic`            |
| `cfb_cp_model`          | Completion probability                                           | `binary:logistic`            |
| `cfb_qbr_model`         | Quarterback rating                                               | `reg:squarederror`           |
| `cfb_punt_distribution` | Net punt yardage by field position                               | data frame                   |
| `cfb_field_position_ep` | Expected points by yards to goal                                 | data frame                   |
| `cfb_model_cards`       | One model card per model                                         | list                         |
| `cfb_model_manifest`    | The bundle manifest (feature contracts, SHA-256, EP class order) | list                         |

## **Quickstart**

Each `xgboost` model is the raw UBJ byte vector of the released file, so
it loads with any `xgboost` version that reads UBJ:

``` r
library(sdvmodels)

ep <- xgboost::xgb.load.raw(cfb_ep_model)
xgboost::getinfo(ep, "feature_name")
#> [1] "TimeSecsRem"          "yards_to_goal"        "distance"            
#> [4] "down_1"               "down_2"               "down_3"              
#> [7] "down_4"               "pos_score_diff_start"

cfb_model_manifest$ep_class_contract$class_order
#> [1] "TD"         "Opp_TD"     "FG"         "Opp_FG"     "Safety"    
#> [6] "Opp_Safety" "No_Score"
```

Scoring a play, and the rest of the feature contracts, are walked
through in [Getting
started](https://sdvmodels.sportsdataverse.org/articles/getting-started.html).

## **Updating the models**

The models are trained and published by the sportsdataverse-py model
pipeline. To re-package a new bundle, download the release into
`data-raw/artifacts` and run `data-raw/MODELS.R`:

``` sh
gh release download cfb_model_artifacts --repo sportsdataverse/sportsdataverse-data --dir data-raw/artifacts --clobber
Rscript -e 'source("data-raw/MODELS.R")'
```

## **Follow the [SportsDataverse](https://sportsdataverse.org/) (@SportsDataverse) on X and star this repo**

[![X
Follow](https://img.shields.io/twitter/follow/SportsDataverse?color=blue&label=%40SportsDataverse&logo=x&style=for-the-badge)](https://x.com/SportsDataverse)

[![GitHub
stars](https://img.shields.io/github/stars/sportsdataverse/sdvmodels.svg?color=eee&logo=github&style=for-the-badge&label=Star%20sdvmodels&maxAge=2592000)](https://github.com/sportsdataverse/sdvmodels)

sdvmodels is part of the [SportsDataverse](https://sportsdataverse.org).
Related packages:

  - [cfbfastR](https://cfbfastR.sportsdataverse.org/): college football
    play-by-play, scored with these models
  - [cfb4th](https://cfb4th.sportsdataverse.org/): college football
    fourth-down decisions
  - [sportsdataverse-py](https://py.sportsdataverse.org/): the Python
    side, which trains and scores the same bundle
  - [fastrmodels](https://github.com/nflverse/fastrmodels): the nflverse
    package sdvmodels mirrors
  - [sportsdataverse-R](https://r.sportsdataverse.org/): the
    SportsDataverse R meta-package

## **Our Authors**

  - [Saiem Gilani](https://x.com/saiemgilani)
    <a href="https://x.com/saiemgilani" target="blank"><img src="https://img.shields.io/twitter/follow/saiemgilani?color=blue&label=%40saiemgilani&logo=x&style=for-the-badge" alt="@saiemgilani" /></a>
    <a href="https://github.com/saiemgilani" target="blank"><img src="https://img.shields.io/github/followers/saiemgilani?color=eee&logo=Github&style=for-the-badge" alt="@saiemgilani" /></a>

## **Citations**

To cite the [**`sdvmodels`**](https://sdvmodels.sportsdataverse.org/) R
package in publications, use:

BibTeX Citation

``` bibtex
@misc{gilani_sdvmodels,
  author = {Saiem Gilani},
  title = {sdvmodels: Models for the SportsDataverse Packages.},
  url = {https://sdvmodels.sportsdataverse.org/},
  year = {2026}
}
```
