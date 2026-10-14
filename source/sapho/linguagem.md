# C± em uma página

C± é um dialeto de C reduzido ao que faz sentido virar hardware. Esta página traz o mínimo para seguir os tutoriais e ler os exemplos do manual. A referência completa da linguagem, das diretivas, da biblioteca e das instruções está no [manual do YANC](https://www.nipscern.com/library/yanc/), o compilador do SAPHO, escrito junto com ele e atualizado a cada versão.

## Tipos e variáveis

`int` é inteiro com sinal, na largura de `#NUBITS`; `float` é o ponto flutuante do processador, no formato de `#NBMANT` e `#NBEXPO`; `comp` é um número complexo. Não existem `char`, `double`, `bool`, `struct`, ponteiros nem strings. O identificador `i` é a unidade imaginária: usá-lo como nome de variável não compila.

```cmm
int a, b;
float ganho = 0.5;
int v[128];                     // vetor
float M[4][4];                  // matriz (ate 2 dimensoes)
int tabela[64] "valores.txt";   // inicializado por arquivo, um valor por linha
```

Toda memória é estática: cada variável tem endereço fixo, e é por isso que ela aparece pelo nome na forma de onda.

Detalhes: [tipos](https://www.nipscern.com/library/yanc/language-cmm.html#types), [variáveis e vetores](https://www.nipscern.com/library/yanc/language-cmm.html#variables-and-arrays), [complexos](https://www.nipscern.com/library/yanc/language-cmm.html#complex-numbers).

## Operadores, controle e funções

Os operadores de C, menos `--`, os compostos (`+=` e família), o ternário, o cast e o `sizeof`. `>>>` é o deslocamento que preserva o sinal. `if`, `while`, `do while`, `for`, `switch`, `break`, `continue` e `return` funcionam como em C. `main()` é obrigatória; funções recebem até nove parâmetros por valor, não aceitam vetor como parâmetro e não podem ser recursivas.

:::{tip}
Deslocamentos substituem multiplicações e divisões por potências de dois: `x >> 2` no lugar de `x / 4`. A diferença não é estilo: `/` instancia um divisor no circuito, `>>` quase nada. O PRISM mostra isso ao vivo.
:::

Detalhes: [operadores](https://www.nipscern.com/library/yanc/language-cmm.html#operators), [controle de fluxo](https://www.nipscern.com/library/yanc/language-cmm.html#control-flow), [funções](https://www.nipscern.com/library/yanc/language-cmm.html#functions), [o que não existe](https://www.nipscern.com/library/yanc/language-cmm.html#what-does-not-exist).

## Entrada e saída

O processador conversa com o mundo por portas numeradas, em número definido por `#NUIOIN` e `#NUIOOU`:

```cmm
int  a = in(0);      // le um inteiro da porta 0
float g = fin(1);    // le da porta 1 convertendo para float
out(0, a + 1);       // escreve na porta de saida 0
fout(0, g);          // escreve mantendo o formato float
```

O número da porta é um literal. Na simulação do processador sozinho, cada porta de entrada lê de {file}`input_N.txt`, ao lado do fonte, e cada saída grava em {file}`output_N.txt`, na pasta de saída.

## Links entre processadores

Dois processadores de um mesmo projeto trocam valores por links numerados: `toma(k, x)` entrega `x` pelo link `k` e espera o outro lado pegar; `cade(k)` e `fcade(k)` esperam um valor e o recebem como `int` ou `float`. Simulado sozinho, o processador lê os valores de cada `cade(k)` de {file}`cade_k.txt`, ao lado do fonte, e grava cada `toma(k, x)` em {file}`toma_k.txt`, na pasta de saída.

Os pinos que cada link cria, como ligá-los no top level e as formas `_sync`: [links no manual do YANC](https://www.nipscern.com/library/yanc/multiprocessor.html#links-toma-and-cade).

## Diretivas

O bloco no topo do arquivo configura o processador. O nome do processador não é diretiva: é o nome do arquivo. O Hub escreve sempre estas cinco:

| Diretiva | Configura |
|---|---|
| `#NUBITS` | largura da palavra |
| `#NBMANT`, `#NBEXPO` | formato do ponto flutuante |
| `#NUIOIN`, `#NUIOOU` | portas de entrada e de saída |

`#NUBITS` deve ser igual a `#NBMANT + #NBEXPO + 1`. Faltar uma diretiva não dá erro: o processador nasce com o padrão do compilador. As pilhas o compilador calcula pelo programa.

Todas as diretivas, com os padrões: [diretivas no manual do YANC](https://www.nipscern.com/library/yanc/directives.html).

## Biblioteca

As funções embutidas vão das baratas, que viram uma ou poucas instruções (`abs`, `pset`, `sign`, `norm`), às matemáticas, que viram rotinas anexadas ao programa (`sqrt`, `sin`, `exp`, `log`...). Cada uma usada aparece no relatório do TASM.

A lista completa, com o custo de cada uma: [biblioteca no manual do YANC](https://www.nipscern.com/library/yanc/library.html).

## C++

O mesmo processador também se programa em C++, com classes, referências e parte da biblioteca padrão; os parâmetros entram por `#pragma yanc`. O que o compilador aceita: [o C++ do YANC](https://www.nipscern.com/library/yanc/language-cpp.html).
