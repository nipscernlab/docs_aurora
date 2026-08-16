# Tour pela interface

Uma janela, cinco regiões: a barra de ferramentas no topo, a árvore de arquivos à esquerda, o editor no centro, os terminais embaixo e a barra de status no rodapé. O painel da Aurora Intelligence, quando aberto, entra à direita.

```{figure} ../_static/assets/screenshots/aurora-interface-completa.png
:alt: Janela completa da AURORA com projeto aberto, editor, terminais e barra de status.
:width: 100%
:align: center
:name: fig-interface

A janela com um projeto aberto. Esta captura serve de mapa para o restante do capítulo.
```

## A barra de ferramentas

Os botões se agrupam por assunto, da esquerda para a direita. Um botão cinza está desabilitado porque falta um pré-requisito; o tooltip diz qual.

### Projeto

```{figure} ../_static/assets/screenshots/aurora-toolbar-projeto.png
:alt: Botões de alternar barra lateral, Novo Projeto e Abrir Projeto.
:align: center
```

{guilabel}`Novo Projeto` cria um projeto do zero; {guilabel}`Abrir Projeto` abre um arquivo {file}`.spf` existente. O primeiro ícone recolhe e restaura a árvore lateral.

### Processador

```{figure} ../_static/assets/screenshots/aurora-toolbar-processador.png
:alt: Hub de Processadores, botão Compilar C± e engrenagem de configuração.
:align: center
```

{guilabel}`Hub de Processadores` cria um processador novo. {guilabel}`Compilar C±` compila o arquivo {file}`.cmm` em foco no editor; só habilita quando um {file}`.cmm` está aberto e em foco. A engrenagem abre a configuração de simulação do processador ativo: frequência de clock, número de ciclos e exibição de arrays na onda.

### Síntese

```{figure} ../_static/assets/screenshots/aurora-toolbar-sintese.png
:alt: Botões Sintetizar Verilog e Abrir PRISM.
:align: center
```

{guilabel}`Sintetizar Verilog` valida o projeto: elabora todos os fontes a partir do Top Level e gera a hierarquia de módulos. {guilabel}`Abrir PRISM` faz o mesmo e abre o diagrama do circuito. Os dois exigem um Top Level definido.

### Ondas

```{figure} ../_static/assets/screenshots/aurora-toolbar-ondas.png
:alt: Chaves de simulador e visualizador, botões de análise, execução rápida, cancelar, configuração de ondas e seletor de layout.
:align: center
```

Da esquerda para a direita: a chave entre **Icarus Verilog** (simulações curtas, todos os sinais visíveis) e **Verilator** (10 a 100 vezes mais rápido em simulações longas); a chave entre **GTKWave** e **Surfer** como visualizador; {guilabel}`Analisar Verilog` compila, simula e abre a forma de onda; {guilabel}`Execução rápida` roda o testbench sem gerar onda; {guilabel}`Cancelar` interrompe o que estiver rodando; {guilabel}`Configuração de ondas` escolhe os sinais gravados; e o seletor de arquivo de layout ({file}`.gtkw`) do visualizador. Quase tudo aqui exige um Testbench Top definido.

O último botão do grupo, {guilabel}`Teste do processador sintetizado`, roda o processador ativo em um teste rápido só de entrada e saída, sem forma de onda. Ele aparece em detalhe em {doc}`../sapho/simulacao`.

### Ferramentas

```{figure} ../_static/assets/screenshots/aurora-toolbar-direita.png
:alt: Botões de Controle de Versão, Bibliotecas Python, Configurações e Assistente IA.
:align: center
```

{guilabel}`Controle de Versão` abre o painel git (o badge mostra quantos arquivos mudaram); {guilabel}`Bibliotecas Python` gerencia pacotes para testbenches cocotb; {guilabel}`Configurações` abre as preferências; {guilabel}`Assistente IA` abre a Aurora Intelligence (atalho {kbd}`Ctrl+K`).

## A árvore de arquivos

```{figure} ../_static/assets/screenshots/aurora-arvore-arquivos.png
:alt: Árvore lateral na visão Arquivos, com separadores por processador.
:width: 45%
:align: center
```

A árvore tem três visões, alternadas pelo botão no seu cabeçalho:

