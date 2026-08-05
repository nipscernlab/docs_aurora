[CmdletBinding()]
param(
    [switch]$SkipPdf,
    [switch]$DryRun
)

# Publica a documentacao nos dois canais publicos que os consumidores usam:
#
#   1. branch gh-pages deste repositorio, servido em nipscernlab.github.io e
#      espelhado em nipscern.com/docs/sapho por um Worker do site;
#   2. uma Release deste repositorio, com o pacote offline que a AURORA baixa
#      durante o build.
#
# Nenhum consumidor precisa deste repositorio em disco, nem de caminho fixo: o
# site aponta para uma URL e a AURORA baixa de outra. Rodar em qualquer maquina
# com o repositorio clonado, MiKTeX, Node e gh autenticado.
#
# O PDF e gerado aqui, e nao no CI, porque o manual usa a fonte Segoe UI, que e
# proprietaria da Microsoft e nao pode ser instalada num runner Linux.

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# O Set-Content -Encoding UTF8 do Windows PowerShell escreve BOM, e um BOM no
# inicio do manifesto faz o JSON.parse do Node recusar o arquivo. Tudo que este
# script grava passa por aqui.
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
function Write-Utf8 {
    param([string]$Path, [string]$Content)
    [System.IO.File]::WriteAllText($Path, $Content, $utf8NoBom)
}

$projectRoot = Split-Path -Parent $PSScriptRoot
$sourceDir = Join-Path $projectRoot "source"
$sphinxBuild = Join-Path $projectRoot ".venv\Scripts\sphinx-build.exe"
$webDir = Join-Path $projectRoot "build\web"
$offlineDir = Join-Path $projectRoot "build\offline"
$distDir = Join-Path $projectRoot "build\dist"
$pagesDir = Join-Path $projectRoot "build\gh-pages"

$version = "6.3.2"
$tag = "docs-v$version"
$zipName = "sapho-docs-offline-$version.zip"
$pdfName = "AURORA-Manual-6.3.2.pdf"
$builtPdf = Join-Path $projectRoot "build\pdf\$pdfName"

$repoSlug = "nipscernlab/docs_aurora"

function Assert-Command {
    param([string]$Name, [string]$Hint)
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Comando '$Name' nao encontrado. $Hint"
    }
}

# O gh escreve em stderr em situacoes normais, como "release not found" ao
# consultar uma tag que ainda nao existe. Com ErrorActionPreference = Stop o
# PowerShell trata esse stderr como erro terminante, entao as chamadas passam
# por aqui e sao julgadas pelo codigo de saida.
function Invoke-Gh {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Arguments)

    $previous = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        $output = & gh @Arguments 2>&1 | Out-String
        return [pscustomobject]@{ ExitCode = $LASTEXITCODE; Output = $output }
    }
    finally {
        $ErrorActionPreference = $previous
    }
}

Assert-Command -Name "git" -Hint "Instale o Git para Windows."
Assert-Command -Name "gh" -Hint "Instale o GitHub CLI e rode 'gh auth login'."

if (-not (Test-Path -LiteralPath $sphinxBuild -PathType Leaf)) {
    throw "Sphinx nao encontrado em '$sphinxBuild'. Recrie o ambiente virtual e instale requirements.txt."
}

