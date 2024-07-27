#!/bin/bash

# Pobierz sciezke do katalogu
SCRIPT_DIR="$(pwd)"

# Ustaw sciezke
LOG_FILE="$SCRIPT_DIR/resource_usage.log"

# Pobieranie danych systemowych
CPU_USAGE=$(wmic cpu get loadpercentage | grep -Eo '[0-9]+')
RAM_TOTAL=$(wmic os get totalvisiblememorysize | grep -Eo '[0-9]+')
RAM_FREE=$(wmic os get freephysicalmemory | grep -Eo '[0-9]+')
RAM_USED=$((RAM_TOTAL - RAM_FREE))
RAM_USAGE_PERCENT=$((100 * RAM_USED / RAM_TOTAL))

# miejsca na dysku
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')

# Pobieranie daty
echo "Data: $(date)" >> "$LOG_FILE"
# Pobieranie statystyk systemowych
echo "Użycie CPU: $CPU_USAGE%" >> "$LOG_FILE"
echo "Użycie RAM: $RAM_USAGE_PERCENT%" >> "$LOG_FILE"
echo "Miejsce na dysku: $DISK_USAGE" >> "$LOG_FILE"
echo "----------------------------------" >> "$LOG_FILE"

echo "Statystyki zasobów zostały zapisane do $LOG_FILE"
