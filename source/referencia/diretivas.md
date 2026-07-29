# Referência de diretivas

Consulta rápida das diretivas da linguagem C±. Para o raciocínio por trás de cada escolha, veja {doc}`../linguagem/diretivas`.

## Diretivas de configuração

Uma por linha, no topo do {file}`.cmm`, sem ponto e vírgula. A coluna do padrão indica o valor assumido pela cadeia de ferramentas quando a diretiva é omitida; o Hub de Processadores escreve todas explicitamente.

:::{list-table}
:header-rows: 1
:widths: 16 16 10 58

* - Diretiva
  - Argumento
  - Padrão
  - Efeito
* - `#PRNAME`
  - nome
  -
  - Nome do processador. Deve casar com o nome no projeto e nos artefatos
* - `#NUBITS`
  - inteiro
  - 23
  - Largura da palavra da ULA e dos inteiros, em complemento de dois. Deve valer a soma de mantissa, expoente e um
* - `#NBMANT`
  - inteiro
  - 16
  - Bits de mantissa do ponto flutuante próprio
* - `#NBEXPO`
  - inteiro
  - 6
  - Bits de expoente, em complemento de dois
* - `#NDSTAC`
  - inteiro
  - 10
  - Profundidade da pilha de dados
* - `#SDEPTH`
  - inteiro
  - 10
  - Profundidade da pilha de sub-rotinas
* - `#NUIOIN`
  - inteiro
  - 1
  - Número de portas de entrada. `in(p)` exige `p` menor que esse valor
* - `#NUIOOU`
  - inteiro
  - 1
  - Número de portas de saída. A mesma regra vale para `out`
* - `#NUGAIN`
  - potência de 2
  - 64
  - Divisor fixo da função `norm()`
* - `#FFTSIZ`
  - inteiro
  - 8
  - Bits invertidos no endereçamento bit-reverso `x[k)`, para FFT de $2^n$ pontos
:::

Com uma única porta a ligação é direta. Com mais de uma, o *hardware* instancia automaticamente um decodificador de endereços.

## Diretivas comportamentais

Aparecem no corpo do programa, marcando pontos do código.

`#PRACA`
: Marca o ponto para onde o processador desvia quando o pino de interrupção `itr` pulsa.

`#TOAQUI`
: Marca um endereço do programa cujo alcance faz pulsar o pino `cheguei`. É também o mecanismo que a AURORA usa para detectar o fim do programa em testes e simulações.

## Pré-processador

A construção `#define NOME corpo` define uma constante simbólica, apenas na forma de objeto, sem argumentos, com o limite de 256 por programa.

Não há `#include` nem `#ifdef` no fluxo C±. O fluxo C++ tem pré-processador completo, conforme {doc}`../linguagem/avancado`.

## A restrição estrutural

$$\texttt{NUBITS} = \texttt{NBMANT} + \texttt{NBEXPO} + 1$$

Combinações válidas de uso frequente:

:::{list-table}
:header-rows: 1
:widths: 20 20 20 40

* - `#NUBITS`
  - `#NBMANT`
  - `#NBEXPO`
  - Perfil
* - 16
  - 10
  - 5
  - Compacto, cerca de 3 dígitos decimais
* - 23
  - 16
  - 6
  - Padrão de fábrica
* - 32
  - 23
  - 8
  - Equivalente à precisão simples do IEEE 754
:::
