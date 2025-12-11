#Load the package
library(birdnetR)

# Initialise a BirdNET model
model <- birdnet_model_tflite("v2.4")

## First run Monkswood
# Set path to the folder with WAV files
folder_path <- "../Data-selected"

# List all WAV files
wav_files <- list.files(folder_path, pattern = "\\.wav$", full.names = TRUE)

# Loop through each WAV file and run predictions
Silwood_all_predictions <- lapply(wav_files, function(f) {
  preds <- predict_species_from_audio_file(model, f)
  # Add filename as a new column
  preds$file <- basename(f)
  return(preds)
})

# Combine into one dataframe
Silwood_all_predictions_df <- do.call(rbind, Silwood_all_predictions)

write.csv(Silwood_all_predictions_df, "/home/lisa/Documents/LivingPlanet/Bioacoustics/Data-selected/BirdNET_Silwood.csv")

