#!/bin/bash

# Script should get a folder as an argument and return a list of unique extensions of all files 
# (including in the nested directories)

folder=$1
files=$(find $folder -type f)
extensions=( )

for file in $files; do
  extension="${file##*.}"
  if [[ "$file" == *.* && ! "${extensions[0]}" =~ $extension ]]; then
    extensions+=$extension
    echo $extension
  fi
done
