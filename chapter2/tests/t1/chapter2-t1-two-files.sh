#!/bin/bash

# The script takes two arguments with filenames.
# If these files exist, it outputs their contents, otherwise it creates them.

if [ "$#" -ne 2 ]
  then echo "Please enter two arguments"
  exit 1
fi

for FILE in "$1" "$2"; do
  if [ -f "$FILE" ]; then
    test -r "$FILE"
    if [[ "$?" -eq 1 ]]; then
      echo "$FILE is not readable"
      echo "--------------"
    else
      test -r "$FILE"
      echo "$FILE"
      cat "$FILE"
      echo "--------------"
    fi
  else
    test -w "$FILE"
    if [[ "$?" -eq 1 ]]; then
      echo "$FILE is not writable"
      echo "--------------"
    else
      openssl rand -base64 8 > "$FILE"
      chmod 700 "$FILE"
    fi
  fi
done
