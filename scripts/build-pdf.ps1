[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$projectRoot = Split-Path -Parent $PSScriptRoot
$sourceDir = Join-Path $projectRoot "source"
$latexDir = Join-Path $projectRoot "build\latex"
$pdfDir = Join-Path $projectRoot "build\pdf"
$webSourceDir = Join-Path $sourceDir "_static\downloads"
$webBuildDir = Join-Path $projectRoot "build\html\_static\downloads"
$sphinxBuild = Join-Path $projectRoot ".venv\Scripts\sphinx-build.exe"
$mermaidCli = Join-Path $projectRoot "node_modules\@mermaid-js\mermaid-cli\src\cli.js"
$texName = "AURORA-Manual-6.4.2.tex"
$pdfName = "AURORA-Manual-6.4.2.pdf"

function Assert-Command {
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$InstallHint
    )

    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Comando '$Name' nao encontrado. $InstallHint"
    }
}

if (-not (Test-Path -LiteralPath $sphinxBuild -PathType Leaf)) {
    throw "Sphinx nao encontrado em '$sphinxBuild'. Recrie o ambiente virtual e instale requirements.txt."
}

if (-not (Test-Path -LiteralPath $mermaidCli -PathType Leaf)) {
    throw "Mermaid CLI nao encontrado. Execute 'npm.cmd install' na raiz da documentacao."
}

Assert-Command -Name "node.exe" -InstallHint "Instale o Node.js 18 ou superior."
Assert-Command -Name "latexmk.exe" -InstallHint "Instale o MiKTeX com latexmk."
Assert-Command -Name "xelatex.exe" -InstallHint "Instale o mecanismo XeLaTeX pelo MiKTeX."

# 'latexmk' e 'pdfcrop' do MiKTeX sao scripts Perl. Quando nao ha Perl no PATH,
# usa um interpretador conhecido do Windows antes de desistir.
if (-not (Get-Command "perl.exe" -ErrorAction SilentlyContinue)) {
    $perlCandidates = @(
        "C:\Program Files\Git\usr\bin",
        "C:\Program Files (x86)\Git\usr\bin",
        "C:\Strawberry\perl\bin"
    )

    $perlDir = $perlCandidates | Where-Object { Test-Path -LiteralPath (Join-Path $_ "perl.exe") -PathType Leaf } | Select-Object -First 1
    if (-not $perlDir) {
        throw "Perl nao encontrado. Instale o Git para Windows ou o Strawberry Perl; o MiKTeX precisa dele para 'latexmk' e 'pdfcrop'."
    }

    $env:PATH = "$perlDir;$env:PATH"
    Write-Host "Usando o Perl de '$perlDir'."
}

New-Item -ItemType Directory -Force -Path $latexDir, $pdfDir, $webSourceDir | Out-Null

Write-Host "Gerando fontes LaTeX com Sphinx..."
$previousPdfBuild = [Environment]::GetEnvironmentVariable("AURORA_PDF_BUILD", "Process")
try {
    $env:AURORA_PDF_BUILD = "1"
    & $sphinxBuild -E -W --keep-going -b latex $sourceDir $latexDir
    if ($LASTEXITCODE -ne 0) {
        throw "O Sphinx encerrou com codigo $LASTEXITCODE."
    }
}
finally {
    if ($null -eq $previousPdfBuild) {
        Remove-Item Env:AURORA_PDF_BUILD -ErrorAction SilentlyContinue
    }
    else {
        $env:AURORA_PDF_BUILD = $previousPdfBuild
    }
}

$texPath = Join-Path $latexDir $texName
if (-not (Test-Path -LiteralPath $texPath -PathType Leaf)) {
    throw "O Sphinx nao gerou o arquivo esperado: '$texPath'."
}

Write-Host "Compilando o PDF com XeLaTeX..."
Push-Location $latexDir
try {
    & latexmk.exe -xelatex -interaction=nonstopmode -halt-on-error -file-line-error $texName
    if ($LASTEXITCODE -ne 0) {
        throw "O latexmk encerrou com codigo $LASTEXITCODE."
    }
}
finally {
    Pop-Location
}

$generatedPdf = Join-Path $latexDir $pdfName
if (-not (Test-Path -LiteralPath $generatedPdf -PathType Leaf)) {
    throw "O arquivo PDF esperado nao foi gerado: '$generatedPdf'."
}

$finalPdf = Join-Path $pdfDir $pdfName
Copy-Item -LiteralPath $generatedPdf -Destination $finalPdf -Force

$webSourcePdf = Join-Path $webSourceDir $pdfName
Copy-Item -LiteralPath $generatedPdf -Destination $webSourcePdf -Force

if (Test-Path -LiteralPath (Split-Path -Parent $webBuildDir) -PathType Container) {
    New-Item -ItemType Directory -Force -Path $webBuildDir | Out-Null
    Copy-Item -LiteralPath $generatedPdf -Destination (Join-Path $webBuildDir $pdfName) -Force
}

$size = (Get-Item -LiteralPath $finalPdf).Length
Write-Host ""
Write-Host "PDF gerado com sucesso:"
Write-Host "  $finalPdf"
Write-Host ("  {0:N1} MiB" -f ($size / 1MB))
Write-Host "Download do site atualizado:"
Write-Host "  $webSourcePdf"
