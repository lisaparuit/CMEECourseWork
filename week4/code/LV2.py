#!/usr/bin/python3
# Arguments : 5

## module imports 
import sys
import numpy as np 
from scipy import integrate
import matplotlib.pyplot as plt # I am just used to using pyplot, what's the difference?

## parameters

## first check that the correct number of arguments have been provided
if len(sys.argv) != 6:
    print("Usage: python3 LV2.py r a z e K")
    sys.exit(1)

## then assign the arguments to variables
args = sys.argv[1:6]
r, a, z, e, K = float(args[0]), float(args[1]), float(args[2]), float(args[3]), float(args[4])  
R0, C0 = 10, 5 
RC0 = np.array([R0, C0])

## functions 

def dCR_dt(pops, t=0):
    '''Consumer Ressource Model with ressource density dependance'''
    R = pops[0]
    C = pops[1]
    dRdt = r * R * (1 - R/K) - a * R * C 
    dCdt = -z * C + e * a * R * C    
    return np.array([dRdt, dCdt])
	
def printNsave_timewise(pops,t):
    '''Creates and plots a graph of the consumer and ressources timewise trajectories in a figure that is then saved in results /!\ without displaying it '''
    fig = plt.figure()
    plt.plot(t, pops[:,0], 'g-', label='Resource density') # Plot
    plt.plot(t, pops[:,1]  , 'b-', label='Consumer density')
    plt.grid()
    plt.legend(loc='best')
    plt.xlabel('Time')
    plt.ylabel('Population density')
    plt.title(f'Consumer-Resource population dynamics ; r = {r}, a = {a}, z = {z}, e = {e}, K = {K}')
    fig.savefig('../results/LVRD_model.pdf')

def printNsave_phasewise(pops):
    '''Creates and plots a graph of the consumer and ressources phasewise trajectories in a figure that is then saved in results /!\ without displaying it'''
    fig = plt.figure()
    plt.plot(pops[:,0], pops[:,1], 'r-') # Plot
    plt.grid()
    plt.xlabel('Resource density')
    plt.ylabel('Consumer density')
    plt.title(f'Consumer-Resource phase portrait ; r = {r}, a = {a}, z = {z}, e = {e}, K = {K}')
    fig.savefig('../results/LVRD_model2.pdf')

def main_loop(argv):
    # 1. time scale
    t = np.linspace(0, 15, 1000)
    # 2. solve the system
    pops = integrate.odeint(dCR_dt, RC0, t)
    # 3. print and save 
    printNsave_timewise(pops, t)
    printNsave_phasewise(pops)
    return 0

## Main loop

if (__name__ == "__main__"):
    status = main_loop(sys.argv)
    sys.exit(status)
