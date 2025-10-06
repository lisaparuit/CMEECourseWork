#!/bin/sh
# Author: Your name <lisa.paruit25@imperial.ac.uk>
# Script: tabtocsv.sh
# Description: substitute the tabs in the files with comas
#
# Saves the output into a .csv file
# Arguments: 1 -> tab delimited file
# Date: Oct 2019

TXT_FILE=$1 # text file is the first argument of the script

if [ $# != 1 ] #check there is an argument
then 
    echo "I'm affraid no file was provided... "
    exit
elif [[ $1 != *.txt ]] #check the file is .txt
then 
    echo "Please provide a .txt file"
    exit
else
    CSV_FILE=$(basename $TXT_FILE .txt).csv #change the .txt suffix to .csv
    echo "Creating a coma delimited version of $TXT_FILE ..."
    cat $TXT_FILE | tr -s "\t" "," >> $CSV_FILE
    echo "Done!"
fi

exit 