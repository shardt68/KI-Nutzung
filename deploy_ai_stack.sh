#!/bin/bash

# AI Stack Deployment Script (Ollama + Open WebUI) for Bash/WSL2
# Ausführen mit: chmod +x deploy_ai_stack.sh && ./deploy_ai_stack.sh

echo -e "\e[36m--- Starte AI Stack Deployment ---\e[0m"

# 1. Prüfe ob Docker läuft
if ! docker info > /dev/null 2>&1; then
    echo -e "\e[31mFehler: Docker läuft nicht oder ist nicht im Pfad erreichbar.\e[0m"
    exit 1
fi

# 2. Erstelle zentrale Ordner (Windows Pfade via WSL Mount)
PATHS=("/mnt/c/ProgramData/Ollama" "/mnt/c/ProgramData/OpenWebUI" "/mnt/c/ProgramData/FalkorDB")
for PATH_DIR in "${PATHS[@]}"; do
    if [ ! -d "$PATH_DIR" ]; then
        echo "Erstelle Ordner: $PATH_DIR"
        sudo mkdir -p "$PATH_DIR"
        sudo chmod 777 "$PATH_DIR"
    fi
done

# 3. Starte Docker Compose
echo -e "\e[32mStarte Container via Docker Compose...\e[0m"
docker-compose up -d

# 4. Warte bis Ollama bereit ist
echo -e "\e[33mWarte auf Ollama Container...\e[0m"
until [ "$(docker inspect -f '{{.State.Running}}' ollama 2>/dev/null)" == "true" ]; do
    sleep 2
done

# 5. Initiales Modell laden (Mistral)
echo -e "\e[33mLade Standard-Modell (Mistral)... Dies kann einige Minuten dauern.\e[0m"
docker exec -it ollama ollama run mistral

echo -e "\e[36m--- Deployment Abgeschlossen ---\e[0m"
echo -e "\e[32mOpen WebUI ist erreichbar unter: http://localhost:3000\e[0m"
