#!/usr/bin/bash

command=htop

if command -v $command
then
    echo "Polecenie $command jest zainstalowane"
else 
    echo "Polecenie $command nie jest zainstalowane"
fi