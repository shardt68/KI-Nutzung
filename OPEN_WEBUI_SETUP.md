# Open WebUI & Docker - Setup & Nutzung

Diese Dokumentation beschreibt das schlanke Setup der KI-Umgebung mittels Docker.

## 1. Voraussetzungen
- **Windows 10/11** mit **WSL 2** (`wsl --install`)
- **Docker Desktop** (Einstellung: *Use the WSL 2 based engine*)

## 2. Schnellstart (Automatisches Deployment)

Der einfachste Weg ist die Nutzung der bereitgestellten Scripte. Diese erstellen alle Ordner, konfigurieren die GPU-Nutzung und starten den gesamten Stack (Ollama, Open WebUI, FalkorDB).

1. **Script ausführen**:
   - **Windows**: Rechtsklick auf `deploy_ai_stack.ps1` -> **Mit PowerShell ausführen**. 
     *Hinweis: Falls eine Fehlermeldung zur Skriptausführung erscheint, öffnen Sie eine PowerShell als Admin und geben Sie `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser` ein.*
   - **WSL / Linux**: `chmod +x deploy_ai_stack.sh && ./deploy_ai_stack.sh`
   
   *Tipp: Unter Windows 11 kann "Sudo für Windows" in den Einstellungen aktiviert werden, um administrative Befehle direkt in der Bash/PowerShell zu autorisieren.*

2. **Browser öffnen**:
   Gehen Sie auf [http://localhost:3000](http://localhost:3000).
   *Hinweis: Für den Zugriff von anderen Rechnern im Netzwerk nutzen Sie die IP-Adresse des Hosts (z.B. http://192.168.1.50:3000).*

3. **Erster Login**:
   Erstellen Sie beim ersten Aufruf einen Administrator-Account (lokal).

4. **Modell auswählen**:
   Klicken Sie oben links auf **"Modell auswählen"** und wählen Sie ein lokales Modell (z.B. `mistral:latest`) aus. Lokale Modelle werden automatisch von Ollama erkannt. Die `.env` Datei wird nur für *externe* APIs (wie OpenAI) benötigt.

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

**Empfohlene Modelle:**
- **Llama 3 (8B)**: `docker exec -it ollama ollama pull llama3` (Allrounder)
- **Phi-3 (Mini)**: `docker exec -it ollama ollama pull phi3` (Sehr schnell, gut für CPU)
- **DeepSeek-Coder**: `docker exec -it ollama ollama pull deepseek-coder` (Für Programmierung)

## 5. 🔗 Externe KI-Server (OpenAI, Claude, etc.)
Sie können externe APIs einbinden, um neben lokalen Modellen auch GPT-4 oder Claude zu nutzen:
1. Erstellen Sie eine Datei namens `.env` im Hauptverzeichnis (nutzen Sie `env_template.txt` als Vorlage).
2. Tragen Sie dort Ihre API-Keys ein.
3. Starten Sie den Stack neu: `docker-compose up -d --force-recreate`.
4. Die Keys sind sicher und werden durch die `.gitignore` nicht auf GitHub veröffentlicht.

### Empfohlene Modelle für Web-Recherche
Für Aufgaben, die eine Internetrecherche erfordern, eignen sich besonders:
- **GPT-4o (Omni)**: Aktueller Standard für schnelle und präzise Recherchen.
- **GPT-4-Turbo**: Sehr gut für komplexe Analysen großer Datenmengen.
- **Claude 3.5 Sonnet**: Exzellent für logische Zusammenfassungen.

### Websuche in Open WebUI aktivieren
Das Modell allein surft nicht im Netz. Um die Websuche zu nutzen:
1. Gehen Sie in Open WebUI auf **Settings** -> **Web Search**.
2. Aktivieren Sie die Suche und wählen Sie eine Engine:
   - **Google PSE**: 100 Anfragen/Tag kostenlos. Benötigt *API Key* und *Search Engine ID (CX)* aus der Google Cloud Console.
   - **Tavily**: Speziell für KI optimiert. 1.000 Anfragen/Monat kostenlos. Registrierung auf [tavily.com](https://tavily.com/).
3. Sobald konfiguriert, kann Open WebUI Informationen aus dem Internet abrufen und dem Modell als Kontext bereitstellen.

## 6. Troubleshooting
- **Performance zu langsam? (GPU aktivieren)**: Standardmäßig läuft der Stack im CPU-Modus. Um Ihre NVIDIA-GPU zu nutzen:
  1. Öffnen Sie die `docker-compose.yml`.
  2. Entfernen Sie die Kommentarzeichen (`#`) vor dem `deploy:` Block unter dem `ollama` Service.
  3. Stellen Sie sicher, dass das **NVIDIA Container Toolkit** installiert ist.
  4. Starten Sie den Stack neu: `docker-compose up -d`.
- **"OCI runtime create failed"**: Dies tritt auf, wenn die GPU in der `docker-compose.yml` aktiviert ist, aber die Treiber oder das Toolkit fehlen. Kommentieren Sie den `deploy` Block wieder aus, um im CPU-Modus zu arbeiten.
- **"No such container: ollama"**: Der Container konnte nicht gestartet werden. Prüfen Sie mit `docker logs ollama`, ob ein Fehler vorliegt.
- **Port belegt?** Ändern Sie die Ports in der `docker-compose.yml`.
- **Container-Status prüfen**: `docker ps`
