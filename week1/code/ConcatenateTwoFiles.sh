#!/bin/bash

# check that 2 files to merge have been provided 
if [ $# -neq 2 ]
then 
    echo "No arguments provided. Please provide three file names."
fi

# enter new merged file name; default is merged.txt
NEW_FILE='merged.txt'
echo "Provide the name of the merged document"
read NEW_FILE
touch $NEW_FILE

# merge files
cat $1 > $NEW_FILE
cat $2 >> $NEW_FILE
echo "Merged File is" 
cat $NEW_FILES

exit
