# Build data/*.rda from the `cfb_model_artifacts` release of
# sportsdataverse/sportsdataverse-data. The models are trained and published by
# the sportsdataverse-py model pipeline (see MANIFEST.json$source_package); this
# package only re-packages the published artifacts, byte for byte.
#
# Re-run from the package root after a new bundle is published:
#
#   gh release download cfb_model_artifacts \
#     --repo sportsdataverse/sportsdataverse-data --dir data-raw/artifacts --clobber
#   source("data-raw/MODELS.R")
#
# The xgboost models are stored as the raw UBJ bytes of the release file (not
# re-serialised by the local xgboost), so sdvmodels::cfb_*_model is identical to
# the artifact sportsdataverse-py scores with. Read one back with
# xgboost::xgb.load.raw(). fastrmodels (nflverse) uses the same raw-vector
# approach because it survives xgboost's serialisation changes.

dir <- "data-raw/artifacts"
stopifnot(dir.exists(dir))

read_raw <- function(asset) {
  f <- file.path(dir, asset)
  readBin(f, "raw", file.size(f))
}

cfb_ep_model <- read_raw("ep_model.ubj")
cfb_wp_spread_model <- read_raw("wp_spread.ubj")
cfb_wp_naive_model <- read_raw("wp_naive.ubj")
cfb_fg_model <- read_raw("fg_model.ubj")
cfb_fd_model <- read_raw("fd_model.ubj")
cfb_two_pt_model <- read_raw("two_pt_model.ubj")
cfb_xpass_model <- read_raw("xpass_model.ubj")
cfb_cp_model <- read_raw("cfb_cp_model.ubj")
cfb_qbr_model <- read_raw("qbr_model.ubj")

# plain data frames: arrow's tibbles carry metadata attributes that reference
# the arrow namespace, and R-devel's "namespace references in data files"
# check warns on them
read_table <- function(asset) {
  x <- as.data.frame(arrow::read_parquet(file.path(dir, asset)))
  x[] <- lapply(x, function(col) { attributes(col) <- NULL; col })
  attributes(x) <- attributes(x)[c("names", "row.names", "class")]
  x
}
cfb_punt_distribution <- read_table("punt_distribution.parquet")
cfb_field_position_ep <- read_table("cfb_field_position_ep.parquet")

card_names <- c(
  "ep_model", "wp_spread", "wp_naive", "fg_model", "fd_model",
  "two_pt_model", "xpass_model", "cfb_cp_model", "qbr_model"
)
cfb_model_cards <- lapply(
  stats::setNames(card_names, card_names),
  function(n) jsonlite::fromJSON(file.path(dir, paste0(n, ".card.json")), simplifyVector = TRUE)
)

cfb_model_manifest <- jsonlite::fromJSON(file.path(dir, "MANIFEST.json"), simplifyVector = TRUE)

usethis::use_data(
  cfb_ep_model,
  cfb_wp_spread_model,
  cfb_wp_naive_model,
  cfb_fg_model,
  cfb_fd_model,
  cfb_two_pt_model,
  cfb_xpass_model,
  cfb_cp_model,
  cfb_qbr_model,
  cfb_punt_distribution,
  cfb_field_position_ep,
  cfb_model_cards,
  cfb_model_manifest,
  overwrite = TRUE,
  compress = "xz"
)
