# Documentação da AURORA

<p align="center">
  <img src="source/_static/aurora.svg" alt="Logo da AURORA" width="240">
</p>

Documentação técnica e de usuário do SAPHO e da AURORA 6.4.2, produzida com Sphinx e MyST Markdown a partir do código-fonte local, da wiki de apoio e dos documentos do repositório.

## Editar as informações do site

O conteúdo publicado fica nos arquivos Markdown (`.md`) dentro da pasta `source`. A organização das pastas corresponde às seções do site. Por exemplo:

| Página do site | Arquivo que deve ser editado |
|---|---|
| Página inicial | `source\index.md` |
| Instalação | `source\inicio\instalacao.md` |
| Interface principal | `source\uso\interface.md` |
| Processadores SAPHO | `source\uso\processadores.md` |
| Fluxo de projetos Verilog | `source\fluxos\verilog.md` |
| Source Control e Git | `source\uso\source-control.md` |

Para alterar uma página existente:

1. Localize o arquivo `.md` correspondente dentro de `source`.
2. Edite o texto preservando a estrutura de títulos, diretivas MyST, links e referências existentes.
3. Coloque novas capturas de tela em `source\_static\screenshots` e use um caminho relativo no Markdown, como `../_static/screenshots/nome-da-imagem.png` para páginas dentro das subpastas de `source`.
4. Execute `.\make.bat html-only` para conferir rapidamente a alteração em `build\html\index.html`.

Para adicionar uma página, crie o arquivo `.md` na seção adequada e inclua o caminho, sem a extensão, em um bloco `toctree` de `source\index.md`. Uma página fora do `toctree` não aparecerá na navegação principal.

## Atualizar o PDF e o site

Depois de concluir as edições, execute na raiz deste projeto:

```powershell
.\make.bat
```

Esse comando realiza o fluxo completo:

1. Gera novamente o manual em PDF.
2. Atualiza a cópia oferecida pelo botão **Baixar manual em PDF** do site.
3. Reconstrói todas as páginas HTML.

Confira os resultados nestes caminhos:

```text
build\pdf\AURORA-Manual-6.4.2.pdf
build\html\index.html
build\html\_static\downloads\AURORA-Manual-6.4.2.pdf
```

Antes de publicar, abra o HTML e o PDF para verificar textos, imagens, navegação e formatação.

## Geração automática durante a edição

Inicie o monitoramento em segundo plano:

```powershell
.\start-watch.bat
```

O monitor realiza uma compilação inicial. Depois, alterações em Markdown, configuração, CSS, JavaScript e imagens dentro de `source` regeneram automaticamente o PDF e o HTML após uma espera curta para agrupar salvamentos consecutivos.

O PDF gerado pelo próprio processo em `source\_static\downloads` é ignorado pelo monitor, evitando ciclos de compilação. Acompanhe a execução em `build\watch-site.log` e erros em `build\watch-site.error.log`.

Para encerrar:

```powershell
.\stop-watch.bat
```

## Gerar o manual em PDF

Pré-requisitos:

- Node.js 18 ou superior;
- MiKTeX com os comandos `xelatex` e `latexmk`;
- Microsoft Edge no caminho padrão do Windows.

Na primeira execução, instale o renderizador local dos diagramas:

```powershell
npm.cmd install
```

Depois gere o PDF com um dos comandos:

```powershell
.\make-pdf.bat
# ou:
.\make.bat pdf
# ou, se GNU Make estiver disponível:
make pdf
```

O arquivo final será gravado em:

```text
build\pdf\AURORA-Manual-6.4.2.pdf
```

O processo usa Sphinx para produzir LaTeX, Mermaid CLI para converter os diagramas e XeLaTeX/latexmk para montar o documento A4.

## Publicar

Este repositório é o único publicador da documentação. Um comando gera tudo e envia para dois canais públicos, que os consumidores acessam por URL:

```powershell
.\scripts\publish.ps1
```

| Canal | O que vai | Quem consome |
|---|---|---|
| Branch `gh-pages` deste repositório | Site em HTML e o manual em PDF ao lado | `nipscern.com/library/sapho/`, por um Worker do site |
| Release `docs-v6.4.2` deste repositório | `sapho-docs-offline-6.4.2.zip` e o `.sha256` | A AURORA, durante o build |

Nenhum consumidor precisa deste repositório em disco, nem de caminho fixo. O site do NIPSCERN não guarda cópia das páginas: a rota `nipscern.com/library/sapho*` é atendida por um Worker que serve o `gh-pages` daqui, no mesmo padrão já usado pelo CGVWeb. Publicar uma versão nova atualiza o site sem tocar no repositório do site.

Para conferir os artefatos sem enviar nada:

```powershell
.\scripts\publish.ps1 -DryRun
```

O branch `gh-pages` é recriado a cada publicação, com um único commit. Sem isso o histórico guardaria uma cópia do site e do PDF por versão.

Pré-requisitos: os mesmos da geração do PDF, mais o GitHub CLI autenticado (`gh auth login`). O PDF é gerado aqui, e não em integração contínua, porque o manual usa a fonte Segoe UI, proprietária da Microsoft, que não pode ser instalada num runner Linux.

Ao mudar a versão do manual, atualize `pdf_name` em `source\conf.py` e `$version` em `scripts\publish.ps1`.

## Escopo congelado

- versão: `6.4.2`
- commit: `f71b2f4551bb59f20a2ae33dcd715eea3bd78050`
- data da análise: `9 de julho de 2026`
- plataforma descrita: Windows 10/11

O diretório é independente do repositório da AURORA. Nenhum arquivo-fonte do aplicativo é modificado pela geração desta documentação.
