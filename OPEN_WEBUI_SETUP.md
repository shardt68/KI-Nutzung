# Open WebUI Umgebung - Schritt-für-Schritt Aufsetzen (Windows)

## 📋 Voraussetzungen

### System-Anforderungen
- **Windows 10/11** (64-bit)
- **Minimum RAM**: 8 GB (empfohlen: 16 GB für größere Modelle)
- **Disk Space**: 20-50 GB (abhängig von Modellgröße)
- **Internet**: Für initiale Downloads nötig

### 💡 System-weite Installation (Multi-User)
Um zu verhindern, dass Tools nur im Benutzerverzeichnis (`AppData/Local`) installiert werden, folgen Sie diesen Hinweisen:
- **Docker**: Bei der Installation "Install for all users" wählen.
- **Ollama**: Standardmäßig installiert Ollama in den User-Pfad. Wir biegen den Speicherort der Modelle auf einen globalen Pfad (z.B. `C:\ProgramData\Ollama`) um.
- **WSL**: Die Funktion ist systemweit, die Linux-Distributionen sind jedoch benutzerbezogen.

### Zu installierende Software
- **WSL 2 (Windows Subsystem for Linux)** - *Zwingend empfohlen für Performance & GPU*
- Docker Desktop (für Windows) - **ODER** - Native Installation
- Git (optional, für Updates)
- Browser (Chrome, Firefox, Edge)

---

## 🚀 Option A: Installation mit Docker Desktop (EMPFOHLEN)

### Warum Docker? Die Vorteile:
- **Keine Abhängigkeits-Konflikte**: Python, Node.js, etc. sind gekapselt
- **Einfache Verwaltung**: Einziger Befehl zum Starten/Stoppen
- **Reproduzierbar**: Auf jedem PC identisch (ideal für Team-Rollout)
- **Clean**: `docker rm` und alles ist weg - keine verwaisten Dateien
- **Updatebar**: Neue Version? `docker pull` - Das wars
- **Isolation**: Beeinträchtigt andere Projekte/Installationen nicht

> **Tl;dr**: Nach 3 Monaten funktioniert die Native-Installation oft nicht mehr. Docker funktioniert immer.

### Schritt 0: WSL 2 aktivieren (Wichtig für Performance & GPU)

Bevor Docker installiert wird, sollte WSL 2 (Windows Subsystem for Linux) eingerichtet sein. Dies ermöglicht Docker den Zugriff auf die Grafikkarte (GPU) und sorgt für maximale Geschwindigkeit.

1. **PowerShell als Administrator öffnen**
2. **Befehl ausführen**:
   ```powershell
   wsl --install
   ```
   *Falls WSL bereits installiert ist, stellen Sie sicher, dass es aktuell ist:*
   ```powershell
   wsl --update
   ```
3. **Neustart des PCs** (zwingend erforderlich).
4. **Status prüfen**:
   ```powershell
   wsl --status
   ```
   Stellen Sie sicher, dass "Standardversion: 2" angezeigt wird.

### Schritt 1: Docker Desktop installieren

1. **Download**
   - Gehen Sie zu: https://www.docker.com/products/docker-desktop
   - Klicken Sie auf "Download for Windows"

2. **Installation durchführen**
   ```
   docker-desktop-installer.exe
   ```
   - Mit Admin-Rechten installieren
   - **Wichtig**: Option "Install required Windows components for WSL 2" aktivieren
   - **Wichtig**: Falls abgefragt, "Install for all users" wählen
   - Neustart durchführen

3. **Verifizierung**
   ```bash
   docker --version
   docker run hello-world
   ```
   Wenn "Hello from Docker!" erscheint → ✅ Docker läuft

---

### Schritt 2: Ollama bereitstellen (KI-Engine)

Sie haben zwei Möglichkeiten, Ollama zu betreiben. **Variante B** ist für Multi-User-Systeme am saubersten.

#### Variante A: Windows Native (Einfacher Einstieg)
1. **Download**: https://ollama.ai/download/windows
2. **System-weite Konfiguration (WICHTIG)**:
   - Erstellen Sie den Ordner: `C:\ProgramData\Ollama`
   - **PowerShell (Admin)**: `[Environment]::SetEnvironmentVariable("OLLAMA_MODELS", "C:\ProgramData\Ollama", "Machine")`
   - Starten Sie Ollama neu.
3. **Installation**: `OllamaSetup.exe` ausführen.

#### Variante B: Ollama im Docker (Empfohlen für Multi-User & Server)
Hierbei muss **kein** Benutzer Ollama installieren. Es läuft als isolierter Dienst im Hintergrund.

