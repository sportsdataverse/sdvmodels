## Release summary

This is the first CRAN submission of sdvmodels, a data-only package that hosts
the fitted models used by 'cfbfastR' (CRAN) and the SportsDataverse ecosystem,
in the way 'fastrmodels' (CRAN) hosts the models of 'nflfastR'.

## Test environments

* local: Windows 10, R 4.6.1
* GitHub Actions: ubuntu-latest (R devel, release, oldrel-1),
  windows-latest (R release), macos-latest (R release)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new submission.

## Package size

The installed size exceeds 5 MB because of the fitted models in data/
(about 6 MB after xz compression). The CRAN Repository Policy says that where
a large amount of data is required even after compression, consideration
should be given to a separate data-only package which is updated only rarely.
This package exists for that reason: it separates the models from the code
that scores them so consumers need not download them, and it is updated only
when a model is retrained, which is not planned on a regular schedule.

## Notes for the CRAN team

* The models are stored as raw vectors of the 'xgboost' UBJ format and read
  with xgboost::xgb.load.raw(), the representation 'fastrmodels' adopted so the
  objects survive 'xgboost' serialisation changes. Tests verify each vector's
  byte length against the bundle manifest and that it parses with the
  installed 'xgboost'.
* There are no published references describing the methods; the package
  distributes fitted artifacts rather than implementing a method.
