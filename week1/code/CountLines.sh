#!/bin/bash
#Author: Lisa Paruit
#Version: ready for submission

# error message if no argument is provided
if [ $# != 1 ]
then 
    echo "I'm affraid no file was provided... "
else 
    # count lines in first argument
    Numlines=$(wc -l < $1)
    echo "The file $1 has $Numlines lines"
fi
exit