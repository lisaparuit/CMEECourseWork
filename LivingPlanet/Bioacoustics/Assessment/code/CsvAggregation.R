# Load necessary libraries 
library(dplyr) # To manipulation data 
library(tidyr) # For changing the shape of the datasets 
library(reshape2) #to change data from long to wide and visa versa
library(stringr) # For combining plots

# Set the path to your folder containing the audio files for one site
setwd("/home/lisa/Documents/LivingPlanet/Bioacoustics/Assessment") 

# Extract csv files
file_list <- list.files(path =  "../Assessment/results", pattern = "\\.csv$", full.names = TRUE) 

# sensor site file
sensor_file <- read.csv('/home/lisa/Téléchargements/sensor_sites_2025.csv')

for (i in seq_along(file_list)) {
    # Read each csv file
    data <- read.csv(file_list[i])
    
    # Extract sensor site ID from the file name
    file_name <- basename(file_list[i])
    sensor_id <- str_split(file_name, pattern = "_", simplify = TRUE)[1]
    print(sensor_id)

    # Filter sensor site information
    sensor_info <- sensor_file %>% filter(Recorder_SerialNumbe == sensor_id)

    
    # Add sensor site information to the data
    data$sensor_id <- sensor_id
    data$grid <- sensor_info$Grid
    
    # Merge data
    if (i == 1){
        combined_data <- data
        } else {
        combined_data <- rbind(combined_data, data)
    }
    }

write.csv(combined_data, "../Assessment/results/Accoustic_data.csv", row.names = FALSE)