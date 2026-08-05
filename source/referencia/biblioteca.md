# Referência da biblioteca padrão

Todas as funções intrínsecas da C±, agrupadas por família. Erros de tipo são apontados na compilação; as restrições de cada grupo estão explicadas em {doc}`../linguagem/io-biblioteca`.

## Entrada e saída

:::{list-table}
:header-rows: 1
:widths: 22 16 62

* - Função
  - Tipos
  - Descrição
* - `in(p)`
  - `int`
  - Lê a porta de entrada `p`
* - `fin(p)`
  - `float`
  - Lê a porta `p` convertendo para `float`
* - `out(p, x);`
  - qualquer
  - Escreve `x` na porta de saída `p`
* - `fout(p, x);`
  - `float`
  - Escreve em formato `float`
:::

## Funções especiais

Existem para economizar *hardware*, cada uma evitando um bloco caro da ULA ou uma sequência de instruções.

:::{list-table}
:header-rows: 1
:widths: 22 20 58

* - Função
  - Tipos
  - Descrição
* - `norm(x)`
  - `int`
  - Divide pelo valor de `#NUGAIN` sem instanciar o divisor
* - `pset(x)`
  - `int`, `float`
  - Devolve $x$ se não negativo; caso contrário, zero
* - `abs(x)`
  - todos
  - Valor absoluto; magnitude para `comp`
* - `sign(x, y)`
  - `int`, `float`
  - Devolve $y$ com o sinal de $x$
* - `copy(x, y);`
  - todos
  - Cópia bit a bit, sem checagem de tipo
:::

## Não lineares e arredondamento

Custam instruções e ciclos, não blocos de ULA. São macros de *assembly* otimizadas injetadas no programa quando usadas.

:::{list-table}
:header-rows: 1
:widths: 32 68

* - Função
  - Descrição
* - `sqrt(x)`
  - Raiz quadrada, pelo método de Newton. Não aceita `comp`
* - `sin(x)`, `cos(x)`, `tan(x)`
  - Trigonométricas
* - `atan(x)`
  - Arco-tangente
* - `sinh(x)`, `cosh(x)`, `tanh(x)`
  - Hiperbólicas
* - `exp(x)`, `log(x)`
  - Exponencial e logaritmo natural. Não aceitam `comp`
* - `pow(x, y)`
  - Potência. A estratégia depende do expoente
* - `floor(x)`, `ceil(x)`, `round(x)`
  - Arredondamentos. Retornam `float`, e o `round` afasta o meio do zero
:::

## Complexos

:::{list-table}
:header-rows: 1
:widths: 32 68

* - Função
  - Descrição
* - `real(z)`, `imag(z)`
  - Partes real e imaginária
* - `fase(z)`
  - Argumento, ou ângulo
* - `mod2(z)`
  - Magnitude ao quadrado
* - `complex(re, im)`
  - Constrói um `comp`
* - `conj(z)`
  - Conjugado
:::

:::{warning}
`sqrt`, `exp`, `log`, `pow`, `sign` e `pset` sobre complexos são erro de compilação, assim como o incremento `z++`. O módulo `%` e a `norm()` são exclusivos de inteiros.
:::

## Notação de Dirac

:::{list-table}
:header-rows: 1
:widths: 32 68

* - Sintaxe
  - Operação
* - `<a|b>`
  - Produto interno, usado como expressão
* - `a # |0>;`
  - Zera o vetor
* - `a # |M|b>;`
  - Matriz vezes vetor
* - `a # c|b>;`
  - Vetor escalado
* - `A # |a><b|;`
  - Produto externo
* - `out(p, c|a>);`
  - Emite o vetor escalado pela porta `p`
:::

## Operadores

:::{list-table}
:header-rows: 1
:widths: 26 74

* - Grupo
  - Operadores
* - Aritméticos
  - `+` &nbsp; `-` &nbsp; `*` &nbsp; `/` &nbsp; `%` (só inteiros) e o `-` unário
* - Bit a bit
  - `&` &nbsp; `|` &nbsp; `^` &nbsp; `~`
* - Deslocamentos
  - `<<` &nbsp; `>>` &nbsp; `>>>`
* - Relacionais
  - `<` &nbsp; `>` &nbsp; `<=` &nbsp; `>=` &nbsp; `==` &nbsp; `!=`
* - Lógicos
  - `&&` &nbsp; `||` &nbsp; `!`
* - Incremento
  - `++`
:::

:::{warning} Ausentes na linguagem
`--`, os operadores compostos (`+=`, `-=`, `*=` e afins), o ternário `?:`, o *cast* explícito e os ponteiros.
:::

## Palavras-chave

`void`, `int`, `float`, `comp`, `if`, `else`, `while`, `do`, `for`, `switch`, `case`, `default`, `break`, `continue`, `return`.

O identificador `i` é reservado para a unidade imaginária e não pode nomear variáveis.
