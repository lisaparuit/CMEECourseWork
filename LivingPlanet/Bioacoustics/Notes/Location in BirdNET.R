
#If you want to predict based on a specific location
# Your site coordinates (same for all files)
lat  <- 51.5     # <- change to your latitude
long <- -0.1     # <- change to your longitude

all_predictions <- lapply(wav_files, function(f) {
  preds <- predict_species_from_audio_file(model, f)
  # Add filename + coordinates as new columns
  preds$file      <- basename(f)
  preds$latitude  <- lat
  preds$longitude <- long
  preds
})
# Combine into one data frame
all_predictions_df <- do.call(rbind, all_predictions)
