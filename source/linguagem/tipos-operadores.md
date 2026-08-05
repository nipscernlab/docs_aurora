# Tipos, operadores e controle

Esta página cobre o núcleo da linguagem: os quatro tipos, os operadores, as estruturas de controle, as funções e os vetores. Se você programa em C, leia com atenção especial as caixas de aviso: elas listam o que a C± não tem, e é aí que mora a maioria dos erros de compilação de quem está começando.

## Os quatro tipos

A C± tem exatamente quatro palavras-chave de tipo.

`void`
: Marca a ausência de tipo, no retorno de funções que não retornam nada.

`int`
: O inteiro de `#NUBITS` bits, em complemento de dois. É o tipo de trabalho da maior parte dos programas de instrumentação.

`float`
: O ponto flutuante no formato próprio do SAPHO, com mantissa de `#NBMANT` bits e expoente de `#NBEXPO` bits. Não segue o padrão IEEE 754; veja {doc}`../arquitetura/ponto-flutuante`.

`comp`
: O número complexo, um par de `float` com as partes real e imaginária, tratado como tipo de primeira classe da linguagem.

:::{warning} O que não existe
Não há tipo de ponto fixo separado, papel que cabe ao `float` configurável. E não existem `char`, `double`, `struct`, `union`, `enum` nem *strings*. Um literal de texto só aparece na inicialização de vetores por arquivo, mostrada adiante.
:::

### Literais complexos e o `i` reservado

Um literal complexo escreve-se como em matemática, `a+bi`:

```c
comp z;
z = 3.0 + 4.0i;
```

:::{danger} O identificador `i` é reservado
Por causa da notação acima, `i` designa a unidade imaginária, e usá-lo como nome de variável é erro de compilação. Adote `k`, `n` ou `idx` para contadores de laço.

Este é, de longe, o erro mais comum de quem chega do C, onde `for (i = 0; ...)` é reflexo muscular.
:::

### Conversões entre tipos

Misturar `int`, `float` e `comp` em uma expressão ou atribuição é permitido, mas o compilador emite avisos de conversão implícita, por exemplo ao guardar um `float` em um `int` com perda. Usar `float` ou `comp` como condição de `if` ou `while`, ou como índice de vetor, também gera aviso.

Trate esses avisos como cheiro de projeto e não como ruído: conversões explícitas e índices inteiros deixam o *hardware* gerado mais barato e o comportamento mais óbvio.

## Operadores

:::{list-table} Operadores da C±, com precedência igual à do C
:header-rows: 1
:widths: 26 74
:name: tab-operadores

* - Grupo
  - Operadores
* - Aritméticos
  - `+` &nbsp; `-` &nbsp; `*` &nbsp; `/` &nbsp; `%` (módulo, só inteiros) e o `-` unário
* - Bit a bit
  - `&` &nbsp; `|` &nbsp; `^` &nbsp; `~` (inversão)
* - Deslocamentos
  - `<<` &nbsp; `>>` &nbsp; `>>>` (à direita, preservando o sinal)
* - Relacionais
  - `<` &nbsp; `>` &nbsp; `<=` &nbsp; `>=` &nbsp; `==` &nbsp; `!=`
* - Lógicos
  - `&&` &nbsp; `||` &nbsp; `!`
* - Incremento
  - `++`, como comando ou em expressão, inclusive sobre elemento de vetor
:::

:::{warning} O que não existe
Não existem em C±: o decremento `--`; os operadores compostos `+=`, `-=`, `*=` e afins; o operador ternário `?:`; o *cast* explícito; e os ponteiros. Os símbolos `*` e `&` são apenas multiplicação e E bit a bit.

Escreva `x = x - 1;` onde escreveria `x--;`, e `x = x + 2;` onde escreveria `x += 2;`.
:::

### Operadores custam hardware

Aqui está a diferença mais importante entre escrever para o SAPHO e escrever para um processador comum.

Cada operador usado pela primeira vez no programa instancia o circuito correspondente na unidade lógica e aritmética do processador gerado. O terminal TASM anuncia cada instância durante a compilação, e o percentual final indica quanto do conjunto de instruções o seu programa efetivamente usa.

```{mermaid}
flowchart LR
  A["soma / 4"] --> B["instancia<br>o divisor inteiro"] --> C["circuito caro"]
  D["soma >> 2"] --> E["instancia<br>o deslocador"] --> F["circuito barato"]
```

Divisão e módulo são os blocos mais caros; os deslocamentos, os mais baratos. Daí o idioma do exemplo condutor, `soma >> 2` em vez de `soma / 4`. A aritmética de complexos aceita as quatro operações, cada uma expandindo para o conjunto de operações reais e imaginárias necessárias.

