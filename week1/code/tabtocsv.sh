#!/bin/sh
# Author: Your name <lisa.paruit25@imperial.ac.uk>
# Script: tabtocsv.sh
# Description: substitute the tabs in the files with comas
#
# Saves the output into a .csv file
# Arguments: 1 -> tab delimited file
# Date: Oct 2019

TXT_FILE=$1 # text file is the first argument of the script
if [ $# -eq 0 ]
then 
    echo "Please provide a tab delimited file"
    exit
    fi 

echo "Creating a coma delimited version of $TXT_FILE ..."
cat $TXT_FILE | tr -s "\t" "," >> $TXT_FILE.csv
echo "The new file is called $TXT_FILE.csv"
echo "DONE!"
exit 