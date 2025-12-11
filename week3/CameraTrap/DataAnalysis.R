#! bin/usr/env Rscript
# DataAnalysis.R

# Load necessary libraries
library(ggplot2)
library(tidyverse)

# Loading CSV data
data = read.csv("CameraTrap/CameraTrapData2025.csv")
dataCP = as_tibble(data)

# Convert Time..hh.mm. to a int for better plotting
p = str_split(dataCP$Time..hh.mm., ":")
i = 1
for (row in p) {
    dataCP$Time.int[i] = as.integer(row[1])
    i = i + 1
}

# Plotting the distribution of animal activity by time of day
MyWrangledData  = dataCP[c('Species', 'Time.int', 'X..individuals')]

p = ggplot(MyWrangledData, aes(x = Time.int)) +  geom_histogram()  +
    labs(title = "Distribution of Animal Activity by Time of Day",
             x = "Time of Day (HH)",
             y = "Count") +
    facet_wrap( .~ Species, scales = 'free_y') +
    theme_bw() 

# Save the plot
ggsave("CameraTrap/results/AnimalActivity1.png", plot = p, width = 10, height = 6)

# Filtering out species that appear less than 5 times during the day
MyFilteredData = MyWrangledData %>% group_by(Species) %>% filter(n() >= 5)

p2 = ggplot(MyFilteredData, aes(x = Time.int)) +  geom_density()  +
    labs(title = "Distribution of Animal Activity by Time of Day (Filtered)",
             x = "Time of Day (HH)",
             y = "Count") +
    facet_wrap( .~ Species, scales = 'free_y') +
    theme_bw()

# Save the filtered plot
ggsave("CameraTrap/results/AnimalActivity2.png", plot = p2, width = 10, height = 6)

# Plot density overlap
browser()
MyFilteredData[MyFilteredData$X..individuals == NA] = 0
fix(MyFilteredData)
CountMax = aggregate(MyFilteredData$X..individuals, list(MyFilteredData$Species), FUN=max) # list of max counts
fix(CountMax)
MyFilteredData2 = filter(MyFilteredData, X..individuals == CountMax$x) # fetches times when max count is reached out

fix(MyFilteredData2)

p2 = ggplot(MyFilteredData2, aes(x = Time.int, fill = Species)) +  geom_density(alpha = 0.5)  +
    labs(title = "Distribution of Animal Activity by Time of Day (Filtered)",
             x = "Time of Day (HH)",
             y = "Count") +
    theme_bw()

# Save the filtered plot
ggsave("CameraTrap/results/AnimalActivity3.png", plot = p2, width = 10, height = 6)


