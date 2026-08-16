# Biblioteca do C±

Todas as funções embutidas da linguagem. "T" indica que a função aceita `int` ou `float` e devolve o mesmo tipo.

## Entrada e saída

| Função | Devolve | Faz |
|---|---|---|
| `in(p)` | `int` | lê a porta de entrada `p` |
| `fin(p)` | `float` | lê a porta `p` convertendo para float |
| `out(p, e)` | nada | escreve `e` na porta de saída `p` (float é convertido para int, com aviso) |
| `fout(p, e)` | nada | escreve mantendo o formato float |

O número da porta é sempre um literal inteiro, validado contra `#NUIOIN` e `#NUIOOU`.

## Funções baratas

Mapeiam em uma ou poucas instruções.

| Função | Devolve | Faz |
|---|---|---|
| `abs(x)` | T (ou `float` para `comp`) | valor absoluto; para complexo, o módulo |
| `pset(x)` | T | `x` se positivo, senão 0 |
| `sign(x, y)` | T | `y` com o sinal de `x` |
| `norm(x)` | `int` | divide pelo `#NUGAIN` sem instanciar divisor; só `int` |
| `copy(x, id)` | nada | copia `x` na variável `id` sem checagem de tipo |

## Funções matemáticas

Implementadas como rotinas anexadas ao programa quando usadas; cada uma aparece no relatório do TASM.

| Função | Aceita `comp`? |
|---|---|
| `sqrt(x)` | sim |
| `sin(x)`, `cos(x)`, `tan(x)`, `atan(x)` | sim |
| `exp(x)`, `log(x)` | sim |
| `pow(x, y)` | não |
| `sinh(x)`, `cosh(x)`, `tanh(x)` | não |
| `floor(x)`, `ceil(x)`, `round(x)` | não |

Todas devolvem `float` (ou `comp` nas versões complexas). O método por trás delas está publicado em [Implementação de Funções Não-Lineares em Processador Soft-Core (ENMC, 2025)](https://cdn.nipscern.com/publications/enemc-2025-implementacao-de-funcoes.pdf).

## Funções de números complexos

| Função | Devolve | Faz |
|---|---|---|
| `real(z)` | `float` | parte real |
| `imag(z)` | `float` | parte imaginária |
| `mod2(z)` | `float` | módulo ao quadrado |
| `fase(z)` | `float` | fase em radianos, quatro quadrantes |
| `complex(a, b)` | `comp` | monta `a + bi` de dois floats |
| `conj(z)` | `comp` | conjugado; um real vira `x + 0i` |

## Operações vetoriais (notação de Dirac)

A tabela completa das formas `⟨a|b⟩`, `a # |M|b⟩` e demais está em {doc}`../avancado/dirac`. Restrições gerais: dimensões constantes, tipos iguais dos dois lados, sem `comp`.
