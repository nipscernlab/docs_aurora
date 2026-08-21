# Compilação e artefatos

O botão {guilabel}`Compilar C±` esconde uma cadeia de três compiladores. Conhecê-la ajuda a ler os terminais e a saber onde procurar cada arquivo gerado.

## A cadeia

```{mermaid}
flowchart LR
  CMM[".cmm"] -->|"cmmcomp"| ASM[".asm"]
  ASM -->|"appcomp"| PRE["endereços e<br>tamanhos resolvidos"]
  PRE -->|"asmcomp"| OUT[".v  +  .mif  +  testbench"]
```

cmmcomp
: O compilador da linguagem: traduz o C± em assembly do processador SAPHO, resolve variáveis e expressões, aplica otimizações e anexa as rotinas de biblioteca usadas. Escreve no terminal **TCMM**.

appcomp
: Uma pré-passagem sobre o assembly: conta instruções e dados e resolve os endereços de rótulos, informações de que o montador precisa antes de emitir a primeira palavra.

asmcomp
: O montador e gerador de hardware: produz as imagens de memória, o módulo Verilog do processador e o testbench. Escreve no terminal **TASM**, incluindo os avisos de recurso instanciado e a estimativa de ocupação do conjunto de instruções.

Os três falam o idioma escolhido nas configurações da AURORA, português ou inglês.

## O que cada compilação gera

Para um processador chamado `media_movel`:

| Arquivo | Onde | O que é |
|---|---|---|
| {file}`media_movel.asm` | {file}`Software/` | o assembly gerado, legível; vale abrir e comparar com o seu C± |
| {file}`media_movel.v` | {file}`Hardware/` | o processador em Verilog, pronto para simulação e síntese |
| {file}`media_movel_inst.mif` | {file}`Hardware/` | a imagem da memória de programa, uma instrução binária por linha |
| {file}`media_movel_data.mif` | {file}`Hardware/` | a imagem da memória de dados, com variáveis e constantes |
| {file}`media_movel_tb.v` | {file}`Simulation/` | o testbench gerado, com clock, reset e a leitura e escrita das portas |

O {file}`.v` e os dois {file}`.mif` são exatamente o que se leva ao Quartus ou ao Vivado na hora de gravar o FPGA, como descreve {doc}`../juntos/fpga`.

:::{note}
O testbench gerado só é copiado para {file}`Simulation/` se você ainda não tiver um testbench próprio para o processador. O seu nunca é sobrescrito.
:::

:::{warning}
Um arquivo presente em {file}`Hardware/` não prova que a última compilação passou: pode ser sobra de uma tentativa anterior. A prova é o terminal, com as duas etapas terminando sem erro.
:::

## Um programa, um processador sob medida

A parte mais importante de toda a cadeia acontece em silêncio no asmcomp: o módulo Verilog gerado liga apenas os blocos de hardware que o seu programa usa. Cada instrução que o assembly contém vira um parâmetro ligado na instância do processador; cada instrução ausente deixa o bloco correspondente fora da síntese.

Por isso o TASM anuncia os recursos instanciados: aquela lista é literalmente o inventário do seu circuito. Um programa só de inteiros não carrega somador de ponto flutuante; um programa sem divisão não carrega divisor. O tamanho do processador acompanha o algoritmo, e é isso que torna o SAPHO um soft-core otimizado. O mecanismo por dentro está em {doc}`../avancado/modulos-hdl`.

## Lendo erros de compilação

- As mensagens do cmmcomp apontam a linha do {file}`.cmm`; a referência é um link clicável no terminal.
- Vá sempre à primeira mensagem: as seguintes costumam ser consequência dela.
- Constantes `float` aproximadas geram um aviso com o erro de representação. Não é defeito: é o formato de ponto flutuante escolhido, e {doc}`../avancado/ponto-flutuante` explica como dimensioná-lo.

As mensagens mais comuns, com causas e correções, estão em {doc}`../referencia/diagnostico`.
