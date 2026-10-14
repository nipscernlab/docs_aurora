# Compilação e artefatos

O botão {guilabel}`Compilar C±` esconde o YANC, o compilador do SAPHO. A AURORA chama um programa só, o `yanc`, em duas etapas, e ele chama os compiladores que estão ao lado dele. Conhecer a cadeia ajuda a ler os terminais e a saber onde procurar cada arquivo gerado.

## A cadeia

```{mermaid}
flowchart LR
  CMM[".cmm"] -->|"cmmcomp"| ASM[".asm"]
  CPP[".cpp"] -->|"cppcomp"| ASM
  ASM -->|"asmcomp"| OUT[".v  +  .mif  +  testbench"]
```

cmmcomp
: O compilador do C±: traduz o programa em assembly do processador SAPHO, resolve variáveis e expressões, aplica otimizações e anexa as rotinas de biblioteca usadas. Escreve no terminal **TCMM**.

cppcomp
: O compilador do C++, a outra linguagem do SAPHO: aceita um subconjunto de C++ com classes, `for`, referências e parte da biblioteca padrão, e produz o mesmo {file}`.asm`. Ele mesmo resolve `#include` e `#define`, e as mensagens de erro apontam o arquivo e a linha que você escreveu, inclusive dentro de um header. Os parâmetros do processador entram por `#pragma yanc` em vez das diretivas `#`; sem pragmas, o processador nasce com 32 bits e ponto flutuante IEEE 754 de precisão simples. Também escreve no **TCMM**.

asmcomp
: O montador e gerador de hardware. Uma primeira passada conta instruções e dados e resolve os endereços dos rótulos; a segunda produz as imagens de memória, o módulo Verilog do processador e o testbench. Escreve no terminal **TASM**, incluindo os avisos de recurso instanciado e a estimativa de ocupação do conjunto de instruções.

Qual dos dois compiladores roda, a AURORA decide pela extensão do fonte: o mesmo botão compila um {file}`.cmm` e um {file}`.cpp`, e o Processor Hub cria processadores nas duas linguagens.

As mensagens saem no idioma escolhido nas configurações da AURORA, português ou inglês. As do cppcomp saem sempre em inglês, e o terminal avisa disso uma vez. O que cada ferramenta faz, as opções da linha de comando e o que cada mensagem quer dizer estão no [manual do YANC](https://www.nipscern.com/library/yanc/command-line.html).

## O que cada compilação gera

Para um processador chamado `media_movel`, tudo vai para a pasta de saída, {file}`media_movel/media_movel/`:

| Arquivo | O que é |
|---|---|
| {file}`media_movel.asm` | o assembly gerado, legível; vale abrir e comparar com o seu C± |
| {file}`media_movel.v` | o processador em Verilog, pronto para simulação e síntese |
| {file}`media_movel_inst.mif` | a imagem da memória de programa, uma instrução binária por linha |
| {file}`media_movel_data.mif` | a imagem da memória de dados, com variáveis e constantes |
| {file}`media_movel_tb.v` | o testbench gerado, com clock, reset e a leitura e escrita das portas |
| {file}`prog_log.txt`, {file}`src_lines.txt`, {file}`pc_media_movel_mem.txt`, {file}`trad_opcode.txt`, {file}`app_log.txt` | as tabelas que a forma de onda usa para mostrar o assembly e a linha do fonte |

O nome de tudo vem do nome do arquivo fonte: {file}`media_movel.cmm` gera o processador `media_movel` e o módulo Verilog `media_movel`.

O {file}`.v` e os dois {file}`.mif` são exatamente o que se leva ao Quartus ou ao Vivado na hora de gravar o FPGA, como descreve {doc}`../juntos/fpga`.

:::{note}
O testbench gerado lê os {file}`input_N.txt` da pasta do processador, um nível acima, e grava as saídas na pasta de saída. Ele roda com a pasta de saída como diretório de trabalho, e a AURORA cuida disso. Um testbench seu fica onde você o pôs e nunca é sobrescrito.
:::

:::{warning}
Um arquivo presente na pasta de saída não prova que a última compilação passou: pode ser sobra de uma tentativa anterior. A prova é o terminal, com as duas etapas terminando sem erro.
:::

## Um programa, um processador sob medida

A parte mais importante de toda a cadeia acontece em silêncio no asmcomp: o módulo Verilog gerado liga apenas os blocos de hardware que o seu programa usa. Cada instrução que o assembly contém vira um parâmetro ligado na instância do processador; cada instrução ausente deixa o bloco correspondente fora da síntese.

Por isso o TASM anuncia os recursos instanciados: aquela lista é literalmente o inventário do seu circuito. Um programa só de inteiros não carrega somador de ponto flutuante; um programa sem divisão não carrega divisor. O tamanho do processador acompanha o algoritmo, e é isso que torna o SAPHO um soft-core otimizado. O mecanismo por dentro está em {doc}`../avancado/modulos-hdl`.

## Cada clique fica registrado

Todo botão de compilação grava uma execução: o que foi pedido, quando, quanto durou, que ferramentas rodaram e como terminou, junto com um retrato do projeto naquele momento (Top Level, testbench, simulador, visualizador, processadores e fontes). O botão do relógio na barra dos terminais ({kbd}`Ctrl+Shift+H`) abre o {guilabel}`Histórico de compilações`, que lista as execuções e se atualiza enquanto uma compilação acontece: a execução viva aparece no topo, com os passos e o tempo crescendo.

```{figure} ../_static/assets/screenshots/aurora-historico-compilacoes.png
:alt: Modal do histórico de compilações com uma execução aberta.
:width: 95%
:align: center

Uma execução aberta: o estado do projeto na hora e a cadeia de ferramentas que rodou, com a duração de cada passo.
```

Serve para responder o que o terminal sozinho não responde: o que exatamente foi clicado antes de dar errado, com que Top Level, em que ordem. Os registros ficam no próprio projeto, em {file}`.aurora/execucoes/`, um JSON por execução. Duas compilações ao mesmo tempo geram dois registros; um passo que não dá para atribuir com certeza a uma delas sai marcado como sobreposto, e não como erro.

## Lendo erros de compilação

- As mensagens do cmmcomp apontam a linha do {file}`.cmm`, e as do cppcomp, o arquivo e a linha (inclusive de um header); nos dois casos a referência é um link clicável no terminal.
- Vá sempre à primeira mensagem: as seguintes costumam ser consequência dela.
- Constantes `float` aproximadas geram um aviso com o erro de representação. Não é defeito: é o formato de ponto flutuante escolhido, e {doc}`../avancado/ponto-flutuante` explica como dimensioná-lo.

As mensagens mais comuns, com causas e correções, estão em {doc}`../referencia/diagnostico`.
