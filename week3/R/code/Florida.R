#! /usr/bin/env Rscript
setwd("/home/lisa/Documents/CMEECourseWork/week3/R/code")

rm(list=ls())

### First step : simple visualisation of the data 

# 1. Load the data
load("../data/KeyWestAnnualMeanTemperature.RData", verbose = TRUE)

# 2. Linear regression just for the fun of it
lm1 = lm(ats$Temp ~ ats$Year)


# 3. Save the regression line
png("../results/Florida_temperature_plot.png")
plot(ats$Year, ats$Temp)
abline(lm1, col="red")
dev.off()


### Second step : calculate the autocorrelation

ShuffleNCor = function(x, N) { 
    # x = the time series that we want to study, ie. ats 
    # N = size of the sample chosen for shuffling
    Tsample = sample(x$Temp, N, replace = FALSE)
    Ysample = sample(x$Year, N, replace = FALSE)

    CorTY = cor(Tsample, Ysample)
    return(CorTY)
}

# Calculate correlation of shuffled data a sufficient number of tmes
NullHypList = lapply(1:1000, function(i) ShuffleNCor(ats, N=length(ats$Temp)) )

# Calculate the actual correlation of the data
RealCor = cor(ats$Temp, ats$Year)
print(paste("Real correlation:", as.character(RealCor)))

# Calculate the asymptotic p-value
AboveCor = NullHypList[ NullHypList > RealCor ]

PValue = length(AboveCor)/length(NullHypList)
print(paste("p value:", as.character(PValue)))
