#!/bin/bash
# PLan projketu
# nie mam totajnie pomysu jak to zrobić
# 1. stworzyć obramowanie
# 2. stworzyc weza
# 3.napisac sterowanie
# 5. dodac smier
# 4. dodac jakblko

# Kolory
border_color="\e[30;43m"
snake_color="\e[32;42m"
food_color="\e[34;44m"
text_color="\e[31;43m"
no_color="\e[0m"

width=$(($(tput cols)-2))
height=$(($(tput lines)-9))

# Tablica planszy
declare -A board

# Inicjalizacja planszy
initGame() {
    clear
    echo -ne "\e[?25l" 
    stty -echo
    for ((i=0; i<height; i++)); do
        for ((j=0; j<width; j++)); do
            board[$i,$j]=' '
        done
    done
}

# Rysowanie planszy
drawBoard() {
    clear
    # Rysowanie górnej krawędzi planszy
    echo -ne "$border_color+"
    for ((i=0; i<width; i++)); do
        echo -ne "-"
    done
    echo -ne "$border_color+"
    echo -ne "$no_color\n"

    # Rysowanie ścian i zawartości planszy
    for ((i=0; i<height; i++)); do
        echo -ne "$border_color|"
        for ((j=0; j<width; j++)); do
            echo -ne "${board[$i,$j]}"
            echo -ne "$no_color"
        done
        echo -ne "$border_color|\n"
    done

    # Rysowanie dolnej krawędzi planszy
    echo -ne "$border_color+"
    for ((i=0; i<width; i++)); do
        echo -ne "-"
    done
    echo -ne "$border_color+"
    echo -ne "$no_color\n"
}

# Inicjalizacja weza
initSnake() {
    snake_length=10
    direction="RIGHT"
    snake_r=(2 2 2)
    snake_c=(5 4 3)
    for ((i=0; i<snake_length; i++)); do
        board[${snake_r[$i]},${snake_c[$i]}]="${snake_color}o$no_color"
    done
}


moveSnake() {
    local head_r=${snake_r[0]}
    local head_c=${snake_c[0]}
    
    case $direction in
        UP)    head_r=$((head_r - 1)) ;;
        DOWN)  head_r=$((head_r + 1)) ;;
        LEFT)  head_c=$((head_c - 1)) ;;
        RIGHT) head_c=$((head_c + 1)) ;;
    esac

    # Sprawdzanie kolizji z krawędzią
    if ((head_r < 0 || head_r >= height || head_c < 0 || head_c >= width)); then
        echo -e "${text_color}Koniec gry: Uderzyles w krawędzi planszy!$no_color"
        exit 1
    fi

    # Sprawdzanie kolizji z samym sobą
    for ((i = 0; i < snake_length; i++)); do
        if [[ ${snake_r[$i]} -eq $head_r && ${snake_c[$i]} -eq $head_c ]]; then
            echo -e "${text_color}Koniec gry: Udezyles w samego siebie!$no_color"
            exit 1
        fi
    done

    # Przesuwanie węża
    for ((i=snake_length-1; i>0; i--)); do
        snake_r[$i]=${snake_r[$((i-1))]}
        snake_c[$i]=${snake_c[$((i-1))]}
    done
    snake_r[0]=$head_r
    snake_c[0]=$head_c

    # Rysowanie węża na planszy
    initGame
    for ((i=0; i<snake_length; i++)); do
        board[${snake_r[$i]},${snake_c[$i]}]="${snake_color}o$no_color"
    done
}

readDirection() {
    local key
    stty -icanon time 0 min 0  # Ustawienie trybu niekanonicznego
    key=$(dd bs=1 count=1 2>/dev/null)
    stty icanon       # Przywracanie trybu kanonicznego
    case $key in
        w) direction="UP" ;;
        s) direction="DOWN" ;;
        a) direction="LEFT" ;;
        d) direction="RIGHT" ;;
    esac
}

# Funkcja aktualizująca wyświetlanie planszy
updateDisplay() {
    tput cup 1 0  # Przesuwamy kursor do początku planszy (1,0)
    drawBoard
}


# Pętla gry
gameLoop() {
    initGame
    initSnake
    updateDisplay

    while true; do
        readDirection
        moveSnake
        updateDisplay
        sleep 0.3
    done
}

# Ustawienia terminala
stty -echo -icanon  # Ustawienia trybu niekanonicznego i wyłączenie echa
clear
trap "stty echo icanon; tput sgr0; exit" SIGINT SIGTERM

gameLoop

# Przywraca ustawienia terminala
stty echo
echo -ne "\e[?25h"
# echo -ne "$no_color\n"  #ustawianie ściany  