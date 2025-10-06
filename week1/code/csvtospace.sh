#!/bin/bash 
# Arguments: 1 .csv file
# Date: Oct 2023

# Check csv file has been provided
if [ $# -eq 0 ]
then 
    echo "Please provide a comma delimited file"
    exit
    fi

# Convert commas to space 
CSV_FILE=$1
cat $CSV_FILE | tr -s "," "\t" >> $CSV_FILE.txt
echo "Done!"
echo 

exit