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

$apiKey = $env:OPENAI_API_KEY
if ([string]::IsNullOrWhiteSpace($apiKey)) {
    Write-Host 'Paste the one-time OpenAI API key. It will not be saved to disk.'
    $secure = Read-Host 'OPENAI_API_KEY' -AsSecureString
    $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    try {
        $apiKey = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
    } finally {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
        $secure.Dispose()
    }
}

$metaModel  = if ($env:META_MODEL)  { $env:META_MODEL }  else { 'gpt-5.6-terra' }
$evalModel  = if ($env:EVAL_MODEL)  { $env:EVAL_MODEL }  else { 'gpt-5.6-luna' }
$judgeModel = if ($env:JUDGE_MODEL) { $env:JUDGE_MODEL } else { 'gpt-5.6-luna' }
$generations = if ($env:ADAS_GENERATIONS) { $env:ADAS_GENERATIONS } else { '5' }

try {
    Write-Host 'Building pinned ADAS + BEANS image...'
    docker build -t beans-adas .
    if ($LASTEXITCODE -ne 0) { throw 'Docker build failed.' }

    Write-Host "Running BEANS Meta Agent Search ($generations generations)..."
    docker run --rm `
        -e "OPENAI_API_KEY=$apiKey" `
        -e "META_MODEL=$metaModel" `
        -e "EVAL_MODEL=$evalModel" `
        -e "JUDGE_MODEL=$judgeModel" `
        -e "ADAS_GENERATIONS=$generations" `
        -v "${results}:/work/results" `
        beans-adas

    if ($LASTEXITCODE -ne 0) { throw "BEANS run failed with exit code $LASTEXITCODE." }

    Write-Host ''
    Write-Host 'BEANS run complete.' -ForegroundColor Green
    Write-Host "Results: $results"
} finally {
    # Dispose of the transient plaintext copy in this process as soon as Docker exits.
    $apiKey = $null
    Remove-Item Env:OPENAI_API_KEY -ErrorAction SilentlyContinue
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}
