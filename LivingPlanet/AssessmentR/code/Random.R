### libraries
library(knitr) #format table dans les sorties
library(ggplot2) # jolis graphiques
library(cowplot) # afin de mettre plusieurs graphiques sur une même page
library(FactoMineR) # ACP
library(factoextra) # extraire et visualiser les résultats de l'ACP
library(corrplot) # représentation graphique des correlations
library(dplyr)
library(xtable)
require(lme4)
library(lme4)

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


mod3 = glmer(DOY ~ Chilling + Forcing + Rain + girth_cm + SPlocation + (1|year), data = Data, family = Gamma(link = "log"))

tab3 = summary(mod3)
coef_table <- as.data.frame(coef(tab3))
print(xtable(coef_table, digits = c(4, rep(4, ncol(coef_table)))), file = "results/mod3_summary.tex")

varcor_df <- as.data.frame(VarCorr(mod3))
print(xtable(varcor_df, digits = 4), file = "results/mod3_random.tex")

anova3 = car::Anova(mod3, type = 2)
anova3_df <- as.data.frame(anova3)
anova3_df$Term <- rownames(anova3_df)
anova3_df <- anova3_df[, c(ncol(anova3_df), 1:(ncol(anova3_df)-1))]
print(xtable(anova3_df, digits = 4), file = "results/mod3_anova.tex", include.rownames = FALSE)

png(filename = "results/mod3_diagnostics.png", width = 600, height = 600)
par(mfrow = c(2,2))
plot(mod3)
dev.off()


### Wnalysis of intercept variability 

intercepts <- ranef(mod3)$year
intercepts$year <- as.numeric(rownames(intercepts))

data <- merge(intercepts, Data %>% group_by(year))
colnames(data)[2] <- "int"


mod4 = lm(int ~ Chilling * girth_cm, data = data)

tab4 = summary(mod4)
coef_table <- as.data.frame(coef(tab4))
print(xtable(coef_table, digits = c(4, rep(4, ncol(coef_table)))), file = "results/mod4_summary.tex")

anova4 = car::Anova(mod4, type = 2)
anova4_df <- as.data.frame(anova4)
anova4_df$Term <- rownames(anova4_df)
anova4_df <- anova4_df[, c(ncol(anova4_df), 1:(ncol(anova4_df)-1))]
print(xtable(anova4_df, digits = 4), file = "results/mod4_anova.tex", include.rownames = FALSE)

png(filename = "results/mod4_diagnostics.png", width = 600, height = 600)
plot(mod4, which = 2)
dev.off()

