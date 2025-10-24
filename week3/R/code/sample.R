#!/usr/bin/env Rscript

### Functions ###

## A funtion to take a sample of siwe n from a population 'popn' and return its mean

myexperiment = function(popn, n) {
    pop_sample = sample(popn, size = n, replace = FALSE)
    return(mean(pop_sample))    
}

## Calculates means of num samples drawn form popn  and stores it in a vector using a FOR loop without preallocation
loopy_sample1 = function(popn, n, num) { 
    result1 = vector() # intitialize an empty ector
    for (i in 1:num) { result1 = c(result1, myexperiment(popn, n)) }
    return(result1)
}

## To run num iterations of the experiement using a FOR loop on a vector with preallocation
loopy_sample2 = function(popn, n, num) {
    result2 = vector(,num) # preallocate a vector of length num
    for(i in 1:num) { result2[i] = myexperiment(popn, n)}
    return(result2)
}

## To run num iterations of the experiment using a FOR loop on a list with preallocation
loopy_sample3 = function(popn, n, num) {
    result3 = vector("list", num) # preallocate a list of length num
    for(i in 1:num) { result3[[i]] = myexperiment(popn, n)}
    return(result3)
}

## TO run num iterations of the experiment using vectorization with lapply
lapply_sample = function(popn, n, num) {
    result4 = lapply(1:num, function(i) myexperiment(popn, n)) # for i in 1:num, run myexperiment(popn, n) and store it in ROW i
    return(result4)
}

## To run num iterations of the experiment using vectorization with sapply
sapply_sample = function(popn, n, num) {
    result5 = sapply(1:num, function(i) myexperiment(popn, n)) # for i in 1:num, run myexperiment(popn, n) and store it in COLUMN i
    return(result5)
}

### Run the functions ###

set.seed(12345)
popn <- rnorm(10000) # Generate the population
n <- 100 # sample size for each experiment
num <- 10000 # Number of times to rerun the experiment

print("Using loops without preallocation on a vector took:" )
print(system.time(loopy_sample1(popn, n, num)))

print("Using loops with preallocation on a vector took:" )
print(system.time(loopy_sample2(popn, n, num)))

print("Using loops with preallocation on a list took:" )
print(system.time(loopy_sample3(popn, n, num)))

print("Using the vectorized sapply function (on a list) took:" )
print(system.time(sapply_sample(popn, n, num)))

print("Using the vectorized lapply function (on a list) took:" )
print(system.time(lapply_sample(popn, n, num)))