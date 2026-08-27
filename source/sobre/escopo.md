# Escopo, versão e método

## O que foi documentado

Esta documentação descreve a aplicação desktop AURORA no estado observado no repositório local. O conteúdo é orientado ao uso da aplicação por:

- **Estudantes e projetistas**, que precisam criar projetos, processadores, testbenches e interpretar resultados.
- **Docentes e equipes de laboratório**, que precisam explicar o fluxo SAPHO e reproduzir ambientes.
- **Usuários avançados**, que precisam configurar simulação, formas de onda, controle de versão e Aurora Intelligence.

| Item | Valor congelado |
|---|---|
| Produto | AURORA IDE / SAPHO |
| Versão do pacote | 6.10.0 |
| Commit | `15908dc9fc73188158b25fd0e43155ed88aecdbb` |
| Branch | `main` |
| Plataforma primária | Windows 10/11 |
| Runtime | Electron 43.4 |
| Editor | Monaco Editor 0.52.2, fixado exatamente |
| Data da análise | 27 de agosto de 2026 (base anterior, 6.4.2, apurada em 9 de julho de 2026) |

## Fontes e precedência

As informações foram consolidadas nesta ordem de confiança:

1. Comportamento implementado no código-fonte.
2. Testes unitários e E2E.
3. Arquivos de configuração, scripts de bootstrap, empacotamento e release.
4. Documentos `ARCHITECTURE.md`, `README.md`, `RELEASE.md`, `SECURITY.md` e documentação interna.
5. Wiki local de apoio em `C:\Users\Computador\Documents\Arthur\NIPSCERN\Backup_Last_Project\Project_Wiki`, especialmente a rebaseline e o inventário funcional de 9 de julho de 2026.
6. Páginas públicas oficiais do NIPS-CERN sobre AURORA, SAPHO e YANC.
7. Documentação oficial das tecnologias integradas.

:::{note}
A wiki local é usada como apoio de rastreabilidade, não como substituta do código. Quando a wiki e o código divergem, o comportamento implementado no commit documentado prevalece.
:::

## Convenções

- **C±** e **CMM** referem-se à linguagem de entrada usada pelo SAPHO e à extensão `.cmm`.
- **Processador** é o núcleo de hardware gerado a partir de um algoritmo C±.
- **Top Level** é o módulo Verilog raiz da síntese.
- **Testbench Top** é o arquivo de simulação selecionado; pode ser Verilog (`.v`) ou cocotb/Python (`.py`).
- Caminhos entre `<...>` são exemplos e devem ser substituídos pelo valor local.
- Opções marcadas como *legadas* existem no DOM ou em configurações antigas, mas não constituem um fluxo ativo confiável nesta versão.

## Limites

Este manual não reproduz a especificação completa da linguagem C± nem os manuais de cada ferramenta externa. Ele explica como executar tarefas na AURORA, compreender os arquivos produzidos e verificar os resultados observáveis de cada fluxo.

Não foram alterados arquivos do código-fonte e nenhum commit foi criado durante a produção deste material.

## Créditos

Manual escrito e mantido por Chrysthofer A. A. Afonso, com orientação de Luciano M. de A. Filho, no NIPS-CERN (UFJF).
