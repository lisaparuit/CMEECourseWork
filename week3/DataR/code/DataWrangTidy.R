#### Wrangling the Pound Hill Dataset using tidyverse ####

require(tidyverse)

####1. Load the dataset 
# header = false because the raw data don't have real headers
MyData = as_tibble(read_csv ("../DataR/data/PoundHillData.csv", col_names = FALSE))

# header = true because we do have metadata headers
MyMetaData = as_tibble(read_csv ("../DataR/data/PoundHillMetaData.csv", col_names = TRUE))


############# Transpose ###############
# To get those species into columns and treatments into rows 
MyData <- as_tibble(t(MyData))

############# Rearange data frame ###############

TempData = MyData
TempData[TempData == ""] = 0  #replace species absences with zeros
colnames(TempData) = TempData[1,] # assign column names 
TempData = TempData[-1, ] #remove the first row 
fix(TempData)

############# Convert from wide to long format  ###############

MyWrangledData <- TempData %>%
  pivot_longer(cols = -c(Cultivation, Block, Plot, Quadrat), names_to = "Species", values_to = "Count")

fix(MyWrangledData)

