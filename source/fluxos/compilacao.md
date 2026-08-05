# Compilação: de C± a Verilog

Compilar, no SAPHO, não é gerar um executável: é gerar um circuito. Esta página explica o que acontece quando cada botão de compilação é acionado, quais arquivos aparecem no projeto e como ler o que os terminais informam.

## O pipeline do YANC em três estágios

Todo clique em {guilabel}`Compilar C±` executa, por processador, uma cadeia de três compiladores.

```{mermaid}
flowchart LR
  A[".cmm<br><small>o seu programa</small>"] -->|cmmcomp| B[".asm<br><small>assembly simbólico</small>"]
  B -->|appcomp| C["parâmetros e<br>endereços resolvidos"]
  C -->|asmcomp| D[".v<br><small>processador</small>"]
  C --> E[".mif<br><small>memórias</small>"]
  C --> F["_tb.v<br><small>testbench</small>"]
```

`cmmcomp`
: Traduz o {file}`<proc>.cmm` em *assembly* simbólico, o {file}`<proc>.asm`, junto com os registros e as tabelas que ligam cada instrução à linha do fonte. É dele que vêm as trilhas sincronizadas das formas de onda.

`appcomp`
: Faz a primeira passada sobre o *assembly*, coletando os parâmetros do processador e resolvendo os endereços de variáveis e rótulos.

`asmcomp`
: Na segunda passada, gera o processador em Verilog, as duas imagens de memória e o *testbench*.

O terminal **TCMM** mostra a saída do primeiro estágio. O **TASM** mostra a dos outros dois, incluindo os avisos de recurso instanciado que revelam o custo em *hardware* do seu código.

:::{note}
O processador gerado instancia os moldes de HDL do SAPHO que acompanham a instalação: o núcleo, a unidade lógica e aritmética, as memórias.

O programa não é um arquivo carregado depois. As imagens {file}`.mif` nascem embutidas no projeto de *hardware*, e reprogramar significa recompilar e sintetizar de novo. Essa é uma diferença central em relação a um microcontrolador comum.
:::

## Os botões de compilação

:::{list-table}
:header-rows: 1
:widths: 30 70
:name: tab-botoes-compilacao

* - Botão
  - O que faz
* - {guilabel}`Compilar C±`
  - Roda o *pipeline* completo, do fonte ao Verilog, memórias e *testbench*
* - {guilabel}`Sintetizar Verilog`
  - Verifica os arquivos Verilog com o Icarus, apontando erros de sintaxe e elaboração no TVERI, com linhas clicáveis
* - {guilabel}`Analisar Verilog (forma de onda)`
  - Percorre o fluxo completo até as ondas: compila o que for preciso, simula e abre o visualizador
* - {guilabel}`Execução rápida`
  - Simula sem gravar ondas, quando só interessam as saídas em arquivo
* - {guilabel}`Abrir PRISM`
  - Sintetiza com o Yosys e abre o diagrama de RTL. Exige *top-level* definido
* - {guilabel}`Teste do processador sintetizado`
  - Constrói um *harness* em C++ com o Verilator e exercita apenas as portas, como caixa-preta
* - {guilabel}`Cancelar`
  - Interrompe todos os processos em andamento, sem fechar a IDE
:::

O botão {guilabel}`Iniciar Compilação`, o raio da barra de status, é um atalho para o fluxo principal. Todos esses comandos também existem na paleta ({kbd}`Ctrl+Shift+P`), no grupo de compilação.

## Antes de clicar

A AURORA salva os arquivos automaticamente antes de compilar, mas vale conferir três coisas na barra de status:

1. o processador ativo é o que você quer compilar, o que depende do arquivo em foco no editor;
2. o *top-level* está definido, se a ação exige síntese;
3. o *testbench* está definido, se a ação exige simulação.

A barra de status avisa o que falta com os rótulos "Sem top-level" e "Sem testbench".

## Onde cada artefato aparece

Depois de compilar o `media_movel` do exemplo condutor, o projeto ganha esta forma:

```text
media_movel/
├── Software/
│   ├── media_movel.cmm        o seu fonte
│   ├── media_movel.asm        assembly gerado
│   └── pc_media_movel_mem.txt tabela PC -> linha, usada nas ondas
├── Hardware/
│   ├── media_movel.v          o processador em Verilog
│   ├── media_movel_inst.mif   imagem da memória de programa
│   └── media_movel_data.mif   imagem da memória de dados
└── Simulation/
    └── media_movel_tb.v       testbench gerado
```

