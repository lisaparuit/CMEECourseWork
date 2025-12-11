#creating a mean of the ACI index across all files, so for the dawn chorus
ACI_mean<- mean(df$ACI_score)

#Linear model for comparing richness across recorders, looking if habitat has an effect 
model<- lm(Species_Richness~ Habitat, data= Group_Data)


install.packages("devtools")
devtools::install_github("AMI-system/EntoInsights")
library(EntoInsights)


# Extract meteriological data
env_hourly_data <- get_hourly_env_data(
  latitudes = c(9.163544, 9.1619212),
  longitudes = c(-79.8378812, -79.8388263),
  start_datetime = as.POSIXct("2024-04-01 00:00:00", tz = "America/Panama"),
  end_datetime = as.POSIXct("2024-08-01 23:59:59", tz = "America/Panama")
)

# Inspect the output
str(env_hourly_data)
