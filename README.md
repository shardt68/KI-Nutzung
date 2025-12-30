# AI Stack für Business & Technical Domain Analysis

Dieses Projekt bietet eine schlüsselfertige Lösung für die lokale Analyse von Dokumenten (Anforderungen, Spezifikationen, Prozessbeschreibungen) mittels Künstlicher Intelligenz. Es kombiniert modernste LLM-Technologie mit Graph-Datenbanken für tiefgehende Analysen.

## 🚀 Features

- **Ollama**: Lokale Ausführung von LLMs (z.B. Mistral, Llama 3) mit GPU-Unterstützung.
- **Open WebUI**: Benutzerfreundliches Interface für Chat, Dokumenten-Upload (RAG) und Benutzerverwaltung.
- **FalkorDB**: Graph-Datenbank zur Abbildung komplexer Abhängigkeiten (GraphRAG).
- **Multi-User Ready**: Zentrale Datenablage unter `C:\ProgramData` für effiziente Ressourcennutzung.
- **Automatisierung**: One-Click Deployment via PowerShell oder Bash.

## 📋 Voraussetzungen

- **Windows 10/11** mit **WSL 2** installiert.
- **Docker Desktop** (mit aktiviertem WSL 2 Backend).
- **NVIDIA GPU** (empfohlen für flüssige Performance).
- **Sudo für Windows** (optional für Windows 11, um Bash-Scripte einfacher auszuführen).

## 🛠️ Installation & Start

### 1. Repository klonen
```bash
git clone https://github.com/shardt68/KI-Nutzung.git
cd KI-Nutzung
```

### 2. Deployment ausführen
Wählen Sie das passende Script für Ihre Umgebung:

- **Windows (PowerShell Admin):**
  Falls die Skriptausführung deaktiviert ist, führen Sie zuerst `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser` aus oder nutzen Sie den Bypass:
  ```powershell
  powershell -ExecutionPolicy Bypass -File .\deploy_ai_stack.ps1
  ```
- **WSL / Linux (Bash):**
  ```bash
  chmod +x deploy_ai_stack.sh
  ./deploy_ai_stack.sh
  ```

> **Hinweis für Windows 11:** Falls Sie das Bash-Script direkt in der Windows-Konsole nutzen möchten, stellen Sie sicher, dass "Sudo für Windows" in den Systemeinstellungen aktiviert ist oder führen Sie die Konsole als Administrator aus.

### 3. Zugriff
Öffnen Sie Ihren Browser unter: [http://localhost:3000](http://localhost:3000)

## � Nutzung auf anderen Rechnern

### Neues Setup (Installation)
Um den Stack auf einem weiteren Rechner zu installieren, wiederholen Sie einfach die Schritte unter **Installation & Start**. Stellen Sie sicher, dass Docker und WSL 2 bereitstehen.

### Zugriff im Netzwerk (Remote)
Falls der Stack bereits auf einem Server/Rechner läuft und Sie von einem anderen Gerät im selben Netzwerk darauf zugreifen möchten:
1. **IP-Adresse ermitteln**: Finden Sie die IP des Host-Rechners heraus (z.B. via `ipconfig`).
2. **Firewall**: Stellen Sie sicher, dass Port `3000` (WebUI) und optional `11434` (Ollama) in der Windows-Firewall für eingehende Verbindungen freigegeben sind.
3. **Browser**: Öffnen Sie `http://<IP-ADRESSE>:3000`.

## �📂 Datenstruktur (Windows)

Um Speicherplatz zu sparen und Daten für alle Benutzer verfügbar zu machen, nutzt dieses Projekt zentrale Pfade:
- **Modelle**: `C:\ProgramData\Ollama`
- **Dokumente/DB**: `C:\ProgramData\OpenWebUI`
- **Graph-Daten**: `C:\ProgramData\FalkorDB`

## 📖 Dokumentation

Detaillierte Schritt-für-Schritt Anleitungen und Use-Cases finden Sie in der [OPEN_WEBUI_SETUP.md](OPEN_WEBUI_SETUP.md).
Strategische Überlegungen zum Workflow sind in der [AGENTS.md](AGENTS.md) dokumentiert.

## ⚖️ Lizenz
Dieses Projekt ist für die interne Nutzung und Analyse optimiert. Bitte beachten Sie die Lizenzen der verwendeten Tools (Ollama, Open WebUI, FalkorDB).
