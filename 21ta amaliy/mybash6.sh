#!/bin/bash
FILE=”/home/svimukthi/Assignment/sanka”
if [ -e “$FILE” ]
 then
    echo “$FILE passwords are enabled”
fi
if [ -x “$FILE” ]
 then
   echo “You have permition to execute $FILE”
 else
   echo “You do Not have permissions to execute $FILE”
Fi
