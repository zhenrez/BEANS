$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

function Require-Command($name, $help) {
    if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
        Write-Host "Missing prerequisite: $name" -ForegroundColor Red
        Write-Host $help
        exit 1
    }
}

Require-Command 'docker' 'Install/start Docker Desktop, then double-click RUN_BEANS.cmd again.'

try {
    docker info *> $null
} catch {
    Write-Host 'Docker Desktop is installed but not running.' -ForegroundColor Red
    exit 1
}

$results = Join-Path $PSScriptRoot 'results'
New-Item -ItemType Directory -Force -Path $results | Out-Null

Write-Host 'Building pinned ADAS + BEANS UI...'
docker build -t beans-adas .
if ($LASTEXITCODE -ne 0) { throw 'Docker build failed.' }

# Replace only our own previous local BEANS container.
docker rm -f beans-adas-ui *> $null

Write-Host 'Starting BEANS UI...'
docker run -d --rm `
    --name beans-adas-ui `
    -p 127.0.0.1:8765:8765 `
    -v "${results}:/work/results" `
    beans-adas | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'BEANS container failed to start.' }

$ready = $false
for ($i = 0; $i -lt 30; $i++) {
    try {
        $r = Invoke-WebRequest -UseBasicParsing -Uri 'http://127.0.0.1:8765/api/status' -TimeoutSec 1
        if ($r.StatusCode -eq 200) { $ready = $true; break }
    } catch {}
    Start-Sleep -Milliseconds 500
}

if (-not $ready) {
    Write-Host 'BEANS UI did not become ready. Container log:' -ForegroundColor Red
    docker logs beans-adas-ui
    exit 1
}

Start-Process 'http://127.0.0.1:8765'
Write-Host ''
Write-Host 'BEANS is open at http://127.0.0.1:8765' -ForegroundColor Green
Write-Host 'Paste the one-time API key in the page and click Start.'
Write-Host 'The key is kept only in the running container process and removed after the experiment.'
Write-Host ''
Write-Host 'You can close this window; Docker keeps the UI running.'
