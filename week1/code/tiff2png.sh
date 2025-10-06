#!bin/bash
# Version: ready for submission

f=$1 # .tif image is the first argument of the script

if [ $# != 1 ] #check there is an argument
then 
    echo "I'm affraid no image was provided... "
    exit
elif [[ $f != *.tif ]] #check the file is .tif
then 
    echo "Please provide a .tif file"
    exit
else
  for f in *.tif; 
  do 
    echo  "Converting $f";
    convert "$f" "$(basename "$f" .tif).png";
  done
  echo "All done!"
fi

exit
