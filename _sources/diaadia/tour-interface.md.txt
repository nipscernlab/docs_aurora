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

Da esquerda para a direita: as chaves de simulador (Icarus ou Verilator) e de visualizador (GTKWave ou Surfer); {guilabel}`Analisar Verilog`, que simula e abre a onda; {guilabel}`Execução rápida`, sem onda; {guilabel}`Cancelar`; a {guilabel}`Configuração de ondas`; o seletor de layout; e o {guilabel}`Teste do processador sintetizado`. As escolhas deste grupo estão explicadas em {doc}`../verilog/ondas` e {doc}`../sapho/simulacao`.

### Ferramentas

```{figure} ../_static/assets/screenshots/aurora-toolbar-direita.png
:alt: Botões de Controle de Versão, Bibliotecas Python, Configurações e Assistente IA.
:align: center
```

{guilabel}`Controle de Versão` abre o painel git (o badge mostra quantos arquivos mudaram); {guilabel}`Bibliotecas Python` gerencia pacotes para testbenches cocotb; {guilabel}`Configurações` abre as preferências; {guilabel}`Assistente IA` abre a Aurora Intelligence (atalho {kbd}`Ctrl+K`).

## A árvore de arquivos

```{list-table}
:widths: 33 33 33
:align: center

* - **Arquivos**

    ```{image} ../_static/assets/screenshots/aurora-arvore-arquivos.png
    :alt: Árvore lateral na visão Arquivos, com separadores por processador.
    :width: 100%
    ```
  - **Pastas**

    ```{image} ../_static/assets/screenshots/aurora-arvore-pastas.png
    :alt: Árvore lateral na visão Pastas, com a estrutura do projeto expandida.
    :width: 100%
    ```
  - **Hierarquia**

    ```{image} ../_static/assets/screenshots/aurora-arvore-hierarquia.png
    :alt: Árvore lateral na visão Hierarquia, com as instâncias do design sintetizado.
    :width: 100%
    ```
```

A árvore tem três visões, alternadas pelo botão no seu cabeçalho:

Arquivos
: Os fontes do projeto agrupados por processador, mais os importados. É a visão de trabalho: aqui se define o Top Level e o Testbench Top pelo menu de contexto.

Pastas
: O disco como ele é, com criar, renomear, mover, copiar e excluir, arrastar e soltar, e {kbd}`Ctrl+Z` para desfazer. A seleção é múltipla: {kbd}`Ctrl` soma e tira, {kbd}`Shift` pega o intervalo, {kbd}`Ctrl+A` marca o que está visível. Renomear ou mover um arquivo referenciado pelo projeto atualiza o {file}`.spf` no mesmo gesto, e renomear um arquivo aberto devolve o cursor e a rolagem ao mesmo ponto.

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

```{figure} ../_static/assets/screenshots/aurora-editor-split.png
:alt: Editor dividido, com o fonte C± a esquerda e o Verilog gerado a direita.
:width: 100%
:align: center

O uso mais proveitoso da divisão: o {file}`.cmm` de um lado e o {file}`.v` que o YANC gerou dele do outro, com a instância do `processor` e seus parâmetros à vista.
```

Três botões flutuam no painel em foco: dividir o editor (até três painéis), pré-visualizar Markdown e HTML, e formatar o arquivo ({kbd}`Shift+Alt+F`). Para Verilog, dois analisadores trabalham enquanto você digita: um sintático, que também formata, e um semântico, que elabora o projeto inteiro e aponta sinais não declarados e incompatibilidades de porta.

Selecionar um trecho de código faz aparecer uma estrela: é o acesso rápido à Aurora Intelligence sobre aquela seleção (explicar, corrigir, melhorar, comentar).

## Os terminais

```{figure} ../_static/assets/screenshots/aurora-terminais.png
:alt: Área de terminais com as sete abas e mensagens agrupadas em cards.
:width: 90%
:align: center
```