function Invoke-SphinxHtml {
    param([string]$Target, [string]$OutputDir)

    Remove-Item -LiteralPath $OutputDir -Recurse -Force -ErrorAction SilentlyContinue

    # -d mantem os .doctrees fora da saida. Sem isso o Sphinx os grava em
    # <saida>/.doctrees, e quase 1 MB de estado interno do build acabaria
    # publicado no site e dentro do pacote offline.
    $doctreesDir = Join-Path $projectRoot "build\doctrees-$Target"

    $previous = [Environment]::GetEnvironmentVariable("AURORA_DOCS_TARGET", "Process")
    try {
        $env:AURORA_DOCS_TARGET = $Target
        & $sphinxBuild -E -b html -d $doctreesDir $sourceDir $OutputDir
        if ($LASTEXITCODE -ne 0) {
            throw "O Sphinx encerrou com codigo $LASTEXITCODE no alvo '$Target'."
        }
    }
    finally {
        if ($null -eq $previous) {
            Remove-Item Env:AURORA_DOCS_TARGET -ErrorAction SilentlyContinue
        }
        else {
            $env:AURORA_DOCS_TARGET = $previous
        }
    }

    # O Sphinx ja copia toda imagem referenciada para _images, entao a pasta
    # original em _static/screenshots so duplicaria o peso. Nenhuma pagina
    # aponta para ela; a verificacao logo abaixo garante isso.
    $screenshots = Join-Path $OutputDir "_static\screenshots"
    if (Test-Path -LiteralPath $screenshots) {
        Remove-Item -LiteralPath $screenshots -Recurse -Force
    }

    $stale = Get-ChildItem -LiteralPath $OutputDir -Recurse -Filter "*.html" |
        Select-String -Pattern "_static/screenshots/" -List
    if ($stale) {
        throw "Ha paginas apontando para _static/screenshots: $($stale[0].Path)."
    }
}

# ---------- 1. PDF ----------

if ($SkipPdf) {
    if (-not (Test-Path -LiteralPath $builtPdf -PathType Leaf)) {
        throw "-SkipPdf exige um PDF ja gerado em '$builtPdf'."
    }
    Write-Host "Reaproveitando o PDF existente."
}
else {
    Write-Host "== Gerando o manual em PDF =="
    & (Join-Path $PSScriptRoot "build-pdf.ps1")
    if ($LASTEXITCODE -ne 0) {
        throw "A geracao do PDF falhou."
    }
}

# ---------- 2. HTML dos dois alvos ----------

Write-Host "== Gerando o HTML do site =="
Invoke-SphinxHtml -Target "web" -OutputDir $webDir

Write-Host "== Gerando o HTML offline =="
Invoke-SphinxHtml -Target "offline" -OutputDir $offlineDir

# A extensao do Mermaid injeta o script do cdn.jsdelivr.net mesmo quando os
# diagramas ja foram desenhados em SVG durante o build. Offline esse script so
# falha, entao sai daqui. Nao ha como desligar pela configuracao: a extensao
# valida mermaid_version e recusa string vazia.
$stripped = 0
Get-ChildItem -LiteralPath $offlineDir -Recurse -Filter "*.html" | ForEach-Object {
    $html = Get-Content -LiteralPath $_.FullName -Raw
    if ($html -match 'cdn\.jsdelivr\.net') {
        $clean = [regex]::Replace(
            $html,
            '(?s)<script type="module">\s*import mermaid.*?</script>',
            ''
        )
        Write-Utf8 -Path $_.FullName -Content $clean
        $stripped++
    }
}
Write-Host "Script remoto do Mermaid removido de $stripped pagina(s)."

$remaining = Get-ChildItem -LiteralPath $offlineDir -Recurse -Filter "*.html" |
    Select-String -Pattern "https?://(cdn\.jsdelivr\.net|unpkg\.com|fonts\.googleapis\.com)" -List
if ($remaining) {
    throw "O pacote offline ainda depende de rede: $($remaining[0].Path)."
}

# ---------- 3. Pacote offline ----------

New-Item -ItemType Directory -Force -Path $distDir | Out-Null
$zipPath = Join-Path $distDir $zipName
Remove-Item -LiteralPath $zipPath -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $offlineDir "*") -DestinationPath $zipPath

$hash = (Get-FileHash -LiteralPath $zipPath -Algorithm SHA256).Hash.ToLower()
$hashPath = "$zipPath.sha256"
Set-Content -LiteralPath $hashPath -Value "$hash  $zipName" -Encoding ASCII

