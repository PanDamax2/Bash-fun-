#!/usr/bin/bash

echo "Jak masz na imie?"
read imie

# if [ "$imie" == "PanDamax" ]; then
#     echo "Witaj PanDamax"
# elif [ "$imie" == "PanDamax2" ]; then
#     echo "Witaj PanDamax2"
# else
#     echo "Witaj nieznajomy"
# fi


if [[ "$imie" == "PanDamax" || "$imie" == "PanDamax2" ]]; then
    echo "Witaj $imie"
else
    echo "Witaj nieznajomy"
fi

