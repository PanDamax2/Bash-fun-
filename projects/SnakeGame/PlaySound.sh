if command -v ffplay &> /dev/null; then
    echo "Odtwarzanie dźwięku..."
    sleep 6
    ffplay -loglevel error -nodisp -autoexit "./sound.mp3"
else
    echo "ffplay nie jest zainstalowane lub nie jest dostępne w PATH."
fi