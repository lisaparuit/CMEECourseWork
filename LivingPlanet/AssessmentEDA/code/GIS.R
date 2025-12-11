library(terra)       # core raster GIS package
library(sf)          # core vector GIS package
library(rcartocolor) # plotting
library(rpart)
library(tidyr)
library(dplyr)

# Load the data from the CSV file
sensor_locations <- read.csv("../AssessmentEDA/data/form-1__setup.csv")
sensor_locations <- sensor_locations %>% filter(Grid %in% c("45", "60", "68"))

# Convert to an sf object by setting the fields containing X and Y data and set 
# the projection of the dataset
sensor_locations <- st_as_sf(
  sensor_locations, 
  coords=c("long_Sensor_location","lat_Sensor_location"),
  crs="EPSG:4326"
)

silwood_aerial <- rast('../AssessmentEDA/data/silwood_aerial.tiff')

# Load the DTM data from ASC format files
silwood_dtm_SU96NE <- rast("../AssessmentEDA/data/dtm_5m-selected/SU96NE.asc")
silwood_dtm_SU96NW <- rast("../AssessmentEDA/data/dtm_5m-selected/SU96NW.asc")

# Set the projection information for the DTM datasets
crs(silwood_dtm_SU96NE) <- crs(silwood_dtm_SU96NW) <- "EPSG:27700"


# Load the land cover map datasets
silwood_LCM <- rast("../AssessmentEDA/data/Silwood_LCM2024.tiff") 

#L

# Look at the raster details

# Transform sensor locations to match LCM coordinate system
sensor_locations_transformed <- st_transform(sensor_locations, crs = crs(silwood_LCM))

# Extract coordinates from the sf object
coords <- st_coordinates(sensor_locations_transformed)



lcm_info <- read.csv("../AssessmentEDA/data/LCM2024_info.csv")

# Set the band names, the category code labels and the colour tables
coltab(silwood_LCM) <- lcm_info[c("value", "color")]
levels(silwood_LCM) <- lcm_info[c("value", "label")]
names(silwood_LCM) <- c("LandCover", "Certainty")

# Plot LCM map (LandCover layer) with sensor locations overlaid
plot(silwood_LCM["LandCover"])
points(coords[,1], coords[,2], pch = 19, col = "red", cex = 1)
# Add grid numbers as text labels
text(coords[,1], coords[,2], labels = sensor_locations_transformed$Grid, 
     pos = 3, col = "red", font = 2, cex = 0.8)

# save graph in results 
dev.copy(png, '../AssessmentEDA/results/silwood_LCM_with_sensor_locations.png')
dev.off()