#!/usr/bin/env python3

"""First python assignment - making the cfexercises1.py code modular."""

__author__ = 'Lisa Paruit (lisa.paruit25@imperial.ac.uk)'
__version__ = '0.1.1'


## imports ##
import sys 


## constants ## 


## functions ##
def foo_1(x):
    """Calculate the square root of x."""
    if x < 0:
        return "Your input must be non-negative!"
    return x ** 0.5

def foo_2(x, y):
    """Find the larger of two numbers x and y."""
    if x > y:
        return x
    return y

def foo_3(x, y, z):
    """Sort three numbers in ascending order."""
    if x > y:
        x, y = y, x
    if x > z:
        x, z = z, x
    if y > z:
        y, z = z, y
    return [x, y, z]

def foo_4(x):
    """Calculate the factorial of x."""
    if x < 1:
        return "Your input must be a positive integer!"
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result

def foo_5(x):
    """A recursive function that calculates the factorial of x."""
    if x == 1:
        return 1
    elif x < 1:
        return "Your input must be a positive integer!"
    return x * foo_5(x - 1)
     
def foo_6(x): 
    """Calculate the factorial of x in a different way; no if statement involved."""
    if x < 1:
        return "Your input must be a positive integer!"
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto
   
def main(argv):
    numbers = [25, -4, 3]
    print("Let us consider the following series of numbers:", numbers, '\n')
    print("We will first sort them from the smallest to the largest:")
    numbers = foo_3(numbers[0], numbers[1], numbers[2])
    print(numbers, "\n")
    print("Consider the smallest number of this series:", str(numbers[0]), ". This number is negative and will therefore not be usable for the following. \nWhen trying to calculate its square root, the program will return:")
    print(foo_1(numbers[0]), "\n")
    print("For the sake of security, we will consider the largest number of the two remaining numbers of the series, that is : ")
    largest = foo_2(numbers[1], numbers[2])
    print(largest, "\n")
    print("Calculating its square root :", foo_1(largest))
    print("Calculating its factorial in several different ways :")
    print("First way: ", foo_4(largest))
    print("Second way:", foo_5(largest))
    print("Third way: ", foo_6(largest), "\n")
    print("That's it for the testing of the foo functions!")

if (__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)
