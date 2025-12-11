# !/usr/bin/env Rscript

### Libraries 
library(tidyverse)

### load data
TreesData = read.csv("data/trees(1).csv", header = TRUE)
SilwoodWeatherData = read.csv("data/SilwoodWeatherDaily(1).csv", header = TRUE)
PhenologyData = read.csv("data/phenology(1).csv", header = TRUE)
GirthData = read.csv("data/girth(1).csv", header = TRUE)

### Data Wrangling

### Find out bud break date 

# Extract year, month, day from date column
PhenologyData$year = sapply(PhenologyData$date, function(x) as.numeric(strsplit(as.character(x), "/")[[1]][3]))
PhenologyData$month = sapply(PhenologyData$date, function(x) as.numeric(strsplit(as.character(x), "/")[[1]][2]))
PhenologyData$day = sapply(PhenologyData$date, function(x) as.numeric(strsplit(as.character(x), "/")[[1]][1]))

# Remove date and note columns
PhenologyData = PhenologyData %>% select(-date, -note)

# Find budburst data 
MyFilteringFunc = function(phen) {
    # when score is 1, date is straightforward
    budburst = phen %>% filter(score == '1') 
    
    # when score is '<1', compare the next date's score
    less_than_one = phen %>% filter(score == '<1')
    for (i in 1:nrow(less_than_one)) {
        current_row = less_than_one[i, ]
        CRVID = as.numeric(current_row$VisitID)
        next_row = phen %>% filter(VisitID == CRVID + 1)

        # if next row's score is >1, then add the latest date and change score to '1'
        if (next_row$score == '>1') {
            next_row$score = '1'
            budburst = rbind(budburst, next_row)
            }
        # else, just add the current row with +1 day if different than next visit day
        else {
            if (current_row$day != next_row$day) {
            current_row$day = current_row$day + 1
            }
            current_row$score = '1'
            budburst = rbind(budburst, current_row)
            }
        }
        

    # when score is ">1",  compare the previous date's score
    greater_than_one = phen %>% filter(score == '>1')
    for (j in 1:nrow(greater_than_one)) {
        current_row = greater_than_one[j, ]
        CRVID = as.numeric(current_row$VisitID)
        previous_row = phen %>% filter(VisitID == CRVID - 1 & year == current_row$year) # make sure the year is the same

        # if previous row's score is NOT <1 or 1, then add the latest date -1 day if it is not the same as the previous date and change score to '1'
        if (length(previous_row$score) > 0 && !previous_row$score %in% c("<1", "1")) {
            if (current_row$day != previous_row$day) {
                current_row$day = current_row$day - 1
            }
            current_row$score = '1'
            budburst = rbind(budburst, current_row)
        }
    }
    # in other cases, it is too complicated so we do nothing
    
    return(budburst)
    }


BudburstData = PhenologyData %>% MyFilteringFunc()


### Compute environmental drivers: chilling and forcing

# Convert TIMESTAMP to POSIXct
SilwoodWeatherData$TIMESTAMP = as.POSIXct(SilwoodWeatherData$TIMESTAMP, format = "%d/%m/%Y %H:%M", tz = "UTC")

# Chilling calculation function
Chilling_loop <- function(year, tz = "UTC") {
  # build date strings with paste0 to avoid passing extra args to sprintf
  t0 <- as.POSIXct(paste0("01/11/", year - 1, " 00:00"), format="%d/%m/%Y %H:%M", tz=tz)
  tf <- as.POSIXct(paste0("01/03/", year,     " 00:00"), format="%d/%m/%Y %H:%M", tz=tz)

  data <- SilwoodWeatherData %>% filter(TIMESTAMP >= t0 & TIMESTAMP < tf)
  chill_sum <- 0

  for (i in seq_len(nrow(data))) {
    temp <- data$`Air_Temp..Deg.C...Smp.`[i]
    if (is.na(temp)) next
    if (temp <= -3.4) {
      chill_sum <- chill_sum + 0
    } else if (temp <= 3.5) {
      chill_sum <- chill_sum + 0.159 * temp + 0.505
    } else if (temp <= 10.4) {
      chill_sum <- chill_sum + (-0.159 * temp + 1.621)
    } else {
      chill_sum <- chill_sum + 0
    }
  }
  return(chill_sum)
}


# Forcing calculation function
Forcing_loop <- function(year, bb_day, bb_month, tz = "UTC") {
    # build dates
    t0 <- as.POSIXct(paste0("01/02/", year, " 00:00"), format="%d/%m/%Y %H:%M", tz=tz)
    tf <- as.POSIXct(paste0(bb_day, "/", bb_month, "/", year, " 00:00"), format="%d/%m/%Y %H:%M", tz=tz)

    data <- SilwoodWeatherData %>% filter(TIMESTAMP >= t0 & TIMESTAMP < tf)
    forcing_sum <- 0

  for (i in seq_len(nrow(data))) {
    temp <- data$`Air_Temp..Deg.C...Smp.`[i]
    forcing_sum = forcing_sum + max(0, temp - 5)
  }
  return(forcing_sum)
}

# Raining days function (not used currently)

