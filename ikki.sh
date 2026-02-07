#!/bin/bash

echo -n "Enter grade points: "
read grade

# 100 dan katta bo'lsa xato
if (( grade > 100 )); then
    echo "Grade cannot exceed 100"
    exit 1
fi

# case bilan baholash
case $grade in
    100)          echo "A" ;;
    9[0-9])       echo "A" ;;
    8[0-9])       echo "B" ;;
    7[0-9])       echo "C" ;;
    6[0-9])       echo "D" ;;
    *)            echo "F" ;;
esac