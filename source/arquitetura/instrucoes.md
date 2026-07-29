# O conjunto de instruções

Você nunca vai escrever *assembly* do SAPHO à mão: o compilador o gera. Mas você vai lê-lo, e com frequência, porque a AURORA exibe nas formas de onda o mnemônico executado a cada ciclo de *clock*, em sincronia com a linha do seu código C±.

Esta página existe para que essa trilha faça sentido.

## Como o conjunto é organizado

O conjunto usa *opcode* de 7 bits, com famílias de carga e armazenamento, pilha, entrada e saída, controle de fluxo e cálculo. Nem todas as instruções existem em um processador dado: o montador liga apenas os *opcodes* que o programa emprega, e o *hardware* das demais é eliminado na geração do circuito.

Ao final de cada compilação, o terminal TASM resume o percentual do conjunto de instruções e da unidade lógica e aritmética efetivamente usados pelo programa.

## Convenções de prefixo e sufixo

Antes da tabela, decore estas cinco marcas. Elas explicam a maioria dos mnemônicos que você vai ver.

:::{list-table}
:header-rows: 1
:widths: 18 82

* - Marca
  - Significado
* - `F_`
  - Versão em ponto flutuante da operação
* - `S_` e `SF_`
  - O operando vem da pilha de dados
* - `P_`
  - Há empilhamento prévio
* - `_M`
  - A operação atua sobre memória
* - `_V`
  - Variante indexada, para acesso a vetores
:::

Assim, `F_ADD` é uma soma em ponto flutuante, `S_ADD` é uma soma cujo segundo operando vem da pilha, e `LOD_V` é uma carga indexada.

## As famílias

:::{list-table} Famílias de instruções e mnemônicos principais
:header-rows: 1
:widths: 30 70
:name: tab-familias

* - Família
  - Mnemônicos principais
* - Carga e armazenamento
  - `LOD`, `SET`, `LDI`, `STI`, `ILI`, `ISI`
* - Pilha
  - `PSH`, `POP`
* - Entrada e saída
  - `INN`, `F_INN`, `OUT`
* - Controle de fluxo
  - `JMP`, `JIZ`, `CAL`, `RET`, `NOP`
* - Aritmética inteira
  - `ADD`, `MLT`, `DIV`, `MOD`, `NEG`, `ABS`, `SGN`, `PST`, `NRM`
* - Aritmética em ponto flutuante
  - `F_ADD`, `F_SU1`, `F_SU2`, `F_MLT`, `F_DIV`, `F_NEG`, `F_ABS`, `F_ROT`, `F_SCL`, `XPO`
* - Conversões
  - `I2F`, `F2I`
* - Lógica e bits
  - `AND`, `ORR`, `XOR`, `INV`, `LAN`, `LOR`, `LIN`
* - Comparações
  - `LES`, `GRE`, `EQU`, e as versões com prefixo `F_`
* - Deslocamentos
  - `SHL`, `SHR`, `SRS`, este último correspondendo ao operador `>>>`
:::

Cada mnemônico usado pela primeira vez liga o bloco de *hardware* correspondente no processador gerado. É por isso que o custo em área do circuito é proporcional ao subconjunto da linguagem que o programa emprega, como detalhado em {doc}`../linguagem/avancado`.

## Lendo a trilha na forma de onda

A AURORA gera, a cada compilação, duas tabelas de tradução: uma que liga cada endereço do contador de programa ao mnemônico *assembly*, e outra que liga esse endereço à linha do fonte C±. Elas viram trilhas de texto no visualizador de ondas.

```{mermaid}
flowchart TD
  CMM["Linha do .cmm<br><small>soma = x[0] + x[1] + ...</small>"]
  ASM["Instruções assembly<br><small>LOD, ADD, ADD, ADD, SET</small>"]
  CIC["Ciclos de clock<br><small>um por instrução</small>"]
  ONDA["Trilhas sincronizadas<br>na forma de onda"]
  CMM -->|cmmcomp| ASM -->|um ciclo cada| CIC --> ONDA
  CMM -.->|tabela PC → linha| ONDA
```

Na prática, ao percorrer a onda com o cursor você lê três coisas ao mesmo tempo: o valor de cada variável, a instrução que está executando e a linha do seu programa que a gerou. É o vínculo mais direto entre código e circuito que a plataforma oferece, e a razão pela qual o fluxo C± preserva o endereçamento fixo de variáveis.

:::{tip}
Se uma variável tem um valor inesperado, posicione o cursor no ciclo anterior à mudança e leia o mnemônico. Na maioria dos casos a instrução responsável está ali, e a linha C± correspondente aparece na trilha logo abaixo.
:::

## Uma leitura comentada

Considere a linha do exemplo condutor:

```c
soma = x[0] + x[1] + x[2] + x[3];
```

O compilador a traduz para uma sequência que carrega o primeiro elemento no acumulador e soma os demais um a um, terminando com o armazenamento em `soma`. Nas ondas, você verá algo próximo de `LOD`, `ADD`, `ADD`, `ADD`, `SET`, um por ciclo, com o acumulador crescendo a cada passo e a variável `soma` mudando apenas no último.

Esse é o comportamento típico de uma máquina de acumulador, e explica por que expressões longas consomem mais ciclos que o mesmo cálculo repartido: cada operando extra é um acesso a mais à memória de dados.

## Leitura relacionada

- {doc}`processador` descreve o caminho de dados no qual essas instruções executam.
- {doc}`ponto-flutuante` explica o formato manipulado pelos *opcodes* com prefixo `F_`.
- {doc}`../fluxos/ondas` mostra como as trilhas são preparadas e exibidas em cada visualizador.
