library(tuneR) # For reading audio files 
library(soundecology) # For audio analysis functions 
library(seewave) # Another package for audio analysis functions 
library(dplyr) # To manipulation data 
library(ggplot2) # For plotting results 
library(tidyr) # For changing the shape of the datasets 
library(patchwork) # For combining plots
library(reshape2) #to change data from long to wide and visa versa
library(stringr) # For combining plots

# Set the path to your folder containing the audio files for one site
setwd("/home/lisa/Documents/LivingPlanet/Bioacoustics/Assessment") 


extract <- function(path_to_folder) {
    # This creates a list of all the audio files (with .wav extension) in the specified folder 
    file_list <- list.files(path =  path_to_folder, pattern = "\\.wav$", full.names = TRUE) 

    # Remove all files that do not end by 0000.wav, 0500.wav, or 5500.wav
    file_list <- file_list[grepl("(0000|0500|5500)\\.wav$", file_list)]
    n=length(file_list)

    # Create empty lists to store the acoustic indices for each file 
    ndsi_scores <- numeric(length(file_list)) # For NDSI scores 

    # Loop through each file in the folder 
    for (i in seq_along(file_list)) { 
    # Read the current audio files using the readWave function from tuneR package
    file <- readWave(file_list[i]) 
    # Calculate the NDSI 
    ndsi_value <- ndsi(file) 
    ndsi_scores[i] <- ndsi_value 
    ndsi_scores
    print(paste("Processed file", i, "of", n))
    }

    # Converting each list into a vector, so that they can be combined into a single data frame. 
    ndsi_vector <- unlist(ndsi_scores) 

    #extract the date and time from the file name
    date_time <- list.files(path_to_folder, full.names = FALSE)
    date_time <- date_time[grepl("(0000|0500|5500)\\.wav$", date_time)]

    prefix <- str_split(date_time[1], pattern = "_", simplify = TRUE)[1] # get the file prefix
    date_time <- str_replace(date_time, ".wav", "") # Remove the .wav extension
    date_time <- str_replace(date_time, paste0(prefix, "_"), "") # Remove the file prefix

    #convert to a date and time class
    date_time <- as.POSIXct(date_time, format = "%Y%m%d_%H%M%S", tz = "UTC")

    indice_data <- data.frame(NDSI_score = ndsi_vector, date_time = date_time) 

    #extract hour and date into separate columns
    # Extract the date component
    indice_data$date <- as.Date(indice_data$date_time)

    # Extract time component
    indice_data$time <- format(indice_data$date_time, format = "%H:%M")

    return(indice_data)
}

table_results <- extract("../Assessment/data/Data (1)/Data")
#table_results <- table_results[!grepl("20251008", table_results$date_time), ] # Remove data from 8th Oct 2025



indices <- c(1, seq(4, nrow(table_results), by = 3))
n_rows <- length(indices)

# Pre-allocate the dataframe with the correct number of rows
new_table <- data.frame(date_time = as.POSIXct(rep(NA, n_rows), tz = "UTC"), 
                        average_ndsi = numeric(n_rows))

# First row - average of first 2 values
if (table_results$time[1] == "00:00") {
  # average first two rows
  new_table$average_ndsi[1] <- mean(table_results$NDSI_score[1:2])
  new_table$date_time[1] <- table_results$date_time[1]

  # Remaining rows - average of 3 values centered on each index
  row_num <- 2
  for (i in seq(4, nrow(table_results), by = 3)) {
      new_table$date_time[row_num] <- table_results$date_time[i]
      new_table$average_ndsi[row_num] <- mean(table_results$NDSI_score[(i-1):(i+1)])
      row_num <- row_num + 1
}
} else {
  #custom rules
  row_num <- 1
  for (i in seq(1, nrow(table_results), by = 3)) {
      new_table$date_time[row_num] <- table_results$date_time[i]
      new_table$average_ndsi[row_num] <- mean(table_results$NDSI_score[(i-1):(i+1)])
      row_num <- row_num + 1
}
}


# Extract the date component
new_table$date <- as.Date(new_table$date_time)

# Extract time component
new_table$time <- format(new_table$date_time, format = "%H:%M")

write.csv(new_table, "../Assessment/results/2MM06422_2025.csv", row.names = FALSE)
