# Runs the stochastic Ricker equation with gaussian fluctuations

rm(list = ls())

stochrick <- function(p0 = runif(1000, .5, 1.5), r = 1.2, K = 1, sigma = 0.2,numyears = 100){

  N <- matrix(NA, numyears, length(p0))  #initialize empty matrix

  N[1, ] <- p0

  for (pop in 1:length(p0)) { #loop through the populations
    for (yr in 2:numyears){ #for each pop, loop through the years
      N[yr, pop] <- N[yr-1, pop] * exp(r * (1 - N[yr - 1, pop] / K) + rnorm(1, 0, sigma)) # add one fluctuation from normal distribution
      }
  }
 return(N)
}

png("../results/Stochastic_Ricker_plot1.png")
plot(stochrick(), type="l")
dev.off()

print("Stochastic Ricker takes:")
print(system.time(res1<-stochrick()))


# Now write another function called stochrickvect that vectorizes the above to
# the extent possible, with improved performance:

# transforming this into a vectorized operation
myfunc = function(Npop , n = n, r = 1.2, K = 1, sigma = 0.2) {
  return(Npop * exp(r * (1 - Npop / K) + rnorm(n, 0, sigma)) )
}

stochrickvect <- function(p0 = runif(1000, .5, 1.5), r = 1.2, K = 1, sigma = 0.2,numyears = 100){
  #initialize empty matrix
  N      = matrix(NA, numyears, length(p0))  
  N[1, ] = p0
  n = length(p0) # get this to avoid having to call length(p0) every time

  for (j in 2:numyears) {
    N[j, ] = myfunc(N[j-1, ], n, r, K, sigma) }
 
  return(N)
}

png("../results/Stochastic_Ricker_plot2.png")
plot(stochrickvect(), type = "l")
dev.off()

print("Vectorized Stochastic Ricker takes:")
print(system.time(res2<-stochrickvect()))
