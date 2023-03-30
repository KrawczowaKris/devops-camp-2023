#!/bin/bash

folder=$1

array_files=$(find $folder -type f)

for file in $array_files; do
	echo ${file%%.*};
done