1. **Ollama Container starten** (PowerShell Admin):
   ```bash
   docker run -d `
     --gpus all `
     -v ollama:/root/.ollama `
     -v C:\ProgramData\Ollama:/root/.ollama/models `
     -p 11434:11434 `
     --name ollama `
     ollama/ollama
   ```
   *(Hinweis: `-v C:\ProgramData\Ollama:/root/.ollama/models` sorgt dafür, dass die Modelle auch hier zentral liegen).*

2. **Modell laden** (einmalig):
   ```bash
   docker exec -it ollama ollama run mistral
   ```

---

### Schritt 3: Open WebUI mit Docker starten

1. **PowerShell oder CMD öffnen** (als Administrator)

2. **Open WebUI Container starten**
   
   **Wenn Ollama als Windows-App läuft (Variante A):**
   ```bash
   docker run -d `
     -p 3000:8080 `
     --add-host=host.docker.internal:host-gateway `
     -v open-webui:/app/backend/data `
     --name open-webui `
     ghcr.io/open-webui/open-webui:latest
   ```

   **Wenn Ollama im Docker läuft (Variante B):**
   ```bash
   docker run -d `
     -p 3000:8080 `
     --network bridge `
     -e OLLAMA_BASE_URL=http://host.docker.internal:11434 `
     -v open-webui:/app/backend/data `
     --name open-webui `
     ghcr.io/open-webui/open-webui:latest
   ```

   *Hinweis: Bei Variante B kommunizieren beide Container über das Host-Gateway.*

3. **Verifizierung**
   ```bash
   docker ps
   ```
   → `open-webui` (und ggf. `ollama`) sollten laufen.

---

### Schritt 4: Erste Nutzung

1. **Browser öffnen**
   ```
   http://localhost:3000
   ```

2. **Registrierung (Admin-Account)**
   - Email: `admin@example.com` (beliebig)
   - Passwort: Stark wählen
   - Klick auf "Sign Up"

3. **Ollama-Modelle verbinden**
   - Oben links auf **Settings** (⚙️)
   - Gehe zu **Admin Panel** → **Settings**
   - Bei "Ollama API" eintragen: `http://host.docker.internal:11434`
   - **Save**

4. **Modell auswählen**
   - Hauptseite: Dropdown oben (Standard-Modell)
   - Dort sollte jetzt `mistral` oder `llama2` auftauchen
   - Auswählen und fertig!

---

## ⚡ Option C: Automatisches Deployment (Pro-Methode)

Dies ist der schnellste Weg. Ein Script erledigt alles: Erstellt Ordner, konfiguriert Docker und startet beide Dienste (Ollama + Open WebUI).

1. **Dateien vorbereiten**:
   Stellen Sie sicher, dass die Dateien [docker-compose.yml](docker-compose.yml) und [deploy_ai_stack.ps1](deploy_ai_stack.ps1) im selben Ordner liegen.

2. **Script ausführen**:
   - **Windows**: Rechtsklick auf `deploy_ai_stack.ps1` -> **Mit PowerShell ausführen**.
   - **WSL / Linux**: `chmod +x deploy_ai_stack.sh && ./deploy_ai_stack.sh`

3. **Was passiert?**
   - Die Ordner `C:\ProgramData\Ollama` (Modelle), `C:\ProgramData\OpenWebUI` (Datenbank & Uploads) und `C:\ProgramData\FalkorDB` (Graph-Daten) werden erstellt.
   - Ollama wird mit GPU-Unterstützung gestartet.
   - Open WebUI wird gestartet und automatisch mit Ollama verbunden.
   - FalkorDB wird als Graph-Datenbank für erweitertes GraphRAG gestartet.
   - Das Modell `mistral` wird automatisch heruntergeladen.

---

## 📚 Erste Schritte nach Installation

### 📂 Wo liegen meine Daten?
Durch das Deployment-Script werden alle wichtigen Daten an zentralen, sichtbaren Orten in Windows abgelegt:
- **KI-Modelle**: `C:\ProgramData\Ollama`
- **Dokumente & Datenbank**: `C:\ProgramData\OpenWebUI`
- **Graph-Datenbank**: `C:\ProgramData\FalkorDB` (Wissenslandkarten & Beziehungen).

---

### Use-Case 1: Dokument analysieren

1. **Datei hochladen**
   - Klick auf **Paperclip-Icon** (📎) im Chat
   - PDF/DOCX auswählen
   - Hochladen

2. **Fragen stellen**
   ```
   "Analysiere dieses Dokument und extrahiere alle Anforderungen"
   ```

3. **RAG in Aktion**
   - Open WebUI durchsucht das Dokument automatisch
   - Antwortet mit direkten Zitaten

### Use-Case 2: Anforderungen strukturieren

```prompt
Du bist ein Business Analyst.
Analysiere das hochgeladene Dokument und strukturiere alle 
funktionalen Anforderungen in dieser Form:

| ID | Anforderung | Priorität | Status |
|----|-------------|-----------|--------|

Nutze MUST HAVE, SHOULD HAVE, NICE TO HAVE für Priorität.
```

