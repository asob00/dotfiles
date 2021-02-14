#!/bin/bash
 FILE_PATH="/home/adam/Pulpit/natas"
 LINE_COUNT=`cat $FILE_PATH | wc -l`
 echo -e "natas$LINE_COUNT: $1" >> "$FILE_PATH"
