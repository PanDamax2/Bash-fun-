#!/usr/bin/bash

# read -p "Podaj n: " n

# for ((i=0; i<=n; i++)); do
#     echo $i
# done


# for ((i=0; i<=n; i=$i+2)); do
#     echo 'Liczba: ' $i
# done

# ------------------------------------------------

# wykonanie ./forLoop.sh 0 10
# for ((i=$1; i<=$2; i++)); do
#     echo 'Liczba: ' $i
# done

# ------------------------------------------------

for ((i=$1; i<=$2; i++)); do
    if [ $((i%2)) -eq 0 ]; then
        echo 'Liczba: ' $i >> even.txt
    else
        echo 'Liczba: ' $i >> odd.txt
    fi
done