# KI-gestützte Analyse-Workflows

Dieses Dokument beschreibt, wie der Docker-basierte KI-Stack für Business- und Technical-Analysen genutzt wird.

## 1. Anforderungsanalyse
Nutzen Sie Open WebUI, um Dokumente hochzuladen und strukturiert auszuwerten.

**Prompt-Template:**
> "Analysiere das hochgeladene Dokument. Extrahiere alle funktionalen Anforderungen und erstelle eine Tabelle mit ID, Beschreibung und Priorität (Must/Should/Could)."

## 2. Lösungsdesign & Architektur
Verwenden Sie die KI, um basierend auf den extrahierten Anforderungen Lösungsvorschläge zu generieren.

**Prompt-Template:**
> "Basierend auf den Anforderungen in diesem Dokument: Entwirfe eine High-Level-Architektur. Berücksichtige Skalierbarkeit und Sicherheit."

## 3. GraphRAG (Erweiterte Analyse)
Durch die integrierte **FalkorDB** können komplexe Abhängigkeiten visualisiert werden. Dies ist besonders hilfreich für Impact-Analysen bei Anforderungsänderungen.

## 4. Multi-User Workflow
Da der Stack systemweit installiert ist (`C:\ProgramData`), können verschiedene Teammitglieder auf demselben Host arbeiten, ohne Modelle mehrfach herunterladen zu müssen. Jeder Nutzer verwaltet seine eigenen Chats und Dokumente sicher in Open WebUI.
