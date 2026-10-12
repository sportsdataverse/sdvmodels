# Pull Request

## Summary
<!-- A brief, clear summary of what this PR does (2-3 sentences max) -->

## Type of Change

- [ ] `data`: New or updated model bundle (re-packaged from `cfb_model_artifacts`)
- [ ] `feat`: New object or helper
- [ ] `fix`: Bug fix
- [ ] `docs`: Documentation only (roxygen, README, NEWS, articles, pkgdown)
- [ ] `test`: Adding or updating tests
- [ ] `chore` / `ci`: Maintenance, tooling or workflows

## Related Issues
<!-- Closes #123, Fixes #456 -->

## For a new model bundle

- [ ] `data-raw/MODELS.R` re-run from the downloaded release; every model is the raw UBJ bytes of the released file (never re-serialised)
- [ ] `model_version` noted in NEWS.md; `Version` bumped
- [ ] Tests pass: raw-vector lengths match `cfb_model_manifest`, feature names match each asset's contract
- [ ] `@format` feature lists in `R/data.R` updated if a contract changed
- [ ] Snapshot diffs under `tests/testthat/_snaps/` reviewed
- [ ] `data/` size still matches the justification in `cran-comments.md`

## Checklist

- [ ] `devtools::document()` and `devtools::check()` clean (0 errors, 0 warnings)
- [ ] README re-knitted from README.Rmd if it changed
- [ ] Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/)
- [ ] No AI tools listed as co-authors
