#!/usr/bin/bash

echo "Podaj login"
read login
echo "Podaj hasło"
read haslo


if [[ "$login" == "admin" && "$haslo" == "admin" ]]; then
    echo "Witaj admin"
    exit 0
else
    echo "Witaj nieznajomy"
    exit 1
fi
