#!/bin/bash

# Script should get a folder as an argument and return all files
# (including in the nested directories) but without the extension

# file_output -- concatenation of a file and a path to a file and
# output the file
#
# usage: file_output <FILENAME> <HAS_DOT>
#
file_output() {
  local filename="${1}"
  if [[ "${2}" == "y" ]]; then
    local file_without_ext=$(echo "${filename}" | cut -d. -f 2)
    echo "${filefolder}/.${file_without_ext}"
  else
    local file_without_ext=$(echo "${filename}" | cut -d. -f 1)
    echo "${filefolder}/${file_without_ext}"
  fi
}

if [[ "${#}" -ne 1 ]]; then
  echo "Invalid number of arguments. Please enter exactly one argument."
  exit
fi

PATH_TO_FOLDER="${1}"

find "${PATH_TO_FOLDER}" -type f | while read file; do
  filename="${file##*/}"
  filefolder="${file%/*}"

  # Check if the first character of the filename is a dot
  if [[ "${filename:0:1}" == "." ]]; then
    # Compare the number of dots in the file name with one
    if [[ $(echo "${filename}" | tr -cd '\.' | wc -c) -eq 1 ]]; then
      echo "${filefolder}/${filename}"
    else
      file_output "${filename}" "y"
    fi
    continue
  fi

  file_output "${filename}" "n"
done
