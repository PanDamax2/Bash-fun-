#!/bin/bash

SCRIPT_DIR="$(pwd)"

TODO_FILE="$SCRIPT_DIR/todo.txt"

function addTask() {
    echo "$1" >> "$TODO_FILE"
    echo "Dodano zadanie: $1"
}

function getTasks() {
    echo "Twoje zadania:"
    cat "$TODO_FILE"
}

function remoceTask() {
    sed -i "/$1/d" "$TODO_FILE"
    echo "Usunięto zadanie: $1"
}

function help() {
    echo "Jak uzyć: $0 {add|view|remove} [task]"
    echo "  add    - Dodanie zadania"
    echo "  view   - Pokazuje liste zadan"
    echo "  remove - usuwa zadanie"
}

case $1 in
    "add")
        shift
        addTask "$*"
        ;;
    "view")
        getTasks
        ;;
    "remove")
        shift
        remoceTask "$*"
        ;;
    *)
        help
        ;;
esac
