#' College football expected points model
#'
#' Seven-class next-score model. Column `i` of the softmax output is
#' `cfb_model_manifest$ep_class_contract$class_order[i]`, worth
#' `cfb_model_manifest$ep_class_contract$point_values[i]` points; expected
#' points is the probability-weighted sum.
#'
#' @format A raw vector representation of an 'xgboost' model
#'   (`multi:softprob`, 7 classes). Features, in order: `TimeSecsRem`,
#'   `yards_to_goal`, `distance`, `down_1`, `down_2`, `down_3`, `down_4`,
#'   `pos_score_diff_start`.
#' @source The `cfb_model_artifacts` release of
#'   <https://github.com/sportsdataverse/sportsdataverse-data>, built by
#'   the `sportsdataverse-py` model pipeline.
#' @examples
#' model <- xgboost::xgb.load.raw(cfb_ep_model)
#' xgboost::getinfo(model, "feature_name")
"cfb_ep_model"

#' College football win probability model (with point spread)
#'
#' @format A raw vector representation of an 'xgboost' model
#'   (`binary:logistic`). Features, in order:
#'   `pos_team_receives_2H_kickoff`, `spread_time`, `TimeSecsRem`,
#'   `adj_TimeSecsRem`, `ExpScoreDiff_Time_Ratio`, `pos_score_diff_start`,
#'   `down`, `distance`, `yards_to_goal`, `is_home`,
#'   `pos_team_timeouts_rem_before`, `def_pos_team_timeouts_rem_before`,
#'   `period`.
#' @source The `cfb_model_artifacts` release of
#'   <https://github.com/sportsdataverse/sportsdataverse-data>.
#' @examples
#' model <- xgboost::xgb.load.raw(cfb_wp_spread_model)
#' xgboost::getinfo(model, "feature_name")
"cfb_wp_spread_model"

#' College football win probability model (without point spread)
#'
#' @format A raw vector representation of an 'xgboost' model
#'   (`binary:logistic`). Same features as [cfb_wp_spread_model] without
#'   `spread_time`.
#' @source The `cfb_model_artifacts` release of
#'   <https://github.com/sportsdataverse/sportsdataverse-data>.
#' @examples
#' model <- xgboost::xgb.load.raw(cfb_wp_naive_model)
#' xgboost::getinfo(model, "feature_name")
"cfb_wp_naive_model"

#' College football field goal model
#'
#' @format A raw vector representation of an 'xgboost' model
#'   (`binary:logistic`). Features, in order: `yards_to_goal`, `era0`,
#'   `era1`, `era2`, `era3` (one-hot rule eras; cuts at 2006, 2013 and 2020,
#'   see `cfb_model_cards$fg_model$era_contract`).
#' @source The `cfb_model_artifacts` release of
#'   <https://github.com/sportsdataverse/sportsdataverse-data>.
#' @examples
#' model <- xgboost::xgb.load.raw(cfb_fg_model)
#' xgboost::getinfo(model, "feature_name")
"cfb_fg_model"

#' College football fourth down conversion model
#'
#' Distribution of yards gained on a fourth down attempt (76 classes,
#' -10 to 65 yards); the probability of gaining at least the distance is the
#' conversion probability.
#'
#' @format A raw vector representation of an 'xgboost' model
#'   (`multi:softprob`, 76 classes). Features, in order: `down`, `distance`,
#'   `yards_to_goal`, `posteam_total`, `posteam_spread`, `era0`, `era1`,
#'   `era2`, `era3`.
#' @source The `cfb_model_artifacts` release of
#'   <https://github.com/sportsdataverse/sportsdataverse-data>.
#' @examples
#' model <- xgboost::xgb.load.raw(cfb_fd_model)
#' xgboost::getinfo(model, "feature_name")
"cfb_fd_model"

#' College football two point conversion model
#'
#' @format A raw vector representation of an 'xgboost' model
#'   (`binary:logistic`). Features, in order: `posteam_spread`,
#'   `posteam_total`, `pos_score_diff`, `era` (integer era bucket).
#' @source The `cfb_model_artifacts` release of
#'   <https://github.com/sportsdataverse/sportsdataverse-data>.
#' @examples
#' model <- xgboost::xgb.load.raw(cfb_two_pt_model)
#' xgboost::getinfo(model, "feature_name")
"cfb_two_pt_model"

