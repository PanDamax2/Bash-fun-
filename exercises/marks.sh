#!/usr/bin/bash

read -p "Podaj ocene z matematyki: " matematyka

read -p "Podaj ocene z fizyki: " fizyka

read -p "Podaj ocene z histori: " historia

read -p "Podaj ocene z jezyka polskiego: " polski

if [[ ("$matematyka" -ge 5 || "$fizyka" -ge 5) && ("$historia" -ge 5 || "$polski" -ge 5) ]]; then
    echo "Mozesz zagrac na kompie"
    exit 0
else
    echo "Nie mozesz zagrac na kompie"
    exit 1
fi