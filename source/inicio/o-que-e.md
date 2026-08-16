# O que é o SAPHO

SAPHO (*Scalable-Architecture Processor for Hardware Optimization*) é uma plataforma para criar processadores dedicados em FPGA. Você descreve um algoritmo em uma linguagem parecida com C, e a plataforma gera um processador em Verilog dimensionado para aquele algoritmo: com a largura de palavra que você escolheu e apenas os blocos de hardware que o programa realmente usa.

A plataforma também serve para o caminho inverso: escrever Verilog à mão, validar, simular e visualizar, tudo na mesma janela. É assim que este manual começa.

## As peças

::::{grid} 1 2 2 2
:gutter: 3

:::{grid-item-card}
<img class="sd-card-img-top" src="../_static/assets/icons/sapho_aurora_icon.svg" alt="AURORA">
AURORA
^^^
A IDE. O programa que você instala e abre. Nela vivem o editor, o gerenciador de projetos, os botões de compilação e simulação, os terminais e os visualizadores. É a única interface gráfica da plataforma.
:::

:::{grid-item-card}
<img class="sd-card-img-top" src="../_static/assets/icons/yanc.svg" alt="YANC">
YANC
^^^
A suíte de compiladores que trabalha por baixo. Traduz o programa C± no processador em Verilog, nas imagens de memória e no testbench. Você nunca a chama diretamente.
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
O dialeto de C no qual você escreve o algoritmo. Arquivos com extensão {file}`.cmm`. A versão essencial está no capítulo {doc}`../sapho/linguagem`; os recursos de pós-graduação, nos {doc}`estudos avançados <../avancado/ponto-flutuante>`.
:::

::::

Em volta desse núcleo, a instalação traz as ferramentas de apoio, todas de código aberto: Icarus Verilog e Verilator para simulação, GTKWave e Surfer para formas de onda, Yosys para análise estrutural, PRISM para visualizar o circuito, cocotb para testes em Python.

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
