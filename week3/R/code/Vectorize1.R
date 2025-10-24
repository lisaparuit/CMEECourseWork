#1! /usr/bin/env Rscript

M = matrix(runif(1000000), 1000, 1000)

# create a loop that mimics sum()
SumAllElements = function(M) { 
	Dimensions = dim(M) # find the input matrix dimensions
	Tot = 0 # initialize
	# for each row in the matrix then each column, add up corresponding elements
	for (i in 1:Dimensions[1]) { 
		for (j in 1:Dimensions[2]) { Tot = Tot + M[i,j] }
	}
	return (Tot)
}

print("Using loops, the time taken is:")
print(system.time(SumAllElements(M)))

print("Using the in-built vectorized function, the time taken is:")
print(system.time(sum(M)))