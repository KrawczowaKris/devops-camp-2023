#!/bin/bash

# The script takes two arguments with filenames.
# If these files exist, it outputs their contents, otherwise it creates them.

if [ "$#" -ne 2 ]
  then echo "Please enter two arguments"
  exit 1
fi

for FILE in "$1" "$2"; do
  if [ -f "$FILE" ]; then
    echo "$FILE"
    cat "$FILE"
    echo "--------------"
  else
    exec 2>/dev/null
    openssl rand -base64 8 > "$FILE"
    chmod 700 "$FILE"
  fi
done
