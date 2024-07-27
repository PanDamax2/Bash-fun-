#!/usr/bin/bash

# i=10

# while (($i < 100)); do
#     echo $i
#     ((i++))
# done

# ------------------------------------------------
i=0

while read line; do
    echo "----------"
    echo "$i:: $line"
    ((i++))
done < even.txt