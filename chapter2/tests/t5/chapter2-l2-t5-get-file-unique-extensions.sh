#!/bin/bash

folder=$1
array_files=$(find $folder -type f)
array_ext=( )

for file in $array_files; do
	ext="${file##*.}"
	if [[ $file == *.* && ! "${array_ext[0]}" =~ $ext ]]; then
		array_ext+=$ext
		echo $ext
	fi
done
