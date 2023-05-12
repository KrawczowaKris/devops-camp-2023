#!/bin/bash

# The script takes two arguments with filenames.
# If these files exist, it outputs their contents, otherwise it creates them.

# separator -- function prints separator between files
#
# usage: separator
#
separator() {
  echo -e "--------------"
}

# test_access -- function checks read access to a file or write access to a folder
#
# usage: test_access <FILENAME> <TEST_FLAG> <ERROR_TYPE>
#
test_access() {
  local filename="$1"
  local test_flag="$2"
  local error_type="$3"

  test "${test_flag}" "${filename}"
  if [[ "$?" -eq 1 ]]; then
    echo "${filename} is not ${error_type}"
    separator
    exit 1
  fi
}

if [ "$#" -ne 2 ]
  then echo "Please enter two arguments"
  exit 1
fi

for FILE in "$@"; do
  if [[ -f "${FILE}" ]]; then
    test_access "${FILE}" -r "readable"
    echo "${FILE}"
    cat "${FILE}"
    separator
  else
    if [[ -d "${FILE%/*}" ]]; then
      test_access "${FILE%/*}" -w "writable"
      openssl rand -base64 8 > "${FILE##*/}"
      chmod 700 "${FILE##*/}"
    else
      openssl rand -base64 8 > "${FILE##*/}"
      chmod 700 "${FILE##*/}"
    fi
  fi
done
