---
name: Bug report
about: A model will not load, a data object is missing or malformed, or the package fails to install
title: "[bug] <short description>"
labels: ["bug", "needs-triage"]
assignees: ""

---

## Describe the bug

A clear and concise description of what went wrong (an error from
`xgboost::xgb.load.raw()`, a feature name that does not match the manifest, a
missing column in a data table, an install failure, etc.).

If the model loads but its predictions look wrong, that belongs with the
training pipeline: please open the issue in
[sportsdataverse-py](https://github.com/sportsdataverse/sportsdataverse-py/issues)
instead, since sdvmodels re-packages the released bundle byte for byte.

## Which object?

- [ ] `cfb_ep_model`
- [ ] `cfb_wp_spread_model` / `cfb_wp_naive_model`
- [ ] `cfb_fg_model` / `cfb_fd_model` / `cfb_two_pt_model`
- [ ] `cfb_xpass_model` / `cfb_cp_model` / `cfb_qbr_model`
- [ ] `cfb_punt_distribution` / `cfb_field_position_ep`
- [ ] `cfb_model_cards` / `cfb_model_manifest`
- [ ] Installation / the package as a whole

## Reproducible example

```r
library(sdvmodels)

m <- xgboost::xgb.load.raw(cfb_ep_model)
xgboost::getinfo(m, "feature_name")

# Smallest call that reproduces the problem:
```

## Error message / output

Paste the full error or warning in a code fence (please no screenshots of text).

```
# Error in ...
```

## Session info

```r
sessionInfo()
packageVersion("sdvmodels")
packageVersion("xgboost")
cfb_model_manifest$model_version
```
