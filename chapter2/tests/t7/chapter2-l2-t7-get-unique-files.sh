#!/bin/bash

# Script get a folder as an argument and return a list of all unique files
# with extensions but without the absolute path

if [ "${#}" -ne 1 ]; then
  echo "Invalid number of argument. Please enter exactly one argument."
  exit
fi

PATH_FOLDER="${1}"
files=$(find "${PATH_FOLDER}" -type f)
name_files=()

for file in ${files[@]}; do
  name_file="${file##*/}"
  name_files+=("$name_file")
#  if [[ ! "${uniq_files[0]}" =~ ${name_file} ]]; then
#    uniq_files+=${name_file}
#    echo $name_file
#  fi
done

echo "${name_files[@]}" | tr ' ' '\n' | sort -u
