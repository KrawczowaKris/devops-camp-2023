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

for file in $files; do
  extension="${file##*.}"
  if [[ "${file}" == *.* ]]; then
    if [[ "${file}" == *"/."* && \
      $(echo "${file##*/}" | tr -cd '.' | wc -m) -eq 1 ]]; then
      continue
    else
      extensions+="${extension} "
    fi
  fi
done

echo "${extensions[@]}" | sed 's/.$//; s/ /\n/g' | sort | uniq
