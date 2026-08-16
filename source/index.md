# SAPHO & AURORA, manual de uso

<div class="hero">
<span class="version-pill">Versão documentada: 6.4.2</span>

Este manual ensina a usar o processador SAPHO e a AURORA, a interface onde ele é criado: instalar, criar um projeto, gerar um processador sob medida, escrever o algoritmo em C±, compilar, simular e olhar o circuito por dentro. Nenhum conhecimento prévio da plataforma é assumido. Alguma familiaridade com a linguagem C e com a ideia geral de circuitos digitais torna a leitura mais confortável, mas não é pré-requisito.

<div class="hero-actions">

{{ pdf_button }}

</div>
</div>

:::{note}
Este manual descreve a AURORA 6.4.2 para Windows 10 e 11. Para a versão exata, o commit e o método usado na apuração, veja {doc}`sobre/escopo`.
:::

## Por onde começar

Se esta é a sua primeira vez, siga a trilha na ordem: conheça {doc}`a AURORA e seus fluxos <fluxos/index>`, entenda {doc}`o que é o SAPHO <inicio/o-que-e>`, {doc}`instale <inicio/instalacao>`, {doc}`conheça a janela <inicio/tour-interface>` e faça o {doc}`primeiro projeto <inicio/primeiro-projeto>`, um filtro de média móvel construído do começo ao fim. São cerca de trinta minutos até ver o seu próprio processador rodando na forma de onda.

Se você já tem um projeto em andamento, use o menu lateral para ir direto à tarefa. As páginas de referência reúnem diretivas, biblioteca, atalhos e sintomas de falha para consulta rápida, sem repetir o tutorial.

### Comece aqui

::::{grid} 1 2 2 3
:gutter: 3

:::{grid-item-card} Conheça a AURORA e os fluxos
:link: fluxos/index
:link-type: doc

Entenda o papel da AURORA e escolha entre o fluxo Verilog e o fluxo SAPHO.
:::

:::{grid-item-card} Instalação e primeiro início
:link: inicio/instalacao
:link-type: doc

Baixe, instale e abra a AURORA pela primeira vez no Windows.
:::

:::{grid-item-card} Tour pela interface
:link: inicio/tour-interface
:link-type: doc

Localize a barra de ferramentas, a árvore, o editor, os terminais e a barra de status.
:::

::::

### Escolha seu fluxo

::::{grid} 1 2 2 2
:gutter: 3

:::{grid-item-card} Fluxo Verilog
:link: fluxos/verilog
:link-type: doc

Crie ou importe RTL, defina o Top Level, simule e analise o circuito sem gerar um processador.
:::

:::{grid-item-card} Fluxo SAPHO
:link: inicio/primeiro-projeto
:link-type: doc

Comece pelo primeiro projeto e percorra da criação do processador à forma de onda.
:::

::::

### Consulte por tarefa

::::{grid} 1 2 2 3
:gutter: 3

:::{grid-item-card} Projetos e arquivos
:link: uso/projetos
:link-type: doc

Crie, abra, organize e preserve os arquivos de um projeto da AURORA.
:::

:::{grid-item-card} Linguagem C±
:link: linguagem/index
:link-type: doc

Consulte tipos, operadores, diretivas, entrada, saída e recursos da linguagem.
:::

:::{grid-item-card} Processador SAPHO
:link: arquitetura/processador
:link-type: doc

Entenda a arquitetura gerada e o efeito de cada parâmetro do processador.
:::

:::{grid-item-card} Simulação e análise
:link: fluxos/simulacao
:link-type: doc

Escolha Icarus, Verilator ou cocotb e siga para formas de onda e PRISM.
:::

:::{grid-item-card} Aurora Intelligence
:link: ia/visao-geral
:link-type: doc

Configure a assistente e conheça as ações disponíveis sobre o projeto.
:::

:::{grid-item-card} Solução de problemas
:link: referencia/diagnostico
:link-type: doc

Diagnostique falhas de projeto, compilação, simulação, PRISM e IA.
:::

::::

## As ferramentas que você vai usar

A AURORA não substitui as ferramentas consagradas de projeto digital: ela as reúne e as aciona por você. Todas acompanham a instalação, e nenhuma exige licença.

