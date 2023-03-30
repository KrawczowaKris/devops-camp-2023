#!/bin/bash

# Script get a folder as an argument and return a list of all unique files
# with extensions but without the absolute path

folder=$1
files=$(find $folder -type f)
uniq_files=( )

for file in $files; do
  name_file="${file##*/}"
  if [[ ! "${uniq_files[0]}" =~ $name_file ]]; then
    uniq_files+=$name_file
    echo $name_file
  fi
done
