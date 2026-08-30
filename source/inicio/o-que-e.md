# O que é o SAPHO

SAPHO (*Scalable-Architecture Processor for Hardware Optimization*) é uma plataforma para criar processadores dedicados em FPGA. Você descreve um algoritmo em uma linguagem parecida com C, e a plataforma gera um processador em Verilog dimensionado para aquele algoritmo: com a largura de palavra que você escolheu e apenas os blocos de hardware que o programa realmente usa.

A plataforma também serve para o caminho inverso: escrever Verilog à mão, validar, simular e visualizar, tudo na mesma janela. É assim que este manual começa.

## De onde ela vem

O SAPHO nasceu no NIPS-CERN, o Núcleo de Instrumentação e Processamento de Sinais da UFJF, que mantém desde 2001 uma colaboração com o CERN, o laboratório europeu de física de partículas, em Genebra. Lá, no experimento ATLAS do LHC, o calorímetro de telhas (TileCal) mede a energia das partículas produzidas nas colisões, e a eletrônica que lê esses sinais precisa de processamento em tempo real, dentro do FPGA, com resposta em poucos ciclos de relógio.

Foi esse problema que deu forma à plataforma. Um processador SAPHO comanda hoje o simulador de pulsos usado nas bancadas de teste da eletrônica do TileCal, e a linguagem C± carrega as marcas dessa origem: aritmética de ponto flutuante com formato escolhido por você, números complexos como tipo nativo, notação de Dirac para produtos internos, índice com bits invertidos para FFT. São recursos de processamento de sinais e de física, não de programação de propósito geral.

A mesma plataforma é a base da disciplina de Dispositivos Lógicos Programáveis na UFJF, onde cada estudante projeta, compila e simula um processador próprio.

## As peças

::::{grid} 1 2 2 2
:gutter: 3

:::{grid-item-card}
<img class="sd-card-img-top" src="../_static/assets/icons/sapho_aurora_icon.svg" alt="AURORA">
AURORA
^^^
A IDE. O programa que você instala e abre. Nela vivem o editor, o gerenciador de projetos, os botões de compilação e simulação, os terminais e os visualizadores. Tudo passa por ela: os compiladores e as ferramentas de apoio rodam por baixo, chamados pelos seus botões, e você não precisa de linha de comando para nada do fluxo.
:::

:::{grid-item-card}
<img class="sd-card-img-top" src="../_static/assets/icons/yanc.svg" alt="YANC">
YANC
^^^
O conjunto de compiladores que trabalha por baixo. O YANC traduz o programa C± no processador em Verilog, nas imagens de memória e no testbench. Você nunca o chama diretamente.
:::

:::{grid-item-card}
<img class="sd-card-img-top" src="../_static/assets/icons/sapho.svg" alt="Processador SAPHO">
O processador SAPHO
^^^
O circuito que o YANC emite: acumulador único, arquitetura Harvard, pipeline de três estágios. Só os blocos que o seu programa usa são sintetizados.
:::

:::{grid-item-card}
<img class="sd-card-img-top" src="../_static/assets/icons/cmm_file.svg" alt="Arquivo C±">
A linguagem C±
^^^
Um subconjunto de C, de médio nível, com adições voltadas a processamento de sinais e física. Arquivos com extensão {file}`.cmm`. A versão essencial está no capítulo {doc}`../sapho/linguagem`; os recursos de pós-graduação, nos {doc}`estudos avançados <../avancado/ponto-flutuante>`.
:::

::::

## As ferramentas que vêm juntas

Em volta desse núcleo trabalha um conjunto de ferramentas de código aberto, cada uma consagrada no que faz. Você não precisa instalar, configurar nem chamar nenhuma delas por fora: a AURORA baixa as versões certas pelo painel de Componentes ({doc}`../diaadia/apoio`) e as aciona pelos botões.

| Ferramenta | Para que serve |
|---|---|
| **Icarus Verilog** | Simulador Verilog interpretado, o mais fiel ao padrão. É o motor padrão da AURORA: enxerga todos os sinais internos e gera o {file}`.vcd` completo. Mais lento em simulações longas. |
| **Verilator** | Compila o Verilog para C++ e roda muito mais rápido, ao custo de só aceitar código sintetizável e de expor menos sinais. É a escolha para varreduras longas e para testes automatizados. |
| **GTKWave** | Visualizador de formas de onda clássico, o padrão de fato no mundo Verilog. Abre o {file}`.vcd`, guarda layouts em {file}`.gtkw` e é onde as trilhas de assembly e de linha C± aparecem. |
| **Surfer** | Visualizador de ondas moderno, escrito em Rust, com navegação mais fluida. A AURORA traz um fork nosso, integrado ao projeto, que abre como uma aba dentro do próprio editor. |
| **Yosys** | Ferramenta de síntese lógica. Aqui ela não gera bitstream: elabora o projeto, resolve a hierarquia e produz a estrutura que o PRISM desenha. |
| **PRISM** | Visualizador de RTL da casa. Transforma a saída do Yosys em um diagrama navegável do circuito, com um clique para descer na hierarquia e outro para voltar ao código-fonte. No modo Simular, o diagrama vira um circuito vivo, com relógio e entradas clicáveis. |
| **cocotb** | Biblioteca que permite escrever testbenches em Python em vez de Verilog, com `async`/`await`. Roda sobre o Icarus ou o Verilator. |
| **Pylibs** | O gerenciador de bibliotecas Python da AURORA. Um catálogo curado de bibliotecas para testbenches e análise — cocotb, verificação UVM, leitura de ondas por script, gráficos —, instaláveis com um clique no Python embarcado, sem mexer no Python do sistema. |

## O caminho completo

```{mermaid}
flowchart LR
  V["Verilog escrito à mão"] --> RTL["Projeto RTL"]
  CMM["Algoritmo C± (.cmm)"] --> YANC["YANC"]
  YANC --> RTL
  RTL --> SIM["Simulação<br>Icarus ou Verilator"]
  SIM --> WAVE["Formas de onda<br>GTKWave ou Surfer"]
  RTL --> PRISM["Diagrama RTL<br>PRISM"]
  RTL --> FPGA["Síntese em FPGA<br>Quartus ou Vivado"]
```

A única etapa fora da AURORA é a última: levar o Verilog e as imagens de memória à ferramenta do fabricante do FPGA para a gravação física. A AURORA valida, simula e desenha o circuito, mas não gera bitstream.

## Como este manual está organizado

O manual segue a ordem de uma disciplina: primeiro o fluxo Verilog puro (Parte II), depois a criação de processadores em C± (Parte III), depois os dois juntos no mesmo projeto (Parte IV). A Parte V reúne os estudos avançados, voltados à pós-graduação: ponto flutuante configurável, números complexos, notação de Dirac, FFT e a arquitetura interna do processador.

:::{seealso}
A arquitetura e os resultados em FPGA estão no artigo da plataforma, [SAPHO: An FPGA Customizable Implementation (IEEE, 2026)](https://cdn.nipscern.com/publications/ieee-2026-soft-core-processors.pdf). Mais leituras em {doc}`../publicacoes`.
:::

Se esta é a sua primeira vez, siga em frente: {doc}`instalacao`.
