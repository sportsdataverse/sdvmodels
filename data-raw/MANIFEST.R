# Rebuild MANIFEST.json for a `cfb_model_artifacts` bundle directory.
#
# The bundle is sportsdataverse-py's `sportsdataverse/cfb/models/` (see
# MANIFEST.json$source_package). Every asset entry is derived from the file
# itself: sha256 and size, plus, for a booster, the feature contract, objective,
# class count and base score read from the booster's own config. Nothing in an
# entry is typed by hand, so a retrained model cannot ship with a stale contract.
#
#   source("data-raw/MANIFEST.R")
#   m <- build_manifest("path/to/bundle", previous = "data-raw/artifacts/MANIFEST.json",
#                       model_version = "2026.10.12", notes = "What changed.")
#   write_manifest(m, "path/to/bundle/MANIFEST.json")

manifest_entry <- function(path, dir) {
  entry <- list(
    sha256 = digest::digest(path, algo = "sha256", file = TRUE),
    bytes = file.size(path)
  )
  if (!endsWith(path, ".ubj")) return(entry)
  b <- xgboost::xgb.load(path)
  cfg <- xgboost::xgb.config(b)  # a list in xgboost 3.x, a JSON string before
  if (is.character(cfg)) cfg <- jsonlite::fromJSON(cfg, simplifyVector = FALSE)
  feats <- xgboost::getinfo(b, "feature_name")
  card <- sub("\\.ubj$", ".card.json", basename(path))
  c(entry, list(
    features = as.list(feats),
    n_features = length(feats),
    num_class = as.integer(cfg$learner$learner_model_param$num_class),
    objective = cfg$learner$objective$name,
    base_score = cfg$learner$learner_model_param$base_score,
    card = if (file.exists(file.path(dir, card))) card else NA
  ))
}

build_manifest <- function(dir, previous, model_version, notes,
                           generated = format(Sys.Date())) {
  prev <- jsonlite::fromJSON(previous, simplifyVector = FALSE)
  files <- sort(list.files(dir, pattern = "\\.(ubj|parquet|card\\.json|gate\\.json)$"))
  assets <- lapply(stats::setNames(files, files),
                   function(f) manifest_entry(file.path(dir, f), dir))
  prev$assets <- assets
  prev$generated <- generated
  prev$model_version <- model_version
  prev$notes <- as.list(notes)
  prev
}

write_manifest <- function(m, path) {
  jsonlite::write_json(m, path, auto_unbox = TRUE, pretty = 2, null = "null",
                       na = "null", digits = NA)
}
