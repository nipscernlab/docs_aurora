# A versao do manual, resolvida sozinha
# ---------------------------------------------------------------------------
# Antes este numero morava escrito a mao em seis lugares (publish.ps1,
# build-pdf.ps1, o conf.py em quatro pontos, o nome do .tex e o do PDF), e
# bastava esquecer um deles para publicar um manual que se anuncia como uma
# versao e entrega outra. Pior: como e o numero do manifesto que faz as
# instalacoes baixarem documentacao nova, esquecer o bump publicava para
# ninguem.
#
# A regra e a que ja estava no README:
#
#   <versao do SAPHO documentada>.<revisao da doc>    6.4.2.6 documenta o 6.4.2
#
# ---------------------------------------------------------------------------
# O que e automatico e o que nao pode ser
# ---------------------------------------------------------------------------
# A revisao, o quarto segmento, e mecanica: avanca sozinha a cada publicacao,
# porque toda publicacao e uma revisao nova e e esse numero que dispara a
# atualizacao nas instalacoes. Ninguem precisa lembrar dela.
#
# A base, os tres primeiros segmentos, NAO acompanha a release do SAPHO
# sozinha, e isso e deliberado. Ela e uma afirmacao editorial: diz que o texto
# foi conferido contra aquela versao do aplicativo. Segui-la automaticamente
# publicaria um manual anunciando o SAPHO 6.6.0 com o conteudo apurado no
# 6.4.2, que e pior do que estar visivelmente atrasado: passa a mentir com
# numero de versao.
#
# Entao o script compara, avisa alto quando o aplicativo esta na frente, e so
# muda a base quando alguem disser que reviu o conteudo, com -AdoptSapho ou
# -Base. O vigia diario (.github/workflows/manual-atrasado.yml) abre a issue
# correspondente.

Set-StrictMode -Version Latest

$script:VersionFile = Join-Path (Split-Path -Parent $PSScriptRoot) "docs-version.json"

function Get-JsonFromUrl {
    param([string]$Url)
    try {
        return Invoke-RestMethod -Uri $Url -Headers @{ "User-Agent" = "docs_aurora" } -TimeoutSec 20
    } catch {
        Write-Host "  aviso: nao consegui ler $Url ($($_.Exception.Message))"
        return $null
    }
}

function Get-LocalVersionFile {
    if (Test-Path -LiteralPath $script:VersionFile) {
        try { return Get-Content -LiteralPath $script:VersionFile -Raw | ConvertFrom-Json } catch { }
    }
    throw "docs-version.json nao encontrado ou ilegivel em '$($script:VersionFile)'."
}

function Save-LocalVersionFile {
    param([string]$Base, [string]$Full, [string]$Commit)

    $dados = [ordered]@{
        # A versao do SAPHO que este manual afirma documentar. Editorial: so
        # muda quando o conteudo e revisado contra uma release nova.
        base    = $Base
        # A ultima versao completa resolvida, com a revisao da doc.
        version = $Full
        # O commit do SAPHO auditado para escrever o manual, citado na capa e
        # no capitulo de escopo.
        commit  = $Commit
        atualizado = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    }
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($script:VersionFile, (($dados | ConvertTo-Json) + "`n"), $utf8NoBom)
}