:::{raw} html
<div class="tool-strip">
  <figure><img src="_static/assets/icons/sapho_aurora_icon.svg" alt="AURORA"><figcaption>AURORA<br>a IDE</figcaption></figure>
  <figure><img src="_static/assets/icons/yanc.svg" alt="YANC"><figcaption>YANC<br>compiladores</figcaption></figure>
  <figure><img src="_static/assets/icons/Icarus_Verilog_logo.png" alt="Icarus Verilog"><figcaption>Icarus<br>simulação</figcaption></figure>
  <figure><img src="_static/assets/icons/Verilator_logo.png" alt="Verilator"><figcaption>Verilator<br>simulação rápida</figcaption></figure>
  <figure><img src="_static/assets/icons/gtkwave.svg" alt="GTKWave"><figcaption>GTKWave<br>formas de onda</figcaption></figure>
  <figure><img src="_static/assets/icons/surfer.svg" alt="Surfer"><figcaption>Surfer<br>formas de onda</figcaption></figure>
  <figure><img src="_static/assets/icons/yosys.svg" alt="Yosys"><figcaption>Yosys<br>síntese</figcaption></figure>
  <figure><img src="_static/assets/icons/aurora_prism.svg" alt="PRISM"><figcaption>PRISM<br>visualizador RTL</figcaption></figure>
  <figure><img src="_static/assets/icons/python.svg" alt="cocotb"><figcaption>cocotb<br>testes em Python</figcaption></figure>
</div>
:::

## O caminho completo, em um diagrama

O percurso abaixo é o mesmo em todo projeto SAPHO, e este manual o segue nessa ordem. Você escreve apenas o bloco à esquerda; a AURORA cuida do resto.

```{mermaid}
flowchart LR
  CMM["Algoritmo C±<br>(.cmm)"] --> YANC["Cadeia YANC<br>cmmcomp · appcomp · asmcomp"]
  YANC --> HW["Processador em Verilog<br>+ memórias .mif"]
  YANC --> TB["Testbench gerado"]
  HW --> SIM["Simulação<br>Icarus ou Verilator"]
  TB --> SIM
  SIM --> WAVE["Formas de onda<br>GTKWave ou Surfer"]
  HW --> PRISM["Diagrama RTL<br>PRISM"]
  HW --> FPGA["Síntese em FPGA<br>fora da AURORA"]
```

A única etapa que acontece fora da AURORA é a última: levar o Verilog e as imagens de memória à ferramenta do fabricante do FPGA, como o Quartus ou o Vivado, para a gravação física.

```{toctree}
:maxdepth: 2
:caption: Primeiros passos

Conheça a AURORA e os fluxos <fluxos/index>
inicio/o-que-e
inicio/instalacao
inicio/tour-interface
```

```{toctree}
:maxdepth: 2
:caption: Projetos e ferramentas

uso/projetos
uso/editor
uso/terminais
uso/source-control
```

```{toctree}
:maxdepth: 2
:caption: Fluxo Verilog

fluxos/verilog
uso/arquivos-verilog
```

```{toctree}
:maxdepth: 2
:caption: Fluxo SAPHO

fluxos/processador-sapho
inicio/primeiro-projeto
uso/processadores
fluxos/compilacao
```

```{toctree}
:maxdepth: 2
:caption: A linguagem C±

linguagem/index
linguagem/diretivas
linguagem/tipos-operadores
linguagem/io-biblioteca
linguagem/avancado
```

```{toctree}
:maxdepth: 2
:caption: O processador SAPHO

arquitetura/processador
arquitetura/ponto-flutuante
arquitetura/instrucoes
```

```{toctree}
:maxdepth: 2
:caption: Simular e analisar

fluxos/simulacao
exemplos/galeria-testbenches
fluxos/ondas
fluxos/prism
```

```{toctree}
:maxdepth: 2
:caption: Aurora Intelligence

ia/visao-geral
ia/provedores
ia/ferramentas
ia/mcp-cli
```

```{toctree}
:maxdepth: 2
:caption: Configuração e ajuda

configuracao/preferencias
referencia/diretivas
referencia/biblioteca
referencia/formatos
referencia/atalhos
referencia/diagnostico
```

```{toctree}
:maxdepth: 1
:caption: Apêndices

glossario
sobre/ecossistema
sobre/escopo
```
