#!bin/bash

DayOfWeek=' date +%A'

case $DayOfWeek in 
Monday)echo "prep weekly agenda";;
Tuseday) echo "distribute last week's notes";;
Wednesday)echo "chesk on supplies";;
Thursday)echo "meet mith boss";;
Friday) echo "submit weekly report";;
Saturday) echo "hang ouyt with friends";;
Sunday) echo "take a break";;
esac