# A linguagem C±: fundamentos

A C± (lê-se "C mais-menos"; nos arquivos, extensão {file}`.cmm`) é a linguagem principal do SAPHO. É um dialeto de C criado pelo NIPS-CERN, enxuto o bastante para virar *hardware* eficiente e expressivo o bastante para algoritmos de processamento de sinais, com números complexos como tipo nativo e álgebra linear em notação de Dirac.

Se você já programa em C, vai se sentir em casa em cinco minutos. O que exige atenção não é o que a linguagem tem, e sim o que ela deliberadamente não tem: cada ausência corresponde a um bloco de *hardware* que não precisa ser gerado.

:::{note}
Tudo nesta seção foi extraído da gramática oficial do compilador, nos arquivos `CMMComp.y` e `CMMComp.l` do repositório `nipscernlab/yanc`. Quando o manual diz que algo não existe na linguagem, é porque não existe na gramática, e o compilador rejeitará o código.
:::

## A estrutura de um programa

Um programa C± é uma sequência de três tipos de elemento, em qualquer ordem:

Diretivas
: Linhas iniciadas por `#`, que configuram o *hardware* do processador. Detalhadas em {doc}`diretivas`.

Declarações de variáveis globais
: Nomes que ocupam endereços fixos na memória de dados.

Funções
: Incluindo a obrigatória `void main()`, que é o ponto de entrada. A ausência dela encerra a compilação com erro.

A forma canônica coloca as diretivas no topo e, em seguida, o `main()` com um laço infinito. O programa modela um circuito, e circuitos não terminam: eles processam amostras para sempre.

```{code-block} c
:caption: A forma canônica de um programa SAPHO
:linenos:

#PRNAME media_movel
#NUBITS 16
#NDSTAC 4
#SDEPTH 2
#NUIOIN 1
#NUIOOU 1
#NBMANT 10
#NBEXPO 5

void main()
{
    int x[4];    // historico das ultimas 4 amostras
    int soma;

    while (1)
    {
        x[3] = x[2];          // desloca o historico
        x[2] = x[1];
        x[1] = x[0];
        x[0] = in(0);         // le nova amostra da porta 0

        soma = x[0] + x[1] + x[2] + x[3];
        out(0, soma >> 2);    // media = soma/4, sem usar divisor
    }
}
```

Esse é o `media_movel`, o processador construído no {doc}`../inicio/primeiro-projeto` e usado como exemplo ao longo do manual.

## O que ler primeiro

::::{grid} 1 2 2 2
:gutter: 3

:::{grid-item-card} Diretivas
:link: diretivas
:link-type: doc

As linhas com `#` que definem a arquitetura: largura da palavra, formato do ponto flutuante, pilhas e portas.
:::

:::{grid-item-card} Tipos, operadores e controle
:link: tipos-operadores
:link-type: doc

Os quatro tipos, os operadores disponíveis, as estruturas de controle, funções e vetores.
:::

:::{grid-item-card} Entrada, saída e biblioteca
:link: io-biblioteca
:link-type: doc

As portas, as funções intrínsecas, as não lineares, os complexos e a notação de Dirac.
:::

:::{grid-item-card} Recursos avançados
:link: avancado
:link-type: doc

Interrupção, sincronização com o *hardware*, FFT, custo de cada construção e o caminho C++.
:::

::::

## Um resumo de uma página

Se você conhece C e quer apenas o essencial antes de escrever o primeiro programa, esta tabela basta.

:::{list-table}
:header-rows: 1
:widths: 26 74

* - Assunto
  - Em uma linha
* - Tipos
  - Apenas `void`, `int`, `float` e `comp` (complexo). Não há `char`, `double`, `struct` nem *strings*
* - Ponto flutuante
  - Formato próprio, não IEEE 754, com mantissa e expoente que você escolhe
* - Operadores ausentes
  - Sem `--`, sem `+=` e afins, sem ternário `?:`, sem *cast* explícito, sem ponteiros
* - Controle
  - `if`, `else`, `while`, `do while`, `for`, `switch` com *fall-through*, `break`, `continue`, `return`
* - Funções
  - Sintaxe do C, sem recursão e sem passar vetores como parâmetro
* - Vetores
  - Uma ou duas dimensões, tamanho fixo, inicializáveis por arquivo de texto
* - Entrada e saída
  - Só pelas portas: `in()`, `fin()`, `out()`, `fout()`
* - Identificador reservado
  - `i` é a unidade imaginária; use `k`, `n` ou `idx` para contadores
* - Pré-processador
  - Apenas `#define` de objeto, sem argumentos, sem `#include` e sem `#ifdef`
* - Comentários
  - `//` até o fim da linha e `/* ... */` em bloco, como em C
:::

## Onde o arquivo vive

Dentro de um projeto AURORA, o código de cada processador fica em {file}`<projeto>/<processador>/Software/<processador>.cmm`. A compilação gera o *assembly* na mesma pasta {file}`Software`, o Verilog e as imagens de memória em {file}`Hardware` e o *testbench* em {file}`Simulation`, conforme {doc}`../fluxos/compilacao`.

O nome do arquivo e a diretiva `#PRNAME` precisam concordar: é assim que a cadeia de ferramentas conecta o fonte aos artefatos. Renomeie sempre pela AURORA, que mantém os dois lados em sincronia.

## Constantes com `#define`

A C± tem um pré-processador mínimo embutido. A construção `#define NOME corpo` define uma constante simbólica, expandida onde o nome aparecer.

```{code-block} c
:caption: Constantes simbólicas

#define SCALE  3
#define OFFSET 7

void main()
{
    int x;
    while (1)
    {
        x = in(0);
        x = x + SCALE;
        out(0, x);
        x = x + OFFSET;
        out(0, x);
    }
}
```

Três limitações distinguem esse pré-processador do C tradicional:

- só existem *defines* de objeto, de modo que macros com argumentos, como `#define DOBRO(x) ((x)*2)`, não são aceitas;
- não há `#include` nem `#ifdef` no lado C±, embora o fluxo C++ tenha pré-processador completo, conforme {doc}`avancado`;
- o limite é de 256 *defines* por programa.

O editor da AURORA reconhece os seus `#define` e os colore como constantes conforme você digita.

## E se eu precisar do que a C± não tem

Existe uma saída. O YANC também compila C++ para o mesmo processador, por uma cadeia paralela que oferece ponteiros, recursão e `struct`. O preço é a visibilidade nas formas de onda. A decisão está detalhada em {ref}`o caminho C++ <linguagem/avancado:O caminho C++>`.

A recomendação prática do laboratório é começar todo projeto em C± e migrar apenas quando o algoritmo exigir especificamente um desses recursos.
