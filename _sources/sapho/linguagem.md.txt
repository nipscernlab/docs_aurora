# A linguagem C± essencial

C± é um dialeto de C reduzido ao que faz sentido virar hardware. Se você conhece C, aprende C± em uma tarde, e a leitura mais útil é a das ausências: elas existem porque cada construção da linguagem precisa mapear em circuito de tamanho conhecido em tempo de compilação.

Este capítulo cobre o essencial para a graduação. Complexos, notação de Dirac e os detalhes do ponto flutuante estão nos {doc}`estudos avançados <../avancado/complexos>`.

## Tipos

| Tipo | O que é |
|---|---|
| `int` | inteiro com sinal, largura definida por `#NUBITS` |
| `float` | ponto flutuante customizado, formato definido por `#NBMANT` e `#NBEXPO` |
| `comp` | número complexo (dois floats); assunto de {doc}`../avancado/complexos` |
| `void` | apenas como retorno de função |

Não existem `char`, `double`, `unsigned`, `bool`, `struct`, ponteiros nem strings. O identificador `i` é reservado para a parte imaginária dos complexos; não o use como variável.

## Variáveis e vetores

```cmm
int a, b;
float ganho = 0.5;
int v[128];                     // vetor
float M[4][4];                  // matriz (ate 2 dimensoes)
int tabela[64] "valores.txt";   // inicializado por arquivo, um valor por linha
```

Toda memória é estática: sem `malloc`, sem ponteiro, cada variável tem endereço fixo. É isso que faz cada variável aparecer pelo nome na forma de onda. A inicialização com chaves `{1, 2, 3}` não existe; vetores inicializam por arquivo.

## Operadores

| Família | Operadores | Observação |
|---|---|---|
| Aritméticos | `+` `-` `*` `/` `%` | `%` só entre inteiros |
| Relacionais | `<` `>` `<=` `>=` `==` `!=` | resultado 0 ou 1 |
| Lógicos | `&&` `\|\|` `!` | |
| Bit a bit | `&` `\|` `^` `~` `<<` `>>` `>>>` | `>>>` preserva o sinal |
| Pós-incremento | `a++` `v[i]++` | não existe `--` |

Não existem `--`, operadores compostos (`+=`, `-=` e família), operador ternário `?:`, cast explícito nem `sizeof`. Conversões entre `int` e `float` acontecem sozinhas, com aviso do compilador.

:::{tip}
Deslocamentos substituem multiplicações e divisões por potências de dois: `x >> 2` no lugar de `x / 4`. A diferença não é estilo: `/` instancia um divisor no circuito, `>>` quase nada. O PRISM mostra isso ao vivo.
:::

## Controle de fluxo

`if`/`else`, `while`, `do while`, `for`, `switch`/`case`/`default` (com fall-through como em C), `break`, `continue` e `return`. Sem `goto`.

O `for` aceita as formas simples: `for (i = 0; i < 8; i++)`, com declaração no início ou cláusulas vazias. Não aceita múltiplas cláusulas separadas por vírgula.

## Funções

```cmm
float media(float a, float b)
{
    return (a + b) * 0.5;
}
```

- `main()` é obrigatória e é onde o programa vive.
- Até 16 parâmetros, passados por valor. Vetores não podem ser parâmetros.
- Sem recursão: as variáveis locais têm endereço fixo, então uma função não pode chamar a si mesma.
- Sem protótipos: defina a função antes de usar, em um único arquivo {file}`.cmm`.

## Entrada e saída

O processador conversa com o mundo por portas numeradas, definidas por `#NUIOIN` e `#NUIOOU`:

```cmm
int  a = in(0);      // le um inteiro da porta 0
float g = fin(1);    // le da porta 1 convertendo para float
out(0, a + 1);       // escreve na porta de saida 0
fout(0, g);          // escreve mantendo o formato float
```

O número da porta precisa ser um literal, não uma variável. Na simulação, cada porta de entrada lê de {file}`Simulation/input_N.txt` e cada saída grava em {file}`Simulation/output_N.txt`.

## Diretivas

O bloco no topo do arquivo configura o processador. As nove que o Hub escreve:

| Diretiva | Configura |
|---|---|
| `#PRNAME` | nome do processador e do módulo Verilog |
| `#NUBITS` | largura da palavra |
| `#NBMANT`, `#NBEXPO` | formato do ponto flutuante (mantissa e expoente) |
| `#NDSTAC`, `#SDEPTH` | profundidade das pilhas de dados e de chamadas |
| `#NUIOIN`, `#NUIOOU` | número de portas de entrada e de saída |
| `#NUGAIN` | constante da função `norm()`, potência de dois |

A regra estrutural: `#NUBITS` deve ser igual a `#NBMANT + #NBEXPO + 1`. A tabela completa, com as diretivas avançadas, está em {doc}`../referencia/diretivas`.

Também existe `#define` para constantes simples (`#define TAM 8`), sem macros com argumentos, sem `#include` e sem compilação condicional.

## Biblioteca

Funções que custam pouco, mapeadas quase uma a uma em instruções:

| Função | Faz |
|---|---|
| `abs(x)` | valor absoluto |
| `pset(x)` | zera se negativo |
| `sign(x, y)` | devolve `y` com o sinal de `x` |
| `norm(x)` | divide pelo `#NUGAIN`, sem instanciar divisor |

E as matemáticas, que custam mais porque viram rotinas de várias instruções: `sqrt`, `sin`, `cos`, `tan`, `atan`, `exp`, `log`, `pow`, hiperbólicas e arredondamentos. Use quando precisar; cada uma anexada ao programa aparece no relatório do TASM. A referência completa, com assinaturas e restrições, está em {doc}`../referencia/biblioteca`.

## O que não existe, em resumo

Ponteiros, structs, strings, recursão, alocação dinâmica, `#include`, múltiplos arquivos-fonte, vetores com mais de duas dimensões, vetores como parâmetro de função. Se o seu algoritmo parece exigir algum desses, a pergunta certa costuma ser: como um circuito faria isso com memória fixa? A resposta cabe em C±.