### Use-Case 3: Lösungsdesign erstellen

```prompt
Basierend auf den Anforderungen aus dem Dokument:
1. Entwirfe eine Architektur-Übersicht
2. Nenne 3 Implementierungsschritte
3. Identifiziere Risiken
4. Schätze Aufwand grob

Formatiere als strukturiertes Markdown.
```

---

## ⚙️ Konfiguration & Optimization

### Modelle verwalten

```bash
# Alle verfügbaren Modelle sehen
ollama list

# Weitere Modelle herunterladen
ollama pull neural-chat      # Klein, schnell
ollama pull orca-mini        # Mittels, gut
ollama pull mistral:7b       # Empfohlen für Analysen
ollama pull llama2:7b        # Vielseitig
```

### Performance-Tuning

Für größere Modelle RAM-Zuweisung in Docker:
```bash
docker update --memory=12g open-webui
```

### Open WebUI neu starten

```bash
docker restart open-webui
```

### Logs anschauen (bei Problemen)

```bash
docker logs open-webui
```

---

## 🔗 Ollama mit Claude API kombinieren (Optional)

Wenn Sie zusätzlich Claude API nutzen möchten:

1. **Claude API Key besorgen**
   - https://console.anthropic.com/
   - API Key generieren

2. **In Open WebUI konfigurieren**
   - Settings → Admin Panel → Model
   - "Add New Model" → Claude
   - API Key eintragen

3. **Jetzt beide nutzen**
   - Dropdown: Mistral (lokal) oder Claude (via API)
   - Flexibilität für verschiedene Tasks!

---

## 🛠️ Troubleshooting

### Problem: "Port 3000 bereits in Verwendung"

```bash
# Anderen Container auf Port 3000 finden
netstat -ano | findstr :3000

# Oder: Anderen Port nutzen
docker run -d -p 3001:8080 ... (statt 3000:8080)
```

### Problem: "Ollama verbindung fehlgeschlagen"

1. Ollama läuft? 
   ```bash
   tasklist | findstr ollama
   ```

2. Im Docker: `host.docker.internal:11434` verwenden
   Nicht `localhost:11434`!

3. Firewall prüfen:
   ```bash
   netstat -an | findstr 11434
   ```

### Problem: "Modell sehr langsam"

- RAM-intensive Modelle vermeiden (z.B. 13B Modelle)
- Empfohlen: `mistral-7b` oder `neural-chat-7b`
- GPU nutzen (Falls vorhanden):
  ```bash
  ollama serve --gpu all
  ```

### Problem: Docker startet nicht

```bash
# Docker Desktop Service neustarten
net stop com.docker.service
net start com.docker.service
```

---

## 📊 Empfohlene Modelle für verschiedene Use-Cases

| Modell | Größe | Speed | Quality | Best für |
|---|---|---|---|---|
| **neural-chat-7b** | 3.8GB | ⚡⚡⚡ | ⭐⭐⭐ | Anfängerlevel Analysen |
| **mistral-7b** | 3.8GB | ⚡⚡ | ⭐⭐⭐⭐ | **EMPFOHLEN** für Anforderungen |
| **llama2-7b** | 3.8GB | ⚡⚡ | ⭐⭐⭐⭐ | Vielseitig, zuverlässig |
| **orca-2-7b** | 3.8GB | ⚡⚡ | ⭐⭐⭐⭐ | Komplexe Analysen |
| **mistral-13b** | 7.4GB | ⚡ | ⭐⭐⭐⭐⭐ | Wenn RAM vorhanden |

**Für den Start**: `mistral-7b` herunterladen und ausprobieren!

---

## 🎯 Nächste Schritte nach Installation

1. **Prompt-Templates erstellen**
   - Dokument für Ihre spezifischen Use-Cases
   
2. **Dokumentenbibliothek aufbauen**
   - Anforderungen systematisch hochladen
   - Indexiert für schnelle Suche

3. **Mit Claude API erweitern**
   - Für kritische Analysen zusätzlich nutzen
   - Load-Balancing zwischen lokal & Cloud

4. **Integration mit Power Automate** (optional)
   - Automatisierte Dokumenten-Workflows

---

## 📞 Hilfreiche Links

- **Open WebUI Docs**: https://docs.openwebui.com/
- **Ollama Models**: https://ollama.ai/library
- **GitHub Issues**: https://github.com/open-webui/open-webui/issues
- **Community Forum**: https://github.com/open-webui/open-webui/discussions

---

**Erstellt**: Dezember 2025  
**Status**: Ready to use  
**Letzte Updates**: Open WebUI Latest, Ollama Latest

