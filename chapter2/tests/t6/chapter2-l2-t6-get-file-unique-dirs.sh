#!/bin/bash

# Script get a folder as an argument and return a list of unique directories
# of all files

if [ "${#}" -ne 1 ]; then
  echo "Invalid number of argument. Please enter exactly one argument."
  exit
fi

PATH_FOLDER="${1}"

find "${PATH_FOLDER}" -type f | while read file; do
  echo "${file%/*}"
done | sort | uniq
