#!/bin/bash
FILES=$@
for FILE in $FILES
 do
   if [ -f “$FILE” ]
     then
        echo “$FILE is a reguler file”
   elif [ -d “$FILE” ]
     then
        echo “$FILE is a directory”
   else
        echo “$FILE is another type of file”
   fi
  ls -l $FILE
 done
