#!/bin/bash

# Script for deleting automatically generated html pages

# if [ -d "$(pwd)/../${folder_name}" ]; then
#   rm -rf "$(pwd)/../${folder_name}"
# fi

if [ -d "$(pwd)/../dev" ]; then
  rm -rf "$(pwd)/../dev"
fi
