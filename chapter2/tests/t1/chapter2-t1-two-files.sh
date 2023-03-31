#!/bin/bash

# The script takes two arguments with filenames.
# If these files exist, it outputs their contents, otherwise it creates them.

if [ "$#" -ne 2 ]
  then echo "Please enter two arguments"
  exit 1
fi

FILE_1="$1"
FILE_2="$2"

for FILE in "$FILE_1" "$FILE_2"; do
  if [ -f "$FILE" ]; then
    cat "$FILE"
    echo "--------------"
  else
    openssl rand -base64 8 > "$FILE";
    chmod 700 "$FILE"
  fi
done
