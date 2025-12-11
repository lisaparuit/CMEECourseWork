#! usr/bin/env Rscript


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
BudburstData = read.csv("data/BudburstData.csv", header = TRUE)
GirthData = read.csv("data/girth(1).csv", header = TRUE)
WeatherData = read.csv("data/SilwoodWeatherDaily(1).csv", header = TRUE)
TreesData = read.csv("data/trees(1).csv", header = TRUE)

### Looking for correlations ############

# Correlation between Forcing and DOY colored by Chilling
p = ggplot(BudburstData, aes(x = Forcing, y = DOY, color = as.factor(year))) +
  geom_point() + theme_minimal()

ggsave("results/Forcing_vs_DOY_by_Year.png", plot = p, width = 8, height = 6) 

# Hitograms of DOY
p1 = ggplot(BudburstData, aes(x = DOY, color = as.factor(year))) + 
  geom_density() +
  labs(title = "Density of Day of Year (DOY) by Year",
       x = "Day of Year (DOY)",
       y = "Density") +
       facet_wrap(~ year) +
  theme_minimal()

ggsave("results/Density_DOY_by_Year.png", plot = p1, width = 8, height = 6)



