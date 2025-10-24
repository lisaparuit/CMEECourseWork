#!/usr/bin/env Rscript

# without pre allocation
NoPreallocFun <- function(x) {
    a <- vector() # empty vector
    for (i in 1:x) {
        a <- c(a, i) # concatenate
    }
}

system.time(NoPreallocFun(1000))

# with pre allocation 
PreallocFun <- function(x) {
    a <- rep(NA, x) # pre-allocated vector
    for (i in 1:x) {
        a[i] <- i # assign
    }
}

system.time(PreallocFun(1000))
