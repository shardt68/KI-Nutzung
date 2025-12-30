# AI Stack Deployment Script (Ollama + Open WebUI)
# Führen Sie dieses Script als Administrator aus.

Write-Host "--- Starte AI Stack Deployment ---" -ForegroundColor Cyan

# 1. Prüfe ob Docker läuft
if (!(Get-Process docker -ErrorAction SilentlyContinue)) {
    Write-Error "Docker Desktop läuft nicht. Bitte starten Sie Docker zuerst."
    exit
}

# 2. Erstelle zentrale Ordner falls nicht vorhanden
$paths = @("C:\ProgramData\Ollama", "C:\ProgramData\OpenWebUI", "C:\ProgramData\FalkorDB")
foreach ($path in $paths) {
    if (!(Test-Path $path)) {
        Write-Host "Erstelle Ordner: $path"
        New-Item -ItemType Directory -Path $path -Force
    }
}

# 3. Starte Docker Compose
Write-Host "Starte Container via Docker Compose..." -ForegroundColor Green
docker-compose up -d

# 4. Warte bis Ollama bereit ist
Write-Host "Warte auf Ollama Container..." -ForegroundColor Yellow
$retryCount = 0
while (!(docker ps --filter "name=ollama" --filter "status=running" --format "{{.Names}}") -and $retryCount -lt 10) {
    Start-Sleep -Seconds 2
    $retryCount++
}

# 5. Initiales Modell laden (Mistral)
Write-Host "Lade Standard-Modell (Mistral)... Dies kann einige Minuten dauern." -ForegroundColor Yellow
docker exec -it ollama ollama run mistral

Write-Host "--- Deployment Abgeschlossen ---" -ForegroundColor Cyan
Write-Host "Open WebUI ist erreichbar unter: http://localhost:3000" -ForegroundColor Green
