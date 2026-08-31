# Conjunto de instruções do processador

A referência do assembly SAPHO, útil para ler o {file}`.asm` gerado e a trilha de instruções na forma de onda.

Convenções de nome: prefixo `P_` empilha o acumulador antes; `F_` opera em ponto flutuante; `S_` toma o segundo operando da pilha em vez da memória; sufixo `_M` aplica a operação na memória; sufixo `_V` é pseudo-instrução com deslocamento constante para acesso a vetores.

## Memória e pilha

| Instrução | Faz |
|---|---|
| `LOD`, `P_LOD` | carrega da memória no acumulador |
| `LDI`, `ILI` | carrega indireto (endereço = operando + índice); `ILI` inverte os bits do índice |
| `SET`, `SET_P` | grava o acumulador na memória |
| `STI`, `ISI` | grava indireto; `ISI` com índice bit-reverso |
| `PSH`, `POP` | empilha e desempilha o acumulador |
| `LDA`, `STA` | carrega e grava com endereço vindo do acumulador ou da pilha |
| `LEA` | carrega o endereço de uma variável como constante |

## Entrada e saída

| Instrução | Faz |
|---|---|
| `INN`, `P_INN` | lê a porta de entrada indicada |
| `F_INN`, `PF_INN` | lê convertendo para float |
| `OUT` | escreve o acumulador na porta de saída |

## Controle de fluxo

| Instrução | Faz |
|---|---|
| `JMP` | salto incondicional |
| `JIZ` | salta se o acumulador é zero (palavra inteira) |
| `CAL`, `RET` | chamada e retorno de sub-rotina |
| `NOP` | nada |

## Aritmética

| Grupo | Instruções |
|---|---|
| soma e subtração | `ADD`, `S_ADD`, `F_ADD`, `SF_ADD`, `F_SU1`, `F_SU2`, `SF_SU1`, `SF_SU2` |
| multiplicação | `MLT`, `S_MLT`, `F_MLT`, `SF_MLT` |
| divisão e resto | `DIV`, `S_DIV`, `F_DIV`, `SF_DIV`, `MOD`, `S_MOD` |
| negação e absoluto | `NEG`, `F_NEG`, `ABS`, `F_ABS` e variantes `_M` |
| saturação e escala | `PST`, `F_PST`, `NRM` (divide pelo `#NUGAIN`) e variantes |
| conversão | `I2F`, `F2I` (trunca em direção a zero) e variantes |
| sinal | `SGN`, `S_SGN`, `F_SGN`, `SF_SGN` |

## Lógica, bits e comparações

| Grupo | Instruções |
|---|---|
| bit a bit | `AND`, `ORR`, `XOR`, `INV` e variantes |
| lógicos | `LAN`, `LOR`, `LIN` e variantes |
| deslocamentos | `SHL`, `SHR` (lógico), `SRS` (aritmético) e variantes `S_` |
| comparações | `LES` e `GRE` nas formas inteira, float e de pilha; `EQU` só nas formas inteira e de pilha, porque igualdade exata de ponto flutuante não merece bloco próprio; resultado 0 ou 1 |

## Cirurgia de expoente

Usadas pelas rotinas matemáticas para operar direto no campo de expoente do float:

| Instrução | Faz |
|---|---|
| `F_ROT` | aproxima a raiz quadrada pela potência de dois mais próxima (semente de Newton) |
| `F_SCL`, `SF_SCL` | multiplica por $2^k$ somando no expoente |
| `XPO`, `XPO_M` | extrai $\lfloor \log_2 \lvert x \rvert \rfloor$ como inteiro |

São 108 opcodes ao todo. O mecanismo que sintetiza apenas os usados está descrito em {doc}`../avancado/modulos-hdl`.
