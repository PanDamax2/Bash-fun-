#!/bin/bash

# # Lista hostów do sprawdzenia
# HOSTS=("google.com" "onet.pl" "192.168.1.1")

# # Pętla sprawdzająca każdy host
# for HOST in "${HOSTS[@]}"; do
#     if /c/Windows/System32/ping.exe -n 1 "$HOST" &> /dev/null; then
#         echo "$HOST - jest dostępny."
#     else
#         echo "$HOST - nie jest dostępny."
#     fi
# done

# -------------------------------------


if /c/Windows/System32/ping.exe -n 1 "$1" &> /dev/null; then
    echo "$1 - jest dostępny."
else
    echo "$1 - nie jest dostępny."
fi
