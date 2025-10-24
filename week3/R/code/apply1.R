#!/usr/bin/env Rscript 

## Build a random matrix
M = matrix(rnorm(100), 10, 10)

## Take the mean of each row
RowMeans = apply(M, 1, mean) # Matrix, 1 for row, function mean
print(RowMeans)

## Now the variance
RowVars = apply(M, 1, var) # Matrix, 1 for row, function var
print(RowVars)

## By column
ColMeans = apply(M, 2, mean) # Matrix, 2 for column, function mean
print(ColMeans)

ColVars = apply(M, 2, var) # Matrix, 2 for column, function var
print(ColVars)

