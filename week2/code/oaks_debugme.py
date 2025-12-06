#!/usr/bin/env python3

import csv
import sys

#Define function
def is_an_oak(name):
    """ 
    Returns True if name is starts with 'Quercus' with typo mistakes
    """
    var = name.lower()
    return var.startswith('quer')

def main(argv): 
    # open files
    f = open('../data/TestOaksData.csv','r')
    g = open('../results/JustOaksData.csv','w')
    taxa = csv.reader(f)
    csvwrite = csv.writer(g)

    # test the genus for each species in the input file
    for row in taxa:
        print(row)
        print ("The genus is: " + row[0] + '\n')
        # if it's an oak, write it to new file
        if is_an_oak(row[0]):
            print('FOUND AN OAK!\n')
            csvwrite.writerow([row[0], row[1]])    

    return 0
    
if (__name__ == "__main__"):
    status = main(sys.argv)