#!/bin/bash

# Script get a folder as an argument and return a list of unique directories
# of all files

folder=$1
files=$(find $folder -type f)
dirs=( )

for file in $files; do
  dir="${file%/*}"
  if [[ ! "${dirs[0]}" =~ $dir ]]; then
    dirs+=$dir
    echo $dir
  fi
done
