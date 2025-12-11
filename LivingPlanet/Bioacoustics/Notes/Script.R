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
setwd("/home/lisa/Documents/LivingPlanet/Bioacoustics") 

extract <- function(path_to_folder) {
    # This creates a list of all the audio files (with .wav extension) in the specified folder 
    file_list <- list.files(path =  path_to_folder, pattern = "\\.wav$", full.names = TRUE) 

    # Create empty lists to store the acoustic indices for each file 
    # These lists will hold the results of the analysis for each file in the folder 
    aci_scores <- numeric(length(file_list)) # For ACI scores 
    ndsi_scores <- numeric(length(file_list)) # For NDSI scores 
    bi_scores <- numeric(length(file_list)) # For BI scores 

    # Loop through each file in the folder 
    for (i in seq_along(file_list)) { 
    # Read the current audio files using the readWave function from tuneR package
    file <- readWave(file_list[i]) 
    
    # Calculate the Acoustic Complexity Index (ACI) 
    # calculates the ACI score for a the list of files and stores the result in a variable named aci_value
    aci_value <- acoustic_complexity(file, min_freq = 1000, max_freq = 11000)
    #store each calculated aci_value into a list called aci_scores
    aci_scores[i] <- aci_value 
    aci_scores
    
    # Calculate the NDSI 
    ndsi_value <- ndsi(file) 
    ndsi_scores[i] <- ndsi_value 
    ndsi_scores
    
    # Calculate the Bioacoustic index (Bi) 
    bi_value <- bioacoustic_index(file, min_freq = 1000, max_freq = 11000) 
    bi_scores[i] <- bi_value  
    bi_scores
    }

    # Converting each list into a vector, so that they can be combined into a single data frame. 
    aci_vector <- unlist(aci_scores) 
    ndsi_vector <- unlist(ndsi_scores) 
    bi_vector <- unlist(bi_scores) 

    #extract the date and time from the file name
    date_time <- list.files(path_to_folder, full.names = FALSE)

    prefix <- str_split(date_time[1], pattern = "_", simplify = TRUE)[1] # get the file prefix
    date_time <- str_replace(date_time, ".wav", "") # Remove the .wav extension
    date_time <- str_replace(date_time, paste0(prefix, "_"), "") # Remove the file prefix

    #convert to a date and time class
    date_time <- as.POSIXct(date_time, format = "%Y%m%d_%H%M%S", tz = "UTC")
    print(date_time)

    indice_data <- data.frame(ACI_score = aci_vector, 
                          NDSI_score = ndsi_vector, BI_score = bi_vector, date_time = date_time) 

    #extract hour and date into separate columns
    # Extract the date component
    indice_data$date <- as.Date(indice_data$date_time)

    # Extract time component
    indice_data$time <- format(indice_data$date_time, format = "%H:%M")

    return(indice_data)
}

plot_indices <- function(indice_data) {
    #Plot ACI
    ACI<-ggplot(indice_data, aes(x=time)) + 
    geom_line(aes(y = ACI_score , group = 1), color = "red")+ #tells ggplot to treat all x axis values as 1
    scale_x_discrete(breaks=c("06:00","06:30","07:00", "07:30", "08:00", "08:30","09:00"))+
    labs(y = "ACI")+
    labs(x = "Time")+
    theme_new()

    #Plot NDSI 
    NDSI<-ggplot(indice_data, aes(x=time)) + 
    geom_line(aes(y = NDSI_score , group = 1), color = "green")+ #tells ggplot to treat all x axis values as 1
    scale_x_discrete(breaks=c("06:00","06:30","07:00", "07:30", "08:00", "08:30","09:00"))+
    labs(y = "NDSI")+
    labs(x = "Time")+
    theme_new()

    #Plot BI
    BI<-ggplot(indice_data, aes(x=time)) + 
    geom_line(aes(y = BI_score , group = 1), color = "blue")+ #tells ggplot to treat all x axis values as 1
    scale_x_discrete(breaks=c("06:00","06:30","07:00", "07:30", "08:00", "08:30","09:00"))+
    labs(y = "BI")+
    labs(x = "Time")+
    theme_new()

    # Combine the three plots vertically 
    combined_plot <- ACI / BI / NDSI 
    return(combined_plot)
}


### MAIN LOOP 

#Custom theme- you can add your own if you prefer
theme_new <- function(base_size = 17, base_family = "Helvetica"){
  theme_classic(base_size = base_size, base_family = base_family) %+replace%
    theme(
      #line = element_line(colour="black"),
      #text = element_text(colour="black"),
      axis.text.x=element_text(colour = "black", size=17),
      axis.text.y=element_text(colour = "black", size=17),
      axis.title=element_text(size=21,face="bold"),
      legend.position = 'top', legend.direction = "horizontal",
      #strip.text = element_text(size=21),
      axis.line = element_line(colour = "black", size = 1, linetype = "solid"),
      legend.key=element_rect(colour=NA, fill =NA),
      panel.grid = element_blank(),   
      #panel.border = element_rect(fill = NA, colour = "black", size=0),
      #panel.background = element_rect(fill = "white", colour = "black"), 
      #strip.background = element_rect(fill = NA)
    )
}


for (path in c("ecoacoustic_2MM05938_NHM3_2025",
               "ecoacoustic_2MM06338_63_2025",
               "ecoacoustic_2MM06374_60_2025",
               "ecoacoustic_2MM06423_45_2025",
               "ecoacoustic_2MM07108_18_2025",
               "ecoacoustic_2MM07112_NHM2_2025",
               "ecoacoustic_2MM07156_16_2025" )){
  print(path)
  indice_data <- extract(path)
  write.csv(indice_data, paste0(path, "/Acoustic_Indices.csv"))
}

# Set the plot width and height (width, height in inches)
options(repr.plot.width = 10, repr.plot.height = 7)
# Display the combined plot 
combined_plot <- plot_indices(indice_data)
print(combined_plot)