RainDays_loop <- function(year, bb_day, bb_month, tz = "UTC") {
    # build dates
    t0 <- as.POSIXct(paste0("01/05/", year-1, " 00:00"), format="%d/%m/%Y %H:%M", tz=tz)
    tf <- as.POSIXct(paste0(bb_day, "/", bb_month, "/", year, " 00:00"), format="%d/%m/%Y %H:%M", tz=tz)
    data <- SilwoodWeatherData %>% filter(TIMESTAMP >= t0 & TIMESTAMP < tf)
    raining_sum <- 0

  for (i in seq_len(nrow(data))) {
    rain <- data$Rain_mm_Tot...mm...Tot.[i]
    raining_sum = raining_sum + rain
}
  return(raining_sum)
}

# modify BudbusrtData to add chilling and forcing columns

BudburstData$Chilling = mapply(Chilling_loop, BudburstData$year)
BudburstData$Forcing = mapply(Forcing_loop, BudburstData$year, BudburstData$day, BudburstData$month)
BudburstData$Rain = mapply(RainDays_loop, BudburstData$year, BudburstData$day, BudburstData$month)



### Clean Trees species data 

TreesData <- TreesData %>%
  mutate(species = case_when(
      str_detect(species, "quercus.robur") ~ "Quercus robur",
      str_detect(species, "Quercus petraea?") ~ "other Quercus",
      str_detect(species, "no bobur") ~ "other Quercus",
      str_detect(species, "no robur") ~ "other Quercus",
      str_detect(species, "alnus.sp") ~ "Alnus sp.",
      str_detect(species, "castanea.sativa") ~ "Castanea sativa",
      str_detect(species, "acer.pseudoplatanus") ~ "Acer pseudoplatanus",
      TRUE ~ NA_character_
    )
  )

# add species info to BudburstData
BudburstData <- merge(BudburstData, TreesData[, c("TreeID", "species")], by = "TreeID", all.x = TRUE)


### You also want to data below 2009 to be removed as chilling and forcing cannot be computed properly
BudburstData <- BudburstData %>% filter(year > 2009)


### add girth size to the data
GirthData <- GirthData %>%
  group_by(TreeID) %>%
  summarize(girth_cm = mean(girth_cm, na.rm = TRUE))
  
BudburstData <- merge(BudburstData, GirthData[, c("TreeID", "girth_cm")], by = "TreeID", all.x = TRUE)

## Selecting Oaks ############
BudburstData = BudburstData %>% filter(species == "Quercus robur")
BudburstData = BudburstData %>% select(-species)

## Creating Day of Year variable
BudburstData$DOY = BudburstData$day + (BudburstData$month - 1) * 30

### Clean SPlocation name in TreesData
TreesData <- TreesData %>%
  mutate(SPlocation = case_when(
      str_detect(SPlocation, "Observatory ridge") ~ "Observatory Ridge",
      str_detect(SPlocation, "Merten's acres") ~ "Merten's Acres",
      str_detect(SPlocation, "Drive hill") ~ "Drive Hill",
      str_detect(SPlocation, "Cascade marsh") ~ "Cascade Marsh",
      str_detect(SPlocation, "Cheapside field") ~ "Cheapside Field",
      str_detect(SPlocation, "Elm slope") ~ "Elm Slope",
      str_detect(SPlocation, "Farm wood") ~ "Farm Wood",
      str_detect(SPlocation, "Four acres field") ~ "Fours acres field",
      str_detect(SPlocation, "Gunnes's hill") ~ "Gunnes's hill",
      str_detect(SPlocation, "Gunnes's thicket") ~ "Gunnes's thicket",
      str_detect(SPlocation, "Hell hill") ~ "Hell hill",
      str_detect(SPlocation, "Japanese garden") ~ "Japanese Garden",
      str_detect(SPlocation, "Kissing gate") ~ "Kissing Gate",
      str_detect(SPlocation, "Church field") ~ "Church Field",
      str_detect(SPlocation, "Mann's copse") ~ "Mann's Copse",
      str_detect(SPlocation, "Observatory copse") ~ "Observatory Copse",
      str_detect(SPlocation, "Old orchard") ~ "Old Orchard",
      str_detect(SPlocation, "Pinetum") ~ "Pinetum",
      str_detect(SPlocation, "Pond field") ~ "Pond Field",
      str_detect(SPlocation, "Pound hill field") ~ "Pound Hill Field",
      str_detect(SPlocation, "Reactor") ~ "Reactor",
      str_detect(SPlocation, "Rookery slope") ~ "Rookery Slope",
      str_detect(SPlocation, "Squash court") ~ "Squash court",
      str_detect(SPlocation, "The elms") ~ "The Elms",
      str_detect(SPlocation, "Tractor shed") ~ "Tractor shed",
      str_detect(SPlocation, "Weir wood") ~ "Weir wood",
      str_detect(SPlocation, "Workshops") ~ "Workshops",
      TRUE ~ NA_character_
    )
  )

### SAve cleaned Trees data
write.csv(TreesData, "data/TreesData.csv", row.names = FALSE)

### Save cleaned Budburst data
write.csv(BudburstData, "data/BudburstData.csv", row.names = FALSE)
