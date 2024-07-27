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
height=$(($(tput lines)-5))

# Tablica planszy
declare -A board

initGame() {
    clear
    echo -ne "\e[?25l"
    stty -echo
    for ((i=0; i<height; i++)); do
        for ((j=0; j<width; j++)); do
            board[$i,$j]=' '
        done
    done
    drawBoard
}

drawBoard() {
    # Rysowanie górnej krawędzi planszy
    tput cup 0 0
    echo -ne "$border_color+"
    for ((i=0; i<width; i++)); do
        echo -ne "-"
    done
    echo -ne "+$no_color"

    # Rysowanie ścian i zawartości planszy
    for ((i=1; i<=height; i++)); do
        tput cup $i 0
        echo -ne "$border_color|$no_color"
        tput cup $i $((width+1))
        echo -ne "$border_color|$no_color"
    done

    # Rysowanie dolnej krawędzi planszy
    tput cup $((height+1)) 0
    echo -ne "$border_color+"
    for ((i=0; i<width; i++)); do
        echo -ne "-"
    done
    echo -ne "+$no_color"
}

initSnake() {
    snake_length=9
    direction="RIGHT"
    snake_r=(2 2 2)
    snake_c=(5 4 3)
    for ((i=0; i<snake_length; i++)); do
        board[${snake_r[$i]},${snake_c[$i]}]='o'
    done
    drawSnake
}

drawSnake() {
    for ((i=0; i<snake_length; i++)); do
        tput cup $((snake_r[i]+1)) $((snake_c[i]+1))
        echo -ne "${snake_color}o$no_color"
    done
}

clearTail() {
    local tail_r=${snake_r[$((snake_length-1))]}
    local tail_c=${snake_c[$((snake_length-1))]}
    tput cup $((tail_r+1)) $((tail_c+1))
    echo -ne " "
}

initFood() {
    local food_r food_c
    while true; do
        food_r=$((RANDOM % height))
        food_c=$((RANDOM % width))
        # Sprawdź, czy pole jest puste
        if [[ ${board[$food_r,$food_c]} == ' ' ]]; then
            board[$food_r,$food_c]='*'
            tput cup $((food_r+1)) $((food_c+1))
            echo -ne "${food_color}*${no_color}"
            break
        fi
    done
}

growSnake() {
    local new_tail_r=${snake_r[$((snake_length-1))]}
    local new_tail_c=${snake_c[$((snake_length-1))]}
    snake_r+=("$new_tail_r")
    snake_c+=("$new_tail_c")
    ((snake_length=snake_length+3))
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
        if [[ -x "./RickRoll.sh" ]]; then
            echo -ne "\e[40m"
            echo -ne "\e[39m"
            ./PlaySound.sh &
            ./RickRoll.sh
        else
            echo "Brak skryptu RickRoll.sh lub brak uprawnień do jego uruchomienia."
        fi
        
        exit 1
    fi

    # Sprawdzanie kolizji z samym sobą
    for ((i = 0; i < snake_length; i++)); do
        if [[ ${snake_r[$i]} -eq $head_r && ${snake_c[$i]} -eq $head_c ]]; then
            echo -e "${text_color}Koniec gry: Udezyles w samego siebie!$no_color"
            if [[ -x "./RickRoll.sh" ]]; then
                echo -ne "\e[40m"
                echo -ne "\e[39m"
                ./PlaySound.sh &
                ./RickRoll.sh
            else
                echo "Brak skryptu RickRoll.sh lub brak uprawnień do jego uruchomienia."
            fi
            exit 1
        fi
    done

    # Sprawdzanie kolizji z jedzeniem
    if [[ ${board[$head_r,$head_c]} == '*' ]]; then
        growSnake
        initFood
    else
        clearTail
    fi

    # Przesuwanie węża
    for ((i=snake_length-1; i>0; i--)); do
        snake_r[$i]=${snake_r[$((i-1))]}
        snake_c[$i]=${snake_c[$((i-1))]}
    done
    snake_r[0]=$head_r
    snake_c[0]=$head_c

    drawSnake
}

readDirection() {
    local key
    stty -icanon time 0 min 0 
    key=$(dd bs=1 count=1 2>/dev/null)
    stty icanon      
    case $key in
        w) direction="UP" ;;
        s) direction="DOWN" ;;
        a) direction="LEFT" ;;
        d) direction="RIGHT" ;;
    esac
}


gameLoop() {
    initGame
    initSnake
    initFood

    while true; do
        readDirection
        moveSnake
        sleep 0.2
    done
}

# Ustawienia terminala
stty -echo -icanon
clear
trap "stty echo icanon; tput sgr0; exit" SIGINT SIGTERM

gameLoop

# Przywraca ustawienia terminala
stty echo
echo -ne "\e[?25h"