#' College football expected pass model
#'
#' @format A raw vector representation of an 'xgboost' model
#'   (`binary:logistic`). Features, in order: `down`, `distance`,
#'   `yards_to_goal`, `pos_score_diff`, `TimeSecsRem`, `era`, `period`.
#' @source The `cfb_model_artifacts` release of
#'   <https://github.com/sportsdataverse/sportsdataverse-data>.
#' @examples
#' model <- xgboost::xgb.load.raw(cfb_xpass_model)
#' xgboost::getinfo(model, "feature_name")
"cfb_xpass_model"

#' College football completion probability model
#'
#' @format A raw vector representation of an 'xgboost' model
#'   (`binary:logistic`). Features, in order: `down`, `distance`,
#'   `yards_to_goal`, `score_diff`, `seconds_remaining`, `is_home`, `period`,
#'   `passing_down`.
#' @source The `cfb_model_artifacts` release of
#'   <https://github.com/sportsdataverse/sportsdataverse-data>.
#' @examples
#' model <- xgboost::xgb.load.raw(cfb_cp_model)
#' xgboost::getinfo(model, "feature_name")
"cfb_cp_model"

#' College football quarterback rating model
#'
#' @format A raw vector representation of an 'xgboost' model
#'   (`reg:squarederror`). Features, in order: `qbr_epa`, `sack_epa`,
#'   `pass_epa`, `rush_epa`, `pen_epa`, `spread`, `era0`, `era1`, `era2`,
#'   `era3`.
#' @source The `cfb_model_artifacts` release of
#'   <https://github.com/sportsdataverse/sportsdataverse-data>.
#' @examples
#' model <- xgboost::xgb.load.raw(cfb_qbr_model)
#' xgboost::getinfo(model, "feature_name")
"cfb_qbr_model"

#' College football punt distance distribution
#'
#' Empirical distribution of net punt yardage by field position, used by the
#' fourth down decision models to score a punt.
#'
#' @format A data frame; see `names(cfb_punt_distribution)`.
#' @source The `cfb_model_artifacts` release of
#'   <https://github.com/sportsdataverse/sportsdataverse-data>.
#' @examples
#' head(cfb_punt_distribution)
"cfb_punt_distribution"

#' College football field position expected points table
#'
#' Expected points at first-and-ten by yards to goal, a lookup used where a
#' full model call is not warranted.
#'
#' @format A data frame; see `names(cfb_field_position_ep)`.
#' @source The `cfb_model_artifacts` release of
#'   <https://github.com/sportsdataverse/sportsdataverse-data>.
#' @examples
#' head(cfb_field_position_ep)
"cfb_field_position_ep"

#' College football model cards
#'
#' One card per model, as published next to each model in the
#' `cfb_model_artifacts` release: model type, training 'xgboost' version,
#' feature list, label, training date and the rule-era encoding contract.
#'
#' @format A named list with one element per model (`ep_model`,
#'   `wp_spread`, `wp_naive`, `fg_model`, `fd_model`, `two_pt_model`,
#'   `xpass_model`, `cfb_cp_model`, `qbr_model`), each a list parsed from the
#'   card's JSON.
#' @source The `cfb_model_artifacts` release of
#'   <https://github.com/sportsdataverse/sportsdataverse-data>.
#' @examples
#' cfb_model_cards$fd_model$features
"cfb_model_cards"

#' College football model bundle manifest
#'
#' The `MANIFEST.json` of the `cfb_model_artifacts` release the models in
#' this package were taken from: bundle version, the expected points class
#' contract (class order, point values and the permutation to the historical
#' 'cfbfastR' level order), and for every asset its SHA-256, byte length,
#' feature list and objective.
#'
#' @format A list parsed from the manifest's JSON.
#' @source The `cfb_model_artifacts` release of
#'   <https://github.com/sportsdataverse/sportsdataverse-data>.
#' @examples
#' cfb_model_manifest$model_version
#' cfb_model_manifest$ep_class_contract$class_order
"cfb_model_manifest"
