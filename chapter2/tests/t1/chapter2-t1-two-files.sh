#!/bin/bash

file_1=$1
file_2=$2

for FILE in $file_1, $file_2; do
	if [ -f $FILE ]
		then cat $FILE
	else
		openssl rand -base64 8 > $FILE;
		chmod 700 $FILE
	fi
done