function Resolve-DocsVersion {
    <#
    .SYNOPSIS
    Devolve a versao a publicar: a base documentada mais a revisao seguinte.

    .PARAMETER Version
    Versao completa escrita a mao (x.y.z.w), para republicar um numero exato.

    .PARAMETER Base
    Nova base documentada (x.y.z), para quando o manual passa a descrever outra
    versao do SAPHO. A revisao recomeca em 1.

    .PARAMETER AdoptSapho
    Adota a versao da release mais recente do SAPHO como base. Use depois de
    revisar o conteudo contra ela.

    .PARAMETER Freeze
    Nao avanca a revisao: devolve a versao que ja esta publicada. Serve para
    reconstruir artefatos sem mexer no numero.
    #>
    param(
        [string]$Version,
        [string]$Base,
        [switch]$AdoptSapho,
        [switch]$Freeze
    )

    $local = Get-LocalVersionFile
    $commit = if ($local.PSObject.Properties['commit']) { $local.commit } else { "" }

    if ($Version) {
        if ($Version -notmatch '^\d+\.\d+\.\d+\.\d+$') { throw "Versao '$Version' fora do formato x.y.z.w." }
        $baseFinal = ($Version -split '\.')[0..2] -join '.'
        Save-LocalVersionFile -Base $baseFinal -Full $Version -Commit $commit
        return [pscustomobject]@{ Version = $Version; Base = $baseFinal; Commit = $commit; Origem = "escrita a mao"; SaphoAtual = $null }
    }

    # A versao do aplicativo hoje, so para comparar.
    $rel = Get-JsonFromUrl "https://api.github.com/repos/nipscernlab/sapho/releases/latest"
    $saphoAtual = if ($rel -and $rel.tag_name) { ($rel.tag_name -replace '^v', '') } else { $null }

    # A base documentada: a de sempre, salvo ordem explicita em contrario.
    $baseFinal = $local.base
    $baseNova = $false
    if ($Base) {
        if ($Base -notmatch '^\d+\.\d+\.\d+$') { throw "Base '$Base' fora do formato x.y.z." }
        $baseFinal = $Base
        $baseNova = ($baseFinal -ne $local.base)
    } elseif ($AdoptSapho) {
        if (-not $saphoAtual) { throw "-AdoptSapho precisa da API do GitHub, que nao respondeu." }
        $baseFinal = $saphoAtual
        $baseNova = ($baseFinal -ne $local.base)
    }

    # O aviso que evita publicar um manual desatualizado sem perceber.
    if ($saphoAtual -and $saphoAtual -ne $baseFinal) {
        Write-Host ""
        Write-Host "  ATENCAO: o SAPHO esta na v$saphoAtual e este manual documenta o $baseFinal." -ForegroundColor Yellow
        Write-Host "  A publicacao segue como revisao do $baseFinal. Depois de conferir o texto" -ForegroundColor Yellow
        Write-Host "  contra a release nova, rode com -AdoptSapho para mudar a base." -ForegroundColor Yellow
        Write-Host ""
    }

    # A revisao, lida do manifesto que esta no ar, para a conta valer mesmo se a
    # publicacao anterior tiver saido de outra maquina.
    $manifesto = Get-JsonFromUrl "https://nipscernlab.github.io/docs_aurora/docs-manifest.json"
    $publicada = if ($manifesto -and $manifesto.version) { $manifesto.version } else { $local.version }

    $revisao = 1
    if (-not $baseNova -and $publicada -match '^(\d+\.\d+\.\d+)\.(\d+)$') {
        if ($Matches[1] -eq $baseFinal) {
            $revisao = if ($Freeze) { [int]$Matches[2] } else { [int]$Matches[2] + 1 }
        }
    }

    $full = "$baseFinal.$revisao"
    $origem = if ($baseNova) { "base nova $baseFinal, revisao reiniciada" }
              elseif ($publicada) { "publicado $publicada, revisao +1" }
              else { "primeira publicacao" }

    Save-LocalVersionFile -Base $baseFinal -Full $full -Commit $commit
    return [pscustomobject]@{ Version = $full; Base = $baseFinal; Commit = $commit; Origem = $origem; SaphoAtual = $saphoAtual }
}

# Deixa a versao visivel para o Sphinx, que le estas variaveis no conf.py e as
# usa no titulo, na capa, no cabecalho, no nome do .tex e no do PDF.
function Set-DocsVersionEnv {
    param([Parameter(Mandatory)]$Resolved)
    $env:AURORA_DOCS_VERSION = $Resolved.Version
    $env:AURORA_DOCS_BASE = $Resolved.Base
    if ($Resolved.Commit) { $env:AURORA_DOCS_COMMIT = $Resolved.Commit }
}
