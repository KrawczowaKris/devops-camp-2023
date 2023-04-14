#!/bin/bash

# Script get a folder as an argument and return a list of all unique files
# with extensions but without the absolute path

if [ "${#}" -ne 1 ]; then
  echo "Invalid number of argument. Please enter exactly one argument."
  exit
fi

PATH_FOLDER="${1}"

find "${PATH_FOLDER}" -type f | while read filename; do
  echo "${filename##*/}"
done | sort | uniq
