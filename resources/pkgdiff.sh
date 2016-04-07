#!/bin/bash

if [ $# -eq 0 ]; then
  echo "a file of packages must be provided"
  exit 1
fi

FILE=$1

if [ -f to_install ]; then
  rm to_install
fi

while read package; do
  pacman -Q --quiet $package >/dev/null 2>&1
  result=$?
  if [ $result -ne 0 ]; then
#    echo "storing $package to install"
    echo $package >> to_install
#  else
#    echo "skipping $package"
  fi
done < $FILE

echo "if the file to_install is to your liking then run the following:"
echo "cat to_install | xargs pacaur -S --noedit --noconfirm && rm to_install"
