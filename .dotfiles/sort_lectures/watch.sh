#!/bin/bash
FILES="/home/adam/OBSRecords/*"
IFS=$'\n'

for f in $FILES
do
  if [ -f "$f" ] ;then
    /home/adam/.dotfiles/sort_lectures/main.py $f
  fi
done
