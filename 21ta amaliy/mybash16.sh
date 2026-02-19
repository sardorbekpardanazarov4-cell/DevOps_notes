#!/bin/bash
DAY=$(date +%F)
cd /home/vimukthi/Pictures
for FILE in *.png
do
   mv $FILE ${DAY}-${FILE}
Done
