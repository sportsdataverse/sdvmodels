#' Load a college football model as an 'xgboost' booster
#'
#' Reads one of the raw model vectors with [xgboost::xgb.load.raw()] and
#' checks its feature names against the bundle manifest, so a consumer gets
#' an error instead of silently scoring with a model whose feature contract
#' changed.
#'
#' @param name Name of the model object, e.g. `"cfb_ep_model"`. One of
#'   [cfb_ep_model], [cfb_wp_spread_model], [cfb_wp_naive_model],
#'   [cfb_wp_ot_reach_model], [cfb_fg_model], [cfb_fd_model],
#'   [cfb_two_pt_model], [cfb_xpass_model], [cfb_cp_model],
#'   [cfb_cp_air_yards_model] or [cfb_qbr_model].
#' @return An `xgb.Booster`.
#' @export
#' @examples
#' model <- cfb_model("cfb_ep_model")
#' xgboost::getinfo(model, "feature_name")
cfb_model <- function(name) {
  name <- match.arg(name, names(.cfb_model_assets))
  # Lazy data is not on the namespace search path; fetch it explicitly so
  # this works when the package is used via `::` without being attached.
  model <- xgboost::xgb.load.raw(getExportedValue("sdvmodels", name))
  manifest <- getExportedValue("sdvmodels", "cfb_model_manifest")
  expected <- manifest$assets[[.cfb_model_assets[[name]]]]$features
  if (!identical(getinfo(model, "feature_name"), expected)) {
    stop("`", name, "` does not match the feature contract in ",
         "`cfb_model_manifest`.", call. = FALSE)
  }
  model
}

# Model object -> its file in the `cfb_model_artifacts` release.
.cfb_model_assets <- c(
  cfb_ep_model = "ep_model.ubj",
  cfb_wp_spread_model = "wp_spread.ubj",
  cfb_wp_naive_model = "wp_naive.ubj",
  cfb_wp_ot_reach_model = "wp_ot_reach.ubj",
  cfb_fg_model = "fg_model.ubj",
  cfb_fd_model = "fd_model.ubj",
  cfb_two_pt_model = "two_pt_model.ubj",
  cfb_xpass_model = "xpass_model.ubj",
  cfb_cp_model = "cfb_cp_model.ubj",
  cfb_cp_air_yards_model = "cfb_cp_model_air_yards.ubj",
  cfb_qbr_model = "qbr_model.ubj"
)
