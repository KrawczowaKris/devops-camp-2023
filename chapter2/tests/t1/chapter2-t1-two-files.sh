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

folder_access_testing_flag=0

# folder_access_testing -- function checks read access to a file or write access to a folder
#
# usage: folder_access_testing <FILENAME> <TEST_FLAG> <ERROR_TYPE>
#
folder_access_testing() {
  folder_access_testing_flag=0
  local test_flag="$2"

  test "${test_flag}" "${FILE}"
  if [[ "$?" -eq 1 ]]; then
    echo "${FILE} is not $3"
    separator
    folder_access_testing_flag=1
  fi
}

if [ "$#" -ne 2 ]
  then echo "Please enter two arguments"
  exit 1
fi

for FILE in "$@"; do
  if [ -f "${FILE}" ]; then
    folder_access_testing "${FILE}" -r "readable"
    if [[ "${folder_access_testing_flag}" -eq 1 ]]; then
      continue
    fi
    echo "${FILE}"
    cat "${FILE}"
    separator
  else
    if [[ -d "${FILE%/*}" ]]; then
      folder_access_testing "${FILE%/*}" -w "writable"
    else
      openssl rand -base64 8 > "${FILE}"
      chmod 700 "${FILE}"
    fi
  fi
done
