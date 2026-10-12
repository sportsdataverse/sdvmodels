---
name: Model request
about: Suggest a model, sport or sidecar table that sdvmodels should ship
title: "[feat] <short description>"
labels: ["enhancement", "needs-triage"]
assignees: ""

---

## What should sdvmodels ship?

Name the model (or table) and the sport. If it already exists in a
SportsDataverse release, link the release and asset.

## Who uses it?

Which package or workflow would load it from sdvmodels (cfbfastR, cfb4th,
sportsdataverse-py, your own analysis)? Today, does that consumer download it
at run time or bundle its own copy?

## Feature contract

If you know it: the objective (`binary:logistic`, `multi:softprob`, ...), the
ordered feature names, and whether it has a model card.

## Anything else

Links, papers, or prior art (for example the equivalent model in
[fastrmodels](https://github.com/nflverse/fastrmodels)).