O {file}`.v` e os {file}`.mif` da pasta {file}`Hardware` são exatamente o que se leva ao Quartus ou ao Vivado na hora de sintetizar para o FPGA real.

O *testbench* gerado produz *clock* e *reset*, alimenta o processador com os estímulos de {file}`input_<i>.txt`, um valor por linha e um arquivo por porta de entrada, e grava as saídas em {file}`output_<i>.txt`, além do despejo de ondas.

:::{warning}
A existência de um arquivo em {file}`Hardware` não prova que a compilação atual passou: ele pode ser de uma tentativa anterior. Confirme sempre nos terminais que as etapas terminaram sem erro.
:::

## Validar um projeto Verilog

No fluxo Verilog puro, não há C± nem processador. A etapa equivalente é a validação:

1. adicione todas as fontes sintetizáveis necessárias ao projeto;
2. defina o *top-level* pelo menu de contexto da árvore;
3. clique em {guilabel}`Sintetizar Verilog`;
4. leia o terminal **TVERI**.

A validação está correta quando termina sem erros de sintaxe, módulos ausentes ou módulos duplicados. Ela não executa o comportamento do circuito: confirma que o *top-level* e suas dependências formam um conjunto coerente para as etapas posteriores.

Se falhar, corrija a primeira mensagem de erro e execute de novo. Um único módulo ausente costuma produzir várias mensagens secundárias.

## Ações que preparam as suas dependências

As ações abaixo compilam automaticamente o que precisam, o que evita a sequência manual:

:::{list-table}
:header-rows: 1
:widths: 40 60

* - Ação
  - O que ela prepara sozinha
* - {guilabel}`Compilar C±`
  - Atualiza o *hardware* do processador ativo
* - {guilabel}`Analisar Verilog (forma de onda)`
  - Compila, simula e abre o visualizador
* - {guilabel}`Execução rápida`
  - Compila e simula, sem visualizador
* - {guilabel}`Abrir PRISM`
  - Valida o RTL e gera o diagrama
:::

Executar uma ação mais completa não elimina a necessidade de ler os terminais. {guilabel}`Analisar Verilog (forma de onda)` pode recompilar dependências e ainda assim falhar antes da simulação, se o Verilog estiver inválido.

## Interromper uma execução

Clique em {guilabel}`Cancelar`. A interrupção pode levar alguns segundos enquanto processos auxiliares são encerrados. Não feche nem exclua arquivos temporários nesse período.

Depois que o cancelamento terminar, revise a última mensagem do terminal. Se uma nova execução permanecer bloqueada, feche a ferramenta externa que ainda estiver aberta, como uma janela do GTKWave, e tente novamente.

## Uma decisão de segurança

A AURORA só executa binários da própria cadeia de ferramentas, validados contra uma lista fechada, e os botões não passam por um *shell*. É por isso que a IDE não oferece a execução de comandos arbitrários fora do terminal TCMD.

## Erros comuns

:::{list-table}
:header-rows: 1
:widths: 38 62

* - Sintoma
  - Causa e solução
* - {guilabel}`Compilar C±` desabilitado
  - Abra o {file}`.cmm` do processador desejado e confirme o nome na barra de status
* - *Top-level* não encontrado
  - Confirme o módulo principal e inclua todas as dependências Verilog como fontes sintetizáveis
* - Módulo duplicado
  - Remova da seleção uma das cópias que declaram o mesmo módulo
* - O arquivo gerado não mudou
  - Salve o {file}`.cmm`, confirme o processador ativo e compile de novo
* - Erro de sintaxe no TCMM
  - Clique na linha para ir ao ponto. Confira as ausências da linguagem em {doc}`../linguagem/tipos-operadores`
* - Porta de entrada ou saída inexistente
  - O índice em `in()` ou `out()` excede as diretivas de porta. Aumente `#NUIOIN` ou `#NUIOOU`
* - Binário do simulador não encontrado
  - A pasta {file}`components` da instalação está incompleta ou foi movida. Reinstale pelo instalador oficial
* - A execução não termina
  - Use {guilabel}`Cancelar` e aguarde a limpeza. Se persistir, veja {doc}`../referencia/diagnostico`
:::

## Leitura relacionada

- {doc}`../uso/terminais` explica quem escreve em cada aba e como ler os avisos de recurso instanciado.
- {doc}`../linguagem/avancado` mostra o custo em área de cada construção.
- {doc}`simulacao` assume daqui, com os motores e os tipos de *testbench*.
