# Each raw model must be the byte-identical artifact of the release it came
# from (length from the manifest), and must still parse with the installed
# xgboost. The print snapshots guard against breaking xgboost changes, as in
# fastrmodels.

raw_models <- list(
  cfb_ep_model = "ep_model.ubj",
  cfb_wp_spread_model = "wp_spread.ubj",
  cfb_wp_naive_model = "wp_naive.ubj",
  cfb_fg_model = "fg_model.ubj",
  cfb_fd_model = "fd_model.ubj",
  cfb_two_pt_model = "two_pt_model.ubj",
  cfb_xpass_model = "xpass_model.ubj",
  cfb_cp_model = "cfb_cp_model.ubj",
  cfb_qbr_model = "qbr_model.ubj"
)

test_that("raw models match the release manifest and parse with xgboost", {
  for (name in names(raw_models)) {
    model <- get(name, envir = asNamespace("sdvmodels"))
    asset <- cfb_model_manifest$assets[[raw_models[[name]]]]
    expect_type(model, "raw")
    expect_length(model, asset$bytes)

    parsed <- xgboost::xgb.load.raw(model)
    expect_s3_class(parsed, "xgb.Booster")
    expect_identical(xgboost::getinfo(parsed, "feature_name"), asset$features)
  }
})

test_that("tables and metadata are structured as expected", {
  expect_s3_class(cfb_punt_distribution, "data.frame")
  expect_gt(nrow(cfb_punt_distribution), 0)
  expect_s3_class(cfb_field_position_ep, "data.frame")
  expect_gt(nrow(cfb_field_position_ep), 0)
  expect_type(cfb_model_cards, "list")
  expect_setequal(
    names(cfb_model_cards),
    c("ep_model", "wp_spread", "wp_naive", "fg_model", "fd_model",
      "two_pt_model", "xpass_model", "cfb_cp_model", "qbr_model")
  )
  expect_type(cfb_model_manifest, "list")
  expect_length(cfb_model_manifest$ep_class_contract$class_order, 7)
  expect_length(cfb_model_manifest$ep_class_contract$point_values, 7)
})

test_that("xgboost print methods are stable", {
  expect_snapshot(print(xgboost::xgb.load.raw(cfb_ep_model)), cran = TRUE)
  expect_snapshot(print(xgboost::xgb.load.raw(cfb_wp_spread_model)), cran = TRUE)
  expect_snapshot(print(xgboost::xgb.load.raw(cfb_fd_model)), cran = TRUE)
})
