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

## Selecting Oaks ############
data = BudburstData %>% filter(species == "Quercus robur")
## Creating Day of Year variable
data$DOY = data$day + (data$month - 1) * 30


### Trying out the simplest multiple regression model #########3

mod1 = lm(DOY ~ year + Chilling + Forcing + girth_cm , data = data)

tab1 = summary(mod1)
anova1 = car::Anova(mod1, type = 2)
p1 = plot(mod1)


# save plain text summary for inclusion in LaTeX builds
capture.output(tab1, file = "results/mod1_summary.txt")
capture.output(anova1, file = "results/mod1_anova.txt")

# save coefficients as a LaTeX table if xtable is available, otherwise CSV
if (requireNamespace("xtable", quietly = TRUE)) {
  coefs_df <- as.data.frame(coef(tab1))
  print(xtable(coefs_df, digits = 4), file = "results/mod1_coefs.tex")
} else {
  print("xtable package not available; saving coefficients as CSV instead.")
}
if (requireNamespace("xtable", quietly = TRUE)) {
  print(xtable(anova1, digits = 4), file = "results/mod1_anova.tex")
} else {
  print("xtable package not available; saving coefficients as CSV instead.")
}

# save diagnostic plots produced by plot.lm to PNG and PDF for LaTeX inclusion
png(filename = "results/mod1_diagnostics.png", width = 800, height = 800)
par(mfrow = c(2, 2))
plot(mod1)
dev.off()


### trying out he gamma-distributed error model with interraction ##########

mod2 = glm(DOY ~ Chilling * Forcing * girth_cm, data = data, family = "Gamma")


tab2 = summary(mod2)
anova2 = car::Anova(mod2, type = 3)


# save plain text summary for inclusion in LaTeX builds
capture.output(tab2, file = "results/mod2_summary.txt")
capture.output(anova2, file = "results/mod2_anova.txt")

# save coefficients as a LaTeX table if xtable is available, otherwise CSV
if (requireNamespace("xtable", quietly = TRUE)) {
  coefs_df <- as.data.frame(coef(tab2))
  print(xtable(coefs_df, digits = 4), file = "results/mod2_coefs.tex")
} 
if (requireNamespace("xtable", quietly = TRUE)) {
  print(xtable(anova2, digits = 4), file = "results/mod2_anova.tex")
}

# save diagnostic plots produced by plot.lm to PNG and PDF for LaTeX inclusion
png(filename = "results/mod2_diagnostics.png", width = 800, height = 800)
par(mfrow = c(2, 2))
plot(mod2)
dev.off()

## Correlation investigation
png(filename = "results/pairwise_correlations.png", width = 800, height = 800)
pairs(data[, c("DOY", "Chilling", "Forcing", "girth_cm", "TreeID")])
dev.off()

data2 = data 
data2$Chilling = sapply(data2$Chilling, function(x) if (x < median(data2$Chilling)) "Low" else "High")
data2$Chilling = as.factor(data2$Chilling)

med_girth <- median(data2$girth_cm, na.rm = TRUE)

data2$girth <- ifelse(is.na(data2$girth_cm), 
                            NA, 
                            ifelse(data2$girth_cm < med_girth, "Small", "Large"))

# Convert to factor
data2$girth <- factor(data2$girth, levels = c("Small", "Large"))


par(mfrow = c(2,2))
hist(data$Chilling, main = "Histogram of Chilling", xlab = "Chilling")
barplot(table(data2$Chilling), main = "Histogram of Chilling (binned)", xlab = "Chilling")
boxplot(DOY ~ Chilling, data2, main = "Chilling vs DOY", xlab = "Chilling", ylab = "DOY")

p = ggplot(data, aes(x = Forcing, y = DOY, color = Chilling)) +
  geom_point() 

ggsave("results/Forcing_vs_DOY_by_Chilling.png", plot = p, width = 8, height = 6)

p = ggplot(data2, aes(x = Forcing, y = DOY, color = Rain)) +
  geom_point() 

ggsave("results/Forcing_vs_DOY_by_Rain.png", plot = p, width = 8, height = 6)

png(filename = "results/pairwise_correlations2.png", width = 800, height = 800)
pairs(data[, c("DOY", "Chilling", "Forcing", "girth_cm", "Rain")])
dev.off()

### PCAp3

# correclation
correlation=cor(na.omit(data[, c("DOY", "Chilling", "Forcing", "girth_cm", "Rain")]))
h=heatmap(abs(correlation),symm=T)
corrplot(correlation[h$rowInd,h$colInd])

res.pca <- PCA(data[, c("DOY", "Chilling", "Forcing", "girth_cm", "Rain")], scale.unit = TRUE, graph = FALSE, ncp = 11)

p1 =fviz_pca_var(res.pca, axes = 1:2)
p2 =fviz_pca_var(res.pca, axes = 3:4)

p3=fviz_pca_ind(res.pca, axes = 1:2,col.ind="cos2")
p4=fviz_pca_ind(res.pca, axes = 3:4,col.ind="cos2")
