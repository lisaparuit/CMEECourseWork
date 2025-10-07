#!/bin/bash
# Arguments: none
# Version: ready for submission

# Original script
echo "Original output:"
find . -type f -exec ls -s {} \; | sort -n | head -10

# First exercise: 
find . -type f -exec ls -lh {} \; | sort -n | head -10 # -h makes sizes human-readable

# Second exercise: 
find . -type f -exec ls -lh {} + | sort -n | head -10 # when using + instead of \; , nothing is substituted when the file is null. Using it therefore makes the pipeline much faster

# Third exercise:
find . -type f | xargs ls -lh | sort -n | head -10
# here we use xarg to use the result of find . -type f as input for the ls -lh command. The -i option ensures all files
#
exit
