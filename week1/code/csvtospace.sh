#!/bin/bash 
# Arguments: 1 .csv file
# Date: Oct 2023
# Version: ready for submission


if [ $# -eq 0 ] # Check a file has been provided
then 
    echo "I'm affraid no file was provided... "
    exit
elif [[ $1 != *.csv ]] #check the file is .csv
then 
    echo "Please provide a .csv file"
    exit
else
    # Convert commas to space 
    echo "Conversion ongoing..."
    CSV_FILE=$1 # gets the name of the csv file
    TXT_FILE=$(basename $1 .csv).txt # gets the root of the file name and changes .csv to .txt
    #echo $TXT_FILE # for testing purposes
    cat $CSV_FILE | tr -s "," "\t" >> $TXT_FILE
    echo "You're good to go! Check the file $TXT_FILE ;)"
fi
exit  