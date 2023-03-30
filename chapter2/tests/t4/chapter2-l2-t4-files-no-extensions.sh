#!/bin/bash

# Script should get a folder as an argument and return all files
# (including in the nested directories) but without the extension

folder=$1

files=$(find $folder -type f)

for file in $files; do
  echo "${file%%.*}";
done
