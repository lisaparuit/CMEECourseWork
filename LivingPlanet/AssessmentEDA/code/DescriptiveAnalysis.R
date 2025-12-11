library(tidyverse)
library(ggplot2)
library(readr)
library(dplyr)
library(stats)
library(xtable)

setwd("/home/lisa/Documents/LivingPlanet/AssessmentEDA")
# Load data
acoustic_data <- read.csv("../AssessmentEDA/data/Accoustic_data.csv", header = TRUE)
camera_data <- read.csv("../AssessmentEDA/data/Camera_Trap_Data_Time_interval.csv", header = TRUE)
sensor_data <- read.csv("../AssessmentEDA/data/sensor_sites_2025.csv", header = TRUE)

# Replace Sciurus carolinensis y Sciurus_carolinensis
camera_data$species <- gsub("Sciurus carolinensis", "Sciurus_carolinensis", camera_data$species)
camera_data$species <- gsub("Vulpes vulpes", "Vulpes_vulpes", camera_data$species)
camera_data$species <- gsub("Vuples_vulpes", "Vulpes_vulpes", camera_data$species)
camera_data$species <- gsub("Meles meles", "Meles_meles", camera_data$species)
camera_data$species <- gsub("Columba palumbus", "Columba_palumbus", camera_data$species)
camera_data$species <- gsub("domestic_dog", "Canis_familiaris", camera_data$species)
camera_data$species <- gsub("Homo sapiens", "Homo_sapiens", camera_data$species)




# Create large pivot table with acoustic and camera data
merged_data <- camera_data %>%
  left_join(acoustic_data %>% select(grid, date, time, average_ndsi),by = c("grid", "date", "time"))

# If you also want habitat from sensor_data:
merged_data <- merged_data %>%
  left_join(sensor_data %>% select(Grid, Habitat),
            by = c("grid" = "Grid")) %>%
  rename(habitat = Habitat)

# Species count
species_count <- merged_data %>%
  count(date, time, species, grid, habitat)

# merge with ndsi indice
species_count <- species_count %>%
  merge(merged_data %>% select(grid, date, time, average_ndsi) %>% distinct(), by = c("grid", "date", "time")) %>% filter(!is.na(average_ndsi))

# Bar plot of species abundanceby average_ndsi
p = ggplot(species_count, aes(x = cut(average_ndsi, breaks = 15), y = n, fill = species)) +
    geom_bar(stat = "identity") +
    labs(title = "Species Abundance by Average NDSI",
         x = "Average NDSI",
         y = "Species count") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

# keeping only mamals 
squirrel_count <- species_count %>% filter(species %in% c("Sciurus_carolinensis", "Vulpes_vulpes", "Oryctolagus_cuniculus")) %>% filter("2025-10-09" <= date & date <= "2025-10-25")

# density plot of species abundance by average_ndsi
p2 = ggplot(squirrel_count, aes(x = average_ndsi, fill = species)) +
  geom_density( alpha = 0.6) +
  geom_boxplot(alpha = 0.3, position = position_dodge(width = 0.9)) +
  labs(title = "Species Abundance by Average NDSI",
     x = "Average NDSI",
     y = "Species count") +
  theme_minimal() +
  theme(aspect.ratio = 1) 

ggsave("species_density_ndsi.png", plot = p2, width = 8, height = 6, dpi = 300)

# ANOVA test to see if there are significant differences in habitat average_ndsi between species
anova_mod <- lm(average_ndsi ~ species, data = squirrel_count %>% filter(!is.na(average_ndsi)))

anova_table <- anova(anova_mod)
print(xtable(anova_table), type = "latex", file = "../AssessmentEDA/results/anova_table.tex")

# Tukey HSD post-hoc test
tukey_result <- TukeyHSD(aov(anova_mod))
print(xtable(tukey_result$species), type = "latex", file = "../AssessmentEDA/results/tukey_table.tex")
# Print Tukey HSD results
print(xtable(tukey_result$species), type = "latex", file = "../AssessmentEDA/results/tukey_table.tex")



