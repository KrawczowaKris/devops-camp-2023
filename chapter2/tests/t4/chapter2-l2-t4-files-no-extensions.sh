#!/bin/bash

# Script should get a folder as an argument and return all files
# (including in the nested directories) but without the extension

# file_output -- concatenation of a file and a path to a file and
# output the file
#
# usage: file_output <FILENAME> <DOT_FLAG>
#
file_output() {
  local file_without_ext=$(echo "${1}" | cut -d. -f 2)
  if [[ "${2}" == "y" ]]; then
    echo "${filefolder}/.${file_without_ext}"
  else
    echo "${filefolder}/${file_without_ext}"
  fi
}

PATH_TO_FOLDER="${1}"

files=$(find "${PATH_TO_FOLDER}" -type f)

for file in ${files}; do
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
