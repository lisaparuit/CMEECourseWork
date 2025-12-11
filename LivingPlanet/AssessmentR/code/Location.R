# !/usr/bin/env Rscript

### libraries
library(knitr) #format table dans les sorties
library(ggplot2) # jolis graphiques
library(cowplot) # afin de mettre plusieurs graphiques sur une même page
library(FactoMineR) # ACP
library(factoextra) # extraire et visualiser les résultats de l'ACP
library(corrplot) # représentation graphique des correlations
library(dplyr)
library(xtable)

### load data
TreesData = read.csv("data/trees(1).csv", header = TRUE)
SilwoodWeatherData = read.csv("data/SilwoodWeatherDaily(1).csv", header = TRUE)
PhenologyData = read.csv("data/phenology(1).csv", header = TRUE)
GirthData = read.csv("data/girth(1).csv", header = TRUE)

### Dataset for location investigation
Data = TreesData %>% select(SPlocation, longtitude, latitude)
Data$Significant = ifelse(Data$SPlocation %in% c("Rookery slope", "Pound Hill Field", "Merten's Acres", "Mann's copse",  "Hell hill", "Guness's hill"), 1, 0)

p2 = ggplot(Data, aes(x = longtitude, y = latitude, dots = SPlocation, color = factor(Significant))) +
  geom_point() +
  labs(title = "Tree Locations at Silwood Park", x = "Longitude", y = "Latitude") +
  theme_minimal()

ggsave("results/Tree_Locations.png", plot = p2, width = 8, height = 6)