Sete abas, uma por etapa: **TCMM** (compilação C±), **TASM** (montagem e geração do Verilog), **TVERI** (validação Verilog e hierarquia), **TWAVE** (simulação e ondas), **THTEST** (teste do processador sintetizado), **TPRISM** (a síntese do esquemático do PRISM) e **TCMD**, que é um PowerShell de verdade dentro da AURORA.

As mensagens chegam classificadas (erro, aviso, sucesso, dica) e podem ser filtradas pelos botões com contadores. Toda referência de linha que uma ferramenta imprime vira link, no formato de cada uma: o caminho com linha do Icarus, o caminho com linha e coluna do Verilator, o `Erro na linha N` do compilador C± e o traceback do cocotb; o clique abre o arquivo naquele ponto. O botão de limpar vale para o terminal aberto ou, no modo todos, para todos de uma vez; o de exportar salva o conteúdo de todos os terminais em um {file}`.txt`; e o do relógio abre o {guilabel}`Histórico de compilações`, descrito em {doc}`../sapho/compilacao`.

Três gentilezas evitam a rolagem infinita: qualquer contador que sobe — do simulador, do cocotb ou de um `$display` seu no testbench — vira uma barra de progresso em vez de uma linha por atualização; uma linha repetida em sequência vira um contador `xN` na própria linha; e, durante uma simulação, um marcador no TWAVE mostra o arquivo de onda crescendo ao vivo e congela no tamanho final quando ela termina (o mouse em cima revela o caminho do arquivo). Quando uma mensagem cita um componente que ainda não foi baixado, a linha ganha o botão {guilabel}`Abrir Componentes`.

O TCMD não é um console de mentira nem um espelho de saída: é o seu próprio shell, um PowerShell de verdade rodando na máquina, com as suas variáveis de ambiente, o seu histórico e as suas permissões. Vale ali tudo o que valeria na janela do sistema: `git`, `pip`, um script seu, navegar até outra pasta. A AURORA só acrescenta o contexto do projeto ao prompt (processador ativo, diretório, branch) e alguns comandos próprios.

Por ora, dois deles: `apython` chama o Python embarcado da AURORA, e `Use-Python aurora` faz `python` significar o embarcado naquela sessão. O TCMD merece um capítulo próprio de dicas em {doc}`apoio`.

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

Da esquerda para a direita: {guilabel}`Pronto` ou {guilabel}`Não Pronto` (clicável quando não há projeto: abre o diálogo de abrir); o processador ativo; o andamento da compilação; o Top Level; o Testbench Top; o motor de simulação escolhido; a posição do cursor com o controle de zoom; e as fichas das contas GitHub e GitLab, apagadas quando desconectadas, que abrem o painel de controle de versão. Num laptop entra ainda um indicador de energia: verde na tomada, vermelho na bateria — na bateria o Windows reduz o clock da CPU e a simulação demora mais, e o clique no indicador explica e leva às configurações de energia do Windows.

## Paleta de comandos e busca

Um detalhe que economiza tempo: quase todo modal traz um ponto de interrogação ao lado do X, que abre o capítulo deste manual sobre aquela tela, sem sair da AURORA ({doc}`apoio`).

{kbd}`Ctrl+Shift+K` (ou {kbd}`Ctrl+Shift+P`) abre a paleta de comandos, com tudo o que os botões fazem, pesquisável pelo nome. {kbd}`Ctrl+Shift+F` abre a busca em todos os arquivos do projeto, com opções de maiúsculas, palavra inteira e expressão regular.

```{figure} ../_static/assets/screenshots/aurora-paleta-comandos.png
:alt: Paleta de comandos aberta sobre o editor.
:width: 70%
:align: center
```

```{figure} ../_static/assets/screenshots/aurora-busca-arquivos.png
:alt: Modal de busca nos arquivos, com os resultados agrupados por arquivo.
:width: 100%
:align: center

A busca varre o projeto inteiro e agrupa por arquivo, com a contagem de ocorrências de cada um. O clique numa linha abre o arquivo naquele ponto.
```

Com o mapa em mãos, o próximo capítulo explica como um projeto se organiza no disco: {doc}`organizacao-projeto`.
