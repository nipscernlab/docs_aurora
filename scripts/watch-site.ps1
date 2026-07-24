[CmdletBinding()]
param(
    [switch]$InitialBuild
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$projectRoot = Split-Path -Parent $PSScriptRoot
$sourceDir = Join-Path $projectRoot "source"
$buildCommand = Join-Path $projectRoot "make.bat"
$pidFile = Join-Path $projectRoot "build\watch-site.pid"
$debounceSeconds = 1.5
$allowedExtensions = @(
    ".md", ".rst", ".py", ".css", ".js", ".json",
    ".svg", ".png", ".jpg", ".jpeg", ".gif", ".webp"
)

function Test-RelevantPath {
    param([string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return $false
    }

    $downloadsDir = Join-Path $sourceDir "_static\downloads"
    if ($Path.StartsWith($downloadsDir, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $false
    }

    $name = [System.IO.Path]::GetFileName($Path)
    if ($name.StartsWith(".") -or $name.EndsWith("~") -or $name.EndsWith(".tmp")) {
        return $false
    }

    $extension = [System.IO.Path]::GetExtension($Path).ToLowerInvariant()
    return $allowedExtensions -contains $extension
}

function Invoke-SiteBuild {
    $startedAt = Get-Date
    Write-Host "[$($startedAt.ToString('yyyy-MM-dd HH:mm:ss'))] Alteracao detectada. Gerando PDF e HTML..."

    & cmd.exe /d /c "`"$buildCommand`""
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss'))] ERRO: a geracao automatica falhou com codigo $LASTEXITCODE. O monitoramento continuara ativo."
        return $false
    }

    $elapsed = (Get-Date) - $startedAt
    Write-Host "[$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss'))] Site atualizado em $([math]::Round($elapsed.TotalSeconds, 1)) s."
    return $true
}

New-Item -ItemType Directory -Force -Path (Split-Path -Parent $pidFile) | Out-Null
Set-Content -LiteralPath $pidFile -Value $PID -Encoding ASCII

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $sourceDir
$watcher.Filter = "*"
$watcher.IncludeSubdirectories = $true
$watcher.NotifyFilter = [System.IO.NotifyFilters]'FileName, DirectoryName, LastWrite, Size'

$sourcePrefix = "AuroraDocsWatcher"
$subscriptions = @(
    Register-ObjectEvent -InputObject $watcher -EventName Changed -SourceIdentifier "$sourcePrefix.Changed"
    Register-ObjectEvent -InputObject $watcher -EventName Created -SourceIdentifier "$sourcePrefix.Created"
    Register-ObjectEvent -InputObject $watcher -EventName Deleted -SourceIdentifier "$sourcePrefix.Deleted"
    Register-ObjectEvent -InputObject $watcher -EventName Renamed -SourceIdentifier "$sourcePrefix.Renamed"
)

$watcher.EnableRaisingEvents = $true
$pending = $false
$lastRelevantChange = [datetime]::MinValue

try {
    Write-Host "Monitoramento ativo em '$sourceDir'."

    if ($InitialBuild) {
        Invoke-SiteBuild
    }

    while ($true) {
        $eventRecord = Wait-Event -Timeout 1
        if ($null -ne $eventRecord) {
            $queuedEvents = @(Get-Event)
            foreach ($queuedEvent in $queuedEvents) {
                $path = $queuedEvent.SourceEventArgs.FullPath
                if (Test-RelevantPath -Path $path) {
                    $pending = $true
                    $lastRelevantChange = Get-Date
                    Write-Host "  $($queuedEvent.SourceEventArgs.ChangeType): $path"
                }
                Remove-Event -EventIdentifier $queuedEvent.EventIdentifier -ErrorAction SilentlyContinue
            }
        }

        if ($pending -and (((Get-Date) - $lastRelevantChange).TotalSeconds -ge $debounceSeconds)) {
            $pending = $false
            Invoke-SiteBuild
        }
    }
}
finally {
    $watcher.EnableRaisingEvents = $false
    foreach ($subscription in $subscriptions) {
        Unregister-Event -SubscriptionId $subscription.Id -ErrorAction SilentlyContinue
    }
    $watcher.Dispose()
    Remove-Item -LiteralPath $pidFile -Force -ErrorAction SilentlyContinue
}
