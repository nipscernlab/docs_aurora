[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$projectRoot = Split-Path -Parent $PSScriptRoot
$watchScript = Join-Path $PSScriptRoot "watch-site.ps1"
$buildDir = Join-Path $projectRoot "build"
$pidFile = Join-Path $buildDir "watch-site.pid"
$logFile = Join-Path $buildDir "watch-site.log"
$errorLogFile = Join-Path $buildDir "watch-site.error.log"

New-Item -ItemType Directory -Force -Path $buildDir | Out-Null

if (Test-Path -LiteralPath $pidFile -PathType Leaf) {
    $existingPid = [int](Get-Content -LiteralPath $pidFile -Raw)
    if (Get-Process -Id $existingPid -ErrorAction SilentlyContinue) {
        Write-Host "O monitoramento ja esta ativo no processo $existingPid."
        exit 0
    }
    Remove-Item -LiteralPath $pidFile -Force
}

$powershell = (Get-Command powershell.exe).Source
$arguments = @(
    "-NoProfile",
    "-ExecutionPolicy", "Bypass",
    "-File", "`"$watchScript`"",
    "-InitialBuild"
)

Start-Process `
    -FilePath $powershell `
    -ArgumentList $arguments `
    -WindowStyle Hidden `
    -RedirectStandardOutput $logFile `
    -RedirectStandardError $errorLogFile | Out-Null

$deadline = (Get-Date).AddSeconds(10)
while ((Get-Date) -lt $deadline -and -not (Test-Path -LiteralPath $pidFile -PathType Leaf)) {
    Start-Sleep -Milliseconds 200
}

if (-not (Test-Path -LiteralPath $pidFile -PathType Leaf)) {
    throw "O monitoramento nao iniciou. Consulte '$errorLogFile'."
}

$watcherPid = Get-Content -LiteralPath $pidFile -Raw
Write-Host "Geracao automatica ativa no processo $watcherPid."
Write-Host "Log: $logFile"
