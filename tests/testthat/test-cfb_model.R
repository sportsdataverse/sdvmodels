test_that("cfb_model() loads every model with its manifest features", {
  for (name in names(.cfb_model_assets)) {
    model <- cfb_model(name)
    expect_s3_class(model, "xgb.Booster")
    expect_identical(
      xgboost::getinfo(model, "feature_name"),
      cfb_model_manifest$assets[[.cfb_model_assets[[name]]]]$features,
      info = name
    )
  }
})

test_that("cfb_model() rejects unknown names and a broken feature contract", {
  expect_error(cfb_model("nfl_ep_model"), "should be one of")
  local_mocked_bindings(getinfo = function(...) "not_a_feature")
  expect_error(cfb_model("cfb_ep_model"), "feature contract")
})