Arquivos
: Os fontes do projeto agrupados por processador, mais os importados. É a visão de trabalho: aqui se define o Top Level e o Testbench Top pelo menu de contexto.

Pastas
: O disco como ele é, com criar, renomear, mover, copiar e excluir, arrastar e soltar, e {kbd}`Ctrl+Z` para desfazer.

Hierarquia
: A árvore de instâncias do design, disponível depois de uma sintetização Verilog. Clicar em um módulo abre o fonte na linha da definição.

O cabeçalho da árvore ainda traz: novo arquivo, atualizar, busca nos arquivos ({kbd}`Ctrl+Shift+F`), abrir a pasta no explorador, backup do projeto (gera um zip datado em {file}`Backup/`) e fechar o projeto.

## O editor

```{figure} ../_static/assets/screenshots/aurora-editor-cmm.png
:alt: Editor com um arquivo C± aberto e realce de sintaxe.
:width: 90%
:align: center
```

O editor é o Monaco, o mesmo do VS Code, com realce para C±, assembly SAPHO, Verilog, SystemVerilog e Python. Clique simples na árvore abre o arquivo em modo prévia (aba em itálico, substituída pela próxima prévia); duplo clique fixa a aba.

Três botões flutuam no painel em foco: dividir o editor (até três painéis), pré-visualizar Markdown e HTML, e formatar o arquivo ({kbd}`Shift+Alt+F`). Para Verilog, dois analisadores trabalham enquanto você digita: um sintático, que também formata, e um semântico, que elabora o projeto inteiro e aponta sinais não declarados e incompatibilidades de porta.

Selecionar um trecho de código faz aparecer uma estrela: é o acesso rápido à Aurora Intelligence sobre aquela seleção (explicar, corrigir, melhorar, comentar).

## Os terminais

```{figure} ../_static/assets/screenshots/aurora-terminais.png
:alt: Área de terminais com as seis abas e mensagens agrupadas em cards.
:width: 90%
:align: center
```

Seis abas, uma por etapa: **TCMM** (compilação C±), **TASM** (montagem e geração do Verilog), **TVERI** (validação Verilog, hierarquia, PRISM), **TWAVE** (simulação e ondas), **THTEST** (teste do processador sintetizado) e **TCMD**, que é um PowerShell de verdade dentro da AURORA.

As mensagens chegam classificadas (erro, aviso, sucesso, dica) e podem ser filtradas pelos botões com contadores. Referências como {file}`arquivo.v:15` são links: o clique abre o arquivo naquela linha. O botão de exportar salva o conteúdo de todos os terminais em um {file}`.txt`.

O TCMD merece um capítulo próprio de dicas em {doc}`../ferramentas/apoio`; por ora, dois comandos: `apython` chama o Python embarcado da AURORA, e `Use-Python aurora` faz `python` significar o embarcado naquela sessão.

```{figure} ../_static/assets/screenshots/aurora-terminal-tcmd.png
:alt: Terminal TCMD com o prompt da AURORA mostrando processador ativo, diretório e branch git.
:width: 90%
:align: center
```

## A barra de status

```{figure} ../_static/assets/screenshots/aurora-barra-status.png
:alt: Barra de status com processador ativo, top level, testbench e motor de simulação.
:align: center
```

Da esquerda para a direita: {guilabel}`Pronto` ou {guilabel}`Não Pronto` (clicável quando não há projeto: abre o diálogo de abrir); o processador ativo; o andamento da compilação; o Top Level; o Testbench Top; o motor de simulação escolhido; a posição do cursor com o controle de zoom; e a conta GitHub, que abre o painel de controle de versão.

## Paleta de comandos e busca

{kbd}`Ctrl+Shift+K` (ou {kbd}`Ctrl+Shift+P`) abre a paleta de comandos, com tudo o que os botões fazem, pesquisável pelo nome. {kbd}`Ctrl+Shift+F` abre a busca em todos os arquivos do projeto, com opções de maiúsculas, palavra inteira e expressão regular.

```{figure} ../_static/assets/screenshots/aurora-paleta-comandos.png
:alt: Paleta de comandos aberta sobre o editor.
:width: 70%
:align: center
```

Com o mapa em mãos, o próximo capítulo explica como um projeto se organiza no disco: {doc}`organizacao-projeto`.
