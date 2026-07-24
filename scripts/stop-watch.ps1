[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$projectRoot = Split-Path -Parent $PSScriptRoot
$pidFile = Join-Path $projectRoot "build\watch-site.pid"

if (-not (Test-Path -LiteralPath $pidFile -PathType Leaf)) {
    Write-Host "O monitoramento nao esta ativo."
    exit 0
}

$watcherPid = [int](Get-Content -LiteralPath $pidFile -Raw)
$process = Get-Process -Id $watcherPid -ErrorAction SilentlyContinue

if ($null -ne $process) {
    Stop-Process -Id $watcherPid
    $null = $process.WaitForExit(5000)
}

Remove-Item -LiteralPath $pidFile -Force -ErrorAction SilentlyContinue
Write-Host "Geracao automatica encerrada."
