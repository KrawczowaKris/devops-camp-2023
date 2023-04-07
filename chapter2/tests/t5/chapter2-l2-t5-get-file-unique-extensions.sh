#!/bin/bash

# Script should get a folder as an argument and return a list of unique extensions of all files
# (including in the nested directories)

if [ "$#" -ne 1 ]; then
  echo "Please enter one argument."
  exit 1
fi

FOLDER="$1"
files=$(find "${FOLDER}" -type f)
extensions=( )

for file in ${files}; do
  filename="${file##*/}"
  # Check if there is a dot in the filename
  if [[ "${filename}" == *.* ]]; then
    # If the first symbol of the string is a dot, check how many dots are in the
    # string. If one, then this file is not suitable
    if [[ "${filename:0:1}" == "." && \
      $(echo "${filename}" | tr -cd '.' | wc -m) -eq 1 ]]; then
      continue
    fi
    extension="${file##*.}"
    extensions+="${extension} "
  fi
done

echo "${extensions[@]}" | sed 's/.$//; s/ /\n/g' | sort | uniq
