# CLAUDE.md — sdvmodels

**Status: empty placeholder repo.** As of this writing `sdvmodels`
(github.com/sportsdataverse/sdvmodels) is a name-reservation stub under the
SportsDataverse org. It contains no source code, no packaging metadata, and no
model artifacts — only a one-line `README.md` (`# sdvmodels`) and an MIT
`LICENSE` (Copyright 2023 SportsDataverse). The name suggests an intended
shared model package/registry for the SportsDataverse ecosystem, but **nothing
has been built here** — do not infer a stack, API, or consumers from the name.

## What's actually in the repo (verified)

```
LICENSE      # MIT, Copyright (c) 2023 SportsDataverse
README.md    # 11 bytes: "# sdvmodels"
```

- Single commit: `341b612 Initial commit` (2023-03-04). Branch `main` only.
- Remote: `origin https://github.com/sportsdataverse/sdvmodels.git`.
- No `pyproject.toml` / `setup.py` / `DESCRIPTION` / `package.json` → **stack
  undetermined** (neither Python, R, nor JS established yet).
- No `.github/workflows/` → no CI.
- No `tests/`, no source dirs, no models, no `.gitignore`.
- GitHub metadata: no description, no topics, 0 stars/forks/issues, repo
  `size: 1`; created and last pushed the same instant — never developed.

## Commands

None verified — there is no build system, test runner, or tooling to invoke.
Adding any would be the first real work in this repo.

## If you are starting development here

Decide the stack first, then add the matching metadata before anything else:

- **Python package** (most likely, to mirror `sportsdataverse-py` consuming
  `nfl/models/*.ubj`, `cfb/models/*` artifacts): add a PEP 621 `pyproject.toml`,
  `src/sdvmodels/`, `tests/`, and a `.github/workflows/` CI. The sibling
  `sportsdataverse-py` repo is the reference for uv-based packaging conventions.
- **Model-artifact host / data repo**: add a `models/` (or release-asset)
  layout + a README documenting provenance and which packages consume each
  artifact, mirroring how `sportsdataverse-data` ships release assets.
- Pick the intended consumers and document them explicitly — the name implies
  cross-package model sharing, but no contract exists yet to follow.

## Conventions

- License is MIT (keep it).
- SportsDataverse house rule: **never add AI co-author trailers** (no
  `Co-Authored-By:` referencing Claude/Copilot/GPT/etc.) on commits or PRs.
- Use Conventional Commits, consistent with the rest of the org.

## Reference

- Repo: https://github.com/sportsdataverse/sdvmodels
- Org: https://github.com/sportsdataverse
- Likely-related siblings (for layout precedent, NOT current dependencies):
  `sportsdataverse-py` (bundles per-league model artifacts), `sportsdataverse-data`
  (release-asset host).
