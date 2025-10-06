#!/bin/bash
# Author: Lisa Paruit
# Version: ready for submission

# check that 2 files to merge have been provided 
if [ $# != 2 ]
then 
    echo "No arguments provided. Please provide two file names."
fi

# merged file name will be merged.txt
NEW_FILE='sandbox/merged.txt'

# check the content of the two arguments (for the purpose of code testing)
#echo "First File" | cat $1
#echo "Second File" | cat $2

# merge files
cat $1 > $NEW_FILE
cat $2 >> $NEW_FILE
echo "Merged File is" | cat $NEW_FILE

exit
