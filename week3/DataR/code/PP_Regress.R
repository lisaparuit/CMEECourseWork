# Packages
require(ggplot2)
require(tidyverse)

#setwd to test exectution
#setwd("/home/lisa/Documents/CMEECourseWork/week3/DataR/code")

# Load data
MyDF <- as.data.frame(read.csv("../data/EcolArchives-E089-51-D1.csv"))

# Convert mg to g and adjust mass values
MyDF$Prey.mass[MyDF$Prey.mass.unit == "mg"] <- MyDF$Prey.mass[MyDF$Prey.mass.unit == "mg"] / 1000
MyDF$Prey.mass.unit[MyDF$Prey.mass.unit == "mg"] <- "g"

# subset
MyDFSubset = MyDF %>% select(Predator.mass, Prey.mass, Predator.lifestage, Type.of.feeding.interaction)


# linear model plot
# check combinations of Type.of.feeding.interaction and Predator.lifestage counts
group_counts <- MyDFSubset %>%
  group_by(Type.of.feeding.interaction, Predator.lifestage) %>%
  summarize(n = n(), .groups = 'drop') %>%
  filter(n >= 3)

# remove combinations with less than 10 data points
MyDFSubset <- MyDFSubset %>%
  semi_join(group_counts, by = c("Type.of.feeding.interaction", "Predator.lifestage"))

# plot with ggplot2
p <- ggplot(MyDFSubset, aes(x = log10(Prey.mass), y = log10(Predator.mass), color = Predator.lifestage)) + # overall axis and plot settings
    geom_point(shape = I(3)) + # point settings
    geom_smooth(method = "lm", se = TRUE, fullrange = TRUE) + # regression lines with confidence intervals
    facet_wrap(. ~ Type.of.feeding.interaction, scales = "fixed", ncol = 1, strip.position = "right") + # subgraphs setting
    theme_bw() +
    theme(legend.position = "bottom") +
    # axis labels
    labs(x = "Prey Mass in grams", y = "Predator Mass in grams", color = "Predator Lifestage") +
    scale_x_continuous(labels = scales::scientific) +
    scale_y_continuous(labels = scales::scientific)

# save plot
ggsave("../results/PP_Regress_Results.pdf", plot = p, width = 4, height = 12)
 
### save regression results in csv file

all_results = data.frame()

for (i in unique(MyDFSubset$Type.of.feeding.interaction)) {
  for (j in unique(MyDFSubset$Predator.lifestage)) {
    # create Feeding interaction X Life Stage subset
    subset_data <- MyDFSubset %>%
      filter(Type.of.feeding.interaction == i,
             Predator.lifestage == j) %>%
      filter(!is.na(Prey.mass), !is.na(Predator.mass))

    if (nrow(subset_data) < 2) {
      # if subset data has only one point no regression possible
      results <- data.frame(
        Type.of.feeding.interaction = i,
        Predator.lifestage = j,
        Intercept = NA,
        Slope = NA,
        R_squared = NA,
        F_statistics = NA,
        P_value = NA
      )
    } else {
      lm_model <- lm(log10(Predator.mass) ~ log10(Prey.mass), data = subset_data)
      lm_summary <- summary(lm_model)
      coef_mat <- lm_summary$coefficients
      intercept <- if (nrow(coef_mat) >= 1) coef_mat[1, 1] else NA
      slope     <- if (nrow(coef_mat) >= 2) coef_mat[2, 1] else NA
      pval      <- if (nrow(coef_mat) >= 2) coef_mat[2, 4] else NA
      fstat     <- if (!is.null(lm_summary$fstatistic)) lm_summary$fstatistic[1] else NA
      r2        <- if (!is.null(lm_summary$r.squared)) lm_summary$r.squared else NA

      results <- data.frame(
        Type.of.feeding.interaction = i,
        Predator.lifestage = j,
        Intercept = intercept,
        Slope = slope,
        R_squared = r2,
        F_statistics = fstat,
        P_value = pval
      )
    }
    # bind row to main data frame
    all_results <- dplyr::bind_rows(all_results, results)
  }
}

# save in csv file
write.csv(as.data.frame(all_results), "../results/PP_Regress_Results.csv")
dir("../results/PP_Regress_Results.csv")