#!/bin/bash

# The script takes two arguments with filenames.
# If these files exist, it outputs their contents, otherwise it creates them.

# separator -- function prints separator between files
#
# usage: separator
#
separator() {
  echo "--------------"
}

if [ "$#" -ne 2 ]
  then echo "Please enter two arguments"
  exit 1
fi

for FILE in "$@"; do
  if [ -f "$FILE" ]; then
    test -r "$FILE"
    if [[ "$?" -eq 1 ]]; then
      echo "$FILE is not readable"
      separator
    else
      echo "$FILE"
      cat "$FILE"
      separator
    fi
  else
    test -w "$FILE"
    if [[ "$?" -eq 1 ]]; then
      echo "$FILE is not writable"
      separator
    else
      openssl rand -base64 8 > "$FILE"
      chmod 700 "$FILE"
    fi
  fi
done
