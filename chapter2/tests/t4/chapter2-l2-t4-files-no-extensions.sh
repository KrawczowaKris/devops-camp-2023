#!/bin/bash

# Script should get a folder as an argument and return all files
# (including in the nested directories) but without the extension

PATH_TO_FOLDER="$1"

files=$(find "${PATH_TO_FOLDER}" -type f)

for file in $files; do
  if [[ "${file}" == *"/."* && \
      $(echo "${file##*/}" | tr -cd '.' | wc -m) -eq 1 ]]; then
    echo "${file}"
    continue
  fi
  echo "${file%.*}";
done
