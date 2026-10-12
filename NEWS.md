# sdvmodels 0.1.0

* Initial release: the college football models of the `cfb_model_artifacts`
  release (expected points, win probability with and without the spread,
  overtime reach, field goal, fourth down conversion, two point conversion,
  expected pass, completion probability with and without air yards, and
  quarterback rating) as raw `xgboost` vectors, plus the punt distance
  distribution, the field position expected points table, the model cards
  and the bundle manifest. Bundle version 2026.10.12, the models
  sportsdataverse-py scores with as of that date.
* Bundle 2026.10.12 against 2026.09.09:
  - `cfb_qbr_model` is the 2026-09-30 retrain on the features the
    play-by-play processor serves. It drops the `spread` feature (9 features,
    not 10), so a consumer that builds a fixed column list must take the
    feature names from the booster (`xgboost::getinfo(m, "feature_name")`).
  - New `cfb_cp_air_yards_model`, the completion probability model for passes
    with known air yards, and `cfb_wp_ot_reach_model`, the probability the
    game reaches overtime.
  - The manifest is now generated from the bundle files by
    `data-raw/MANIFEST.R`; the 2026.09.09 card hashes predated the card
    upload and are corrected.
* Hex logo: an isometric battery cell whose lid shows six decision trees wired
  into the terminal (gradient boosting), drawn by `data-raw/hex-logo/`.
* A pkgdown site at <https://sdvmodels.sportsdataverse.org> with a getting
  started article, and a citation entry (`citation("sdvmodels")`).
