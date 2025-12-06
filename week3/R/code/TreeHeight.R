# Modified TreeHeight for R practicals
# Date: 2024-06-05

# 1. Load trees.csv 
# 2. Calculate tree height of all trees in the data
# 3. Create a csv outpu that contains the calculated tree heights along with the original data

### Functions ###

TreeHeight <- function(degrees, distance) {
    radians <- degrees * pi / 180
    height <- distance * tan(radians)
    #print(paste("Tree height is:", height))
  
    return (height)
}

### Main ###

MainLoop = function() {
    # read data in data frame
    Data = read.csv("../data/trees.csv", header=TRUE)
    # for each tree, calculate the height and store in new column Height
    Data$Height = 0
    for (i in 1:nrow(Data)) {
        Data$Height[i] = TreeHeight(Data$Angle[i], Data$Distance[i])
    }
    # write new data frame to csv
    write.csv(Data, file="../results/TreeHts.csv", row.names=FALSE)
}

# Call main function
MainLoop()