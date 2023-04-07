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
    # Check if the first symbol is a dot
    if [[ "${filename:0:1}" == "." ]]; then
      # Check if a dot is unique
      if [[ $(echo "${filename}" | tr -cd '.' | wc -m) -eq 1 ]]; then
        continue
      fi
      extension+=$(echo "${filename}" | cut -d. -f 3-)
      continue
    fi
    extension="${filename#*.}"
    extensions+="${extension} "
  fi
done

echo "${extensions[@]}" | sed 's/.$//; s/ /\n/g' | sort | uniq
