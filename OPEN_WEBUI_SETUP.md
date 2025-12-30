# Open WebUI & Docker - Setup & Nutzung

Diese Dokumentation beschreibt das schlanke Setup der KI-Umgebung mittels Docker.

## 1. Voraussetzungen
- **Windows 10/11** mit **WSL 2** (`wsl --install`)
- **Docker Desktop** (Einstellung: *Use the WSL 2 based engine*)

## 2. Schnellstart (Automatisches Deployment)

Der einfachste Weg ist die Nutzung der bereitgestellten Scripte. Diese erstellen alle Ordner, konfigurieren die GPU-Nutzung und starten den gesamten Stack (Ollama, Open WebUI, FalkorDB).

1. **Script ausführen**:
   - **Windows**: Rechtsklick auf `deploy_ai_stack.ps1` -> **Mit PowerShell ausführen**.
   - **WSL / Linux**: `chmod +x deploy_ai_stack.sh && ./deploy_ai_stack.sh`

2. **Browser öffnen**:
   Gehen Sie auf [http://localhost:3000](http://localhost:3000).

3. **Erster Login**:
   Erstellen Sie beim ersten Aufruf einen Administrator-Account (lokal).

## 3. Datenablage (Systemweit)
Um Speicherplatz zu sparen und Daten für alle Benutzer verfügbar zu machen, liegen alle Dateien in `C:\ProgramData`:
- **KI-Modelle**: `C:\ProgramData\Ollama`
- **Dokumente & Datenbank**: `C:\ProgramData\OpenWebUI`
- **Graph-Daten**: `C:\ProgramData\FalkorDB`

## 4. Nutzung in Open WebUI

### Dokumenten-Analyse (RAG)
1. Klicken Sie im Chat auf das **Büroklammer-Icon** (���).
2. Laden Sie Ihr Dokument (PDF, DOCX, etc.) hoch.
3. Stellen Sie Fragen zum Dokument (z.B. *"Fasse die Anforderungen zusammen"*).

### Modelle verwalten
Neue Modelle können direkt über die Weboberfläche oder das Terminal geladen werden:
```bash
docker exec -it ollama ollama pull mistral
```

## 5. Troubleshooting
- **Keine GPU-Beschleunigung?** Prüfen Sie, ob die NVIDIA Container Toolkit Treiber installiert sind.
- **Port belegt?** Ändern Sie die Ports in der `docker-compose.yml`.
- **Container-Status prüfen**: `docker ps`