:::{tip}
É a primeira ocorrência de um operador que paga o bloco. A segunda em diante reaproveita o circuito. Não há economia em evitar a segunda divisão de um programa que já divide uma vez.
:::

## Estruturas de controle

Todas as estruturas clássicas do C existem, com a mesma sintaxe:

- `if` com `else`;
- `while` e `do while`;
- `for`, que o compilador reescreve internamente como um `while` equivalente;
- `switch` com `case` e `default`, incluindo o *fall-through* real do C, em que a execução continua no próximo `case` na ausência de `break`;
- `break`, `continue` e `return`, os dois primeiros válidos apenas dentro de laços.

```{code-block} c
:caption: Um saturador, exercitando if e return

int satura(int x, int lim)
{
    if (x > lim)  return lim;
    if (x < -lim) return -lim;
    return x;
}
```

## Funções

As funções seguem a sintaxe do C, `tipo nome(tipo p1, tipo p2, ...)`, com chamadas por argumentos posicionais e retorno por `return`. O número de argumentos é conferido em cada chamada, e a contagem errada é erro de compilação; conversões de tipo em parâmetros e no retorno geram aviso. A profundidade de chamadas aninhadas é limitada pela pilha de sub-rotinas, a diretiva `#SDEPTH`.

```{code-block} c
:caption: Funções com parâmetros e retorno
:linenos:

int add(int a, int b)
{
    return a + b;
}

int triple_sum(int x, int y, int z)
{
    return x + y + z;
}

void main()
{
    while (1)
    {
        int v = in(0);
        out(0, add(v, 1));
        out(0, triple_sum(v, 1, 2));
    }
}
```

:::{warning} Duas restrições que surpreendem
**Vetores não podem ser passados como parâmetro.** Trabalhe com vetores globais ou dentro do próprio `main()`.

**A recursão não é suportada no fluxo C±.** Cada variável, incluindo parâmetros e locais, vive em um endereço fixo da memória de dados, de modo que uma função que chamasse a si mesma sobrescreveria os próprios dados.
:::

Essa segunda restrição tem uma contrapartida valiosa: é justamente o endereçamento fixo que permite à AURORA mostrar cada variável pelo nome nas formas de onda. Você troca recursão por visibilidade total da simulação, o que em depuração de *hardware* costuma ser o melhor negócio. Se o algoritmo é essencialmente recursivo, o caminho C++ atende, conforme {doc}`avancado`.

## Vetores

A linguagem aceita vetores de uma e duas dimensões, com tamanho fixo, e uma forma de inicialização peculiar e muito útil:

```{code-block} c
:caption: As três formas de declarar um vetor

int  x[128];               // sem inicializacao
int  h[8]    "coefs.txt";  // inicializado por arquivo, em tempo de compilacao
int  m[8][8] "matriz.txt"; // 2D, tambem por arquivo
```

A inicialização por arquivo lê os valores de um arquivo de texto ao lado do fonte e os grava diretamente na imagem da memória de dados do processador. Os coeficientes do seu filtro já nascem na memória, sem nenhum custo de inicialização em tempo de execução.

:::{tip}
Esse mecanismo é o que torna prático embarcar modelos treinados fora do SAPHO. Uma rede neural convolucional portada para o processador, por exemplo, carrega seus milhares de pesos exatamente assim, um arquivo {file}`.txt` por camada.
:::

### As duas formas de indexação

A normal, `x[k]`, e a bit-reversa, `x[k)`, que se distingue pelo fecha-parênteses. Na segunda, o índice é lido com os bits invertidos, que é o endereçamento clássico da FFT (*Fast Fourier Transform*), com a quantidade de bits definida pela diretiva `#FFTSIZ`. Veja {doc}`avancado`.

Elementos de vetor aceitam o incremento, como em `hist[k]++;`.

## Variáveis e escopo

Declarações podem aparecer no topo do programa ou dentro de funções e blocos. Na prática, porém, todo nome vive em um endereço fixo e único da memória de dados, e declarar duas variáveis com o mesmo nome é erro.

:::{important}
Pense nas variáveis C± como registradores nomeados do seu circuito. É exatamente isso que elas se tornam, e é por isso que cada uma aparece pelo nome na forma de onda da simulação.
:::

## O próximo passo

Com tipos e controle assentados, falta a parte que conversa com o mundo: {doc}`io-biblioteca` cobre as portas, as funções intrínsecas e a notação de Dirac.
