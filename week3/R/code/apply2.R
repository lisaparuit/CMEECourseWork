#!/usr/bin/env Rscript

# if the sum of the vector is positive, multiply by 100, else leave it unchanged
SomeOperation = function(v) { 
	if (sum(v) > 0) { return (v*100) }
	else { return(v) } 
	}

# apply this function to each row of a random normally distributed10x10 matrix
M = matrix( rnorm(100), 10, 10)
print( apply(M, 1, SomeOperation))

