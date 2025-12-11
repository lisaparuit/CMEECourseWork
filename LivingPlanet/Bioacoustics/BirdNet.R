#Load the package
library(birdnetR)
library(dplyr) 
library(stringr) 
library(lubridate)
library(ggplot2) 
library(tidyr)
library(vegan)
library(knitr) 
library(readr)

# Initialise a BirdNET model
model <- birdnet_model_tflite("v2.4")


# Set path to the folder with WAV files
folder_path <- "../Data-selected"

BirdID <- function(folder_path) {
  # List all WAV files
  wav_files <- list.files(folder_path, pattern = "\\.wav$", full.names = TRUE)
  
  # Loop through each WAV file and run predictions
  all_predictions <- lapply(wav_files, function(f) {
    preds <- predict_species_from_audio_file(model, f)
    # Add filename as a new column
    preds$file <- basename(f)
    return(preds)
  })
  
  # Combine into one dataframe
  all_predictions_df <- do.call(rbind, all_predictions)

  return(all_predictions_df)
}

fisrt_prdictions <- BirdID(folder_path)
write.csv(fisrt_prdictions, "/home/lisa/Documents/LivingPlanet/Bioacoustics/Data-selected/BirdNET_Silwood.csv")


setwd("C:/Imperial acoustics course/BirdNET") 

# Import your data set (csv file)
Monkswood <- read.csv("BirdNET_Monkswood.csv") 
Parsonage <- read.csv("BirdNET_Parsonage.csv") 

# Add a new column to each data frame indicating the site so we have an identifier when we combine them 
Monkswood$Site <- "Monkswood" 
Parsonage$Site <- "Parsonage"

# Lets subset the data to remove the na's and to only look at calls with a confidence above 0.7
# for the first site
Monkswood_na <- Monkswood %>% drop_na()
Monkswood_subset <- subset(Monkswood_na, Monkswood_na$confidence>0.7) 

# for the second site
Parsonage_na <- Parsonage %>% drop_na()
Parsonage_subset <- subset(Parsonage_na, Parsonage_na$confidence>0.7) 


#bind both dfs together by rows to combine
Bird_combined <- rbind(Monkswood_subset, Parsonage_subset)

#Extract the time from the file name in r by 
Bird_combined$Time<-sub('.*_', '', Bird_combined$file)#removing everything before the _
Bird_combined$Time<-gsub("\\..*","", Bird_combined$Time)#everything after the .
Bird_combined$Time<-gsub('.{2}$', '', Bird_combined$Time)#then we remove the seconds

#Calculate number of calls per species per site
Species_names<-Bird_combined %>%
  group_by(Site) %>%
  count(common_name, sort=TRUE)

#Now lets plot and compare species
ggplot(Species_names, aes(fill=Site, y=n, x=reorder(common_name, n))) + 
  geom_bar(position="stack", stat="identity")+
  coord_flip() +# Changes the axes
  labs(y = "Frequency")+
  labs(x = "Species")
