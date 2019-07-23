#!/bin/bash

file=$1
base=$(basename "$file")
if [ -e "files/$base" ] # check if file exists
then
  rm -rf "files/$base" # remove file
  rm -rf "info/$base.trashinfo" # remove second file in info/<file>.trashinfo

  echo 'deleted!'
fi
