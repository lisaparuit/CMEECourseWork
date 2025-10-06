#!/bin/bash

Numlines= wc -l < $1 
echo "The file $1 has $Numlines lines"
echo
exit