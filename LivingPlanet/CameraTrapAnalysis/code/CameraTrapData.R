library(dplyr)
library(readr)
library(stats)
library(tidyr)
library(stringr) # For combining plots

# List all the csv files in the data directory
files_list <- list.files(path = "../CameraTrapAnalysis/data", pattern = "*.csv", full.names = TRUE)

# Loop to read and merge all csv files into a single data frame
for (i in seq_along(files_list)) {
  # read file
  CamTrap_data <- read.csv(files_list[i])
  # get name of the file and extract the camera serial number and grid name
  file_name <- basename(files_list[i])
  
  # Remove .csv extension and any parenthetical suffixes like (1), (2)
  file_name_clean <- str_replace(file_name, "\\.csv$", "")
  file_name_clean <- str_replace(file_name_clean, "\\([0-9]+\\)$", "")
  
  # Split by underscore
  name_parts <- unlist(strsplit(file_name_clean, "_"))
  
  # Extract camera and grid based on filename structure
  # Assuming format: sp_table_camera_XX_YY_2025 or camera_XX_YY
  if (length(name_parts) == 3) {
    camera <- name_parts[2]  # Second to last part
    grid <- name_parts[3]         # Last part (may include year)
  } else {
    camera <- "unknown"
    grid <- "unknown"
  }
  # check
  print(paste("File:", file_name, "| Camera:", camera, "| Grid:", grid))
  
  # insert in data frame
  CamTrap_data$camera <- as.character(camera)
  CamTrap_data$grid <- as.character(grid)
  
  if (i == 1) {
    combined_data <- CamTrap_data
  } else {
    if (ncol(combined_data) != ncol(CamTrap_data)) {
      print("Column names do not match between files.")
      print(colnames(combined_data))
      print(colnames(CamTrap_data))
      print(paste("File with mismatched columns:", files_list[i]))
      stop("Column mismatch detected. Stopping execution.")

    }
    combined_data <- rbind(combined_data, CamTrap_data)
    
  }
}

# Remove duplicate rows if any
combined_data <- combined_data %>% distinct()
# Remove empty rows if any
combined_data <- combined_data %>% filter(rowSums(is.na(combined_data)) == 0)
# Select only relevant columns
combined_data <- combined_data %>% select(Species, Date, Time, camera, grid)


# write csv
write_csv(combined_data, "../CameraTrapAnalysis/results/Combined_Camera_Trap_Data.csv")
