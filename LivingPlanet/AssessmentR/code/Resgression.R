#!/usr/bin/env Rscript

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
TreesData = read.csv("data/TreesData.csv", header = TRUE)

## Addiding Tree form information from TreesData to BudburstData ########
BudburstData <- merge(BudburstData, GirthData[, c("TreeID", "TreeForm")], by = "TreeID", all.x = TRUE)

## Adding SPlocation information from TreesData to BudburstData ########
BudburstData = merge(BudburstData, TreesData[, c("TreeID", "SPlocation")], by = "TreeID")  

## Cleaning Budburst in Data
Data = BudburstData %>% select( -TreeID, -score, -day, -month)


### Linear model 
mod1 = lm(DOY ~ Chilling + Forcing + Rain + girth_cm + TreeForm + SPlocation , data = Data)
tab1 = summary(mod1)
anova1 = car::Anova(mod1, type = 2)
p1 = plot(mod1)

png(filename = "results/mod1_QQ.png", width = 400, height = 400)
plot(mod1, which = 2)
dev.off()

## Gamma GLM with log link function ##########
mod2 = glm(DOY ~ Chilling + Forcing + Rain + girth_cm + TreeForm + SPlocation, data = Data, family = Gamma(link = "log"))

tab2 = summary(mod2)
print(xtable(tab2, digits = 4), file = "results/mod2_summary.tex")

anova2 = car::Anova(mod2, type = 2)
print(xtable(anova2, digits = 4), file = "results/mod2_anova.tex")

png(filename = "results/mod2_diagnostics.png", width = 600, height = 600)
par(mfrow = c(2,2))
plot(mod2)
dev.off()