Write-Host ("Pacote offline: {0:N1} MiB" -f ((Get-Item $zipPath).Length / 1MB))
Write-Host "SHA-256: $hash"

# ---------- 3b. Manifesto ----------

# Publicado junto do site, e o que torna a atualizacao automatica: a AURORA le
# este arquivo, compara com a versao que tem em disco e baixa o pacote novo
# sozinha. Sem ele, so uma recompilacao do aplicativo traria documentacao nova.
$manifest = [ordered]@{
    version   = $version
    published = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    package   = "https://github.com/nipscernlab/docs_aurora/releases/download/$tag/$zipName"
    sha256    = $hash
    bytes     = (Get-Item $zipPath).Length
    online    = "https://www.nipscern.com/docs/sapho/"
}
$manifestJson = $manifest | ConvertTo-Json
Write-Utf8 -Path (Join-Path $webDir "docs-manifest.json") -Content $manifestJson
Write-Utf8 -Path (Join-Path $distDir "docs-manifest.json") -Content $manifestJson

if ($DryRun) {
    Write-Host ""
    Write-Host "-DryRun: nada foi enviado. Artefatos em '$distDir' e '$webDir'."
    return
}

# ---------- 4. Site: branch gh-pages ----------

# O branch e recriado do zero a cada publicacao. Sem isso o historico guardaria
# uma copia do site (e do PDF) por versao, e o clone cresceria sem limite.
Write-Host "== Publicando o site no branch gh-pages =="
$remoteUrl = (git -C $projectRoot remote get-url origin).Trim()

Remove-Item -LiteralPath $pagesDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $pagesDir | Out-Null

Copy-Item -Path (Join-Path $webDir "*") -Destination $pagesDir -Recurse -Force
# Sem .nojekyll o GitHub Pages descarta _static e _images, que comecam com "_".
New-Item -ItemType File -Force -Path (Join-Path $pagesDir ".nojekyll") | Out-Null

git -C $pagesDir init --initial-branch=gh-pages --quiet
git -C $pagesDir remote add origin $remoteUrl
git -C $pagesDir add --all
git -C $pagesDir -c core.safecrlf=false commit --quiet -m "Documentacao do SAPHO $version"
git -C $pagesDir push --force --quiet origin gh-pages
if ($LASTEXITCODE -ne 0) {
    throw "Falha ao enviar o branch gh-pages."
}

# ---------- 5. AURORA: release com o pacote offline ----------

Write-Host "== Publicando a Release com o pacote offline =="
$manifestAsset = Join-Path $distDir "docs-manifest.json"
$notes = "Pacote offline da documentacao do SAPHO, consumido pela AURORA.`n`nSHA-256: ``$hash``"

$view = Invoke-Gh release view $tag --repo $repoSlug
if ($view.ExitCode -eq 0) {
    $result = Invoke-Gh release upload $tag $zipPath $hashPath $manifestAsset --repo $repoSlug --clobber
}
else {
    $result = Invoke-Gh release create $tag $zipPath $hashPath $manifestAsset `
        --repo $repoSlug --title "Documentacao do SAPHO $version" --notes $notes
}
if ($result.ExitCode -ne 0) {
    throw "Falha ao publicar a Release:`n$($result.Output)"
}

# ---------- 6. Resumo ----------

Write-Host ""
Write-Host "Publicado:"
Write-Host "  site     https://www.nipscern.com/docs/sapho/"
Write-Host "  manual   https://www.nipscern.com/docs/sapho/_static/downloads/$pdfName"
Write-Host "  pacote   https://github.com/nipscernlab/docs_aurora/releases/download/$tag/$zipName"
Write-Host ""
Write-Host "O site depende da rota do Worker no painel da Cloudflare:"
Write-Host "  nipscern.com/docs/sapho*"
Write-Host "  www.nipscern.com/docs/sapho*"
