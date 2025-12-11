library(dplyr)
library(readr)
library(stats)
library(tidyr)

# Uploading data as df
data = read.csv("../CameraTrapAnalysis/results/Combined_Camera_Trap_Data.csv")
d = data


# restrict Time to time intervals
func = function(row) {
    l = unlist(strsplit(as.character(row["Time"]), ":"))
    hour = as.numeric(l[1])
    minute = as.numeric(l[2]) 
    if (as.numeric(minute) >= 30) {
        row["Time"] = paste0(as.numeric(hour)+1, ":00")
    } else {
        row["Time"] = paste0(as.numeric(hour), ":00")
    }
    return(row)
}

d = as.data.frame(t(apply(d, 1,func)))

# write csv
write_csv(d, "../CameraTrapAnalysis/results/Camera_Trap_Data.csv")
