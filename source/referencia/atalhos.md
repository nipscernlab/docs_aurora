# Atalhos de teclado

Os atalhos seguem o contexto ativo: um comando do editor exige que o foco esteja no arquivo, enquanto um comando da {guilabel}`Configuração de ondas` exige que essa janela esteja ativa. Todos são reconfiguráveis em {menuselection}`Configurações do Aurora --> Atalhos de Teclado`.

## Arquivos e abas

:::{list-table}
:header-rows: 1
:widths: 30 70

* - Atalho
  - Ação
* - {kbd}`Ctrl+N`
  - Criar um arquivo novo
* - {kbd}`Ctrl+S`
  - Salvar o arquivo ativo
* - {kbd}`Ctrl+Shift+S`
  - Salvar todos os arquivos modificados
* - {kbd}`Ctrl+W`
  - Fechar a aba ativa
* - {kbd}`Ctrl+Shift+T`
  - Reabrir a última aba fechada
:::

## Navegação e comandos

:::{list-table}
:header-rows: 1
:widths: 30 70

* - Atalho
  - Ação
* - {kbd}`Ctrl+Shift+F`
  - Buscar nos arquivos do projeto
* - {kbd}`Ctrl+Shift+P`
  - Abrir a paleta de comandos da AURORA
* - {kbd}`F1`
  - Abrir a paleta de comandos do Monaco
* - {kbd}`Ctrl+G`
  - Ir para uma linha
* - {kbd}`F12`
  - Ir para a definição, quando o servidor de linguagem a fornece
* - {kbd}`Shift+F12`
  - Localizar referências, quando disponível
:::

## Edição

:::{list-table}
:header-rows: 1
:widths: 30 70

* - Atalho
  - Ação
* - {kbd}`Ctrl+F`
  - Localizar no arquivo
* - {kbd}`Ctrl+H`
  - Localizar e substituir
* - {kbd}`Ctrl+Z` e {kbd}`Ctrl+Y`
  - Desfazer e refazer
* - {kbd}`Alt+Click`
  - Adicionar um cursor
* - {kbd}`Ctrl+/`
  - Comentar ou descomentar a linha
* - {kbd}`Shift+Alt+F`
  - Formatar o documento com o clang-format
:::

## Ferramentas de linguagem

:::{list-table}
:header-rows: 1
:widths: 30 70

* - Atalho
  - Ação
* - {kbd}`Ctrl+Alt+S`
  - Ligar ou desligar a análise semântica do slang, mais pesada
:::

## Configuração de ondas

:::{list-table}
:header-rows: 1
:widths: 30 70

* - Atalho
  - Ação
* - {kbd}`Ctrl+F`
  - Focar a pesquisa
* - {kbd}`Esc`
  - Limpar a pesquisa; pressione de novo para fechar
:::

## Redefinir um atalho

Em {menuselection}`Configurações do Aurora --> Atalhos de Teclado`, clique na combinação que quer trocar e tecle a nova. Combinações em conflito são recusadas com aviso, e {kbd}`Esc` cancela a gravação.

```{figure} ../_static/assets/screenshots/aurora-settings-shortcuts.png
:alt: Seção Atalhos de Teclado nas configurações da AURORA.
:width: 90%
:align: center
:name: fig-atalhos

Cada linha da lista pode ser regravada. As combinações já usadas por outro comando são recusadas.
```

:::{note}
Dentro do editor valem ainda os atalhos usuais do Monaco, herdados do Visual Studio Code, mesmo os não listados aqui.

Se um atalho não responder, clique primeiro na área em que ele deve atuar. Menus, diálogos abertos ou ferramentas externas em primeiro plano podem capturar a combinação.
:::
