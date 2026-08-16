# Números complexos

O C± tem números complexos como tipo nativo: `comp`. Um complexo é um par de floats (parte real e imaginária) no formato de ponto flutuante do processador, e a aritmética sobre ele é gerada pelo compilador, sem biblioteca externa.

## Declarar e operar

```c
comp z;
comp w = 3.0 + 4.0i;
comp data[8];              // vetor de complexos

z = w * conj(w);           // 25 + 0i
float m = mod2(w);         // 25.0, o modulo ao quadrado
float f = fase(w);         // 0.927 rad
comp  u = complex(a, b);   // monta a + bi a partir de dois floats
```

O literal exige as duas partes: `3.0 + 4.0i` funciona, `4.0i` sozinho não. O identificador `i` é reservado pela linguagem exatamente por isso.

## O que funciona e o que não

| Operação | Com `comp` |
|---|---|
| `+  -  *  /` e o `-` unário | sim, com a álgebra completa |
| comparações (`<`, `==`, ...) | comparam o módulo, com aviso |
| `%`, bits (`&`, `|`, `^`, `~`), deslocamentos, `++` | não |
| `abs` | sim: devolve o módulo |
| `sqrt`, `exp`, `log`, `sin`, `cos`, `tan`, `atan` | sim, nas versões complexas |
| `pow`, hiperbólicas, arredondamentos, `pset`, `sign`, `norm` | não |
| `out()` direto de um `comp` | não: escreva `fout(p, real(z))` e `fout(p, imag(z))` |
| notação de Dirac | não; vetores Dirac são de `int` ou `float` |

As funções de acesso: `real(z)`, `imag(z)`, `mod2(z)`, `fase(z)`, `complex(a, b)`, `conj(z)`.

## Custo e representação

Um `comp` ocupa duas células de memória. Uma multiplicação complexa custa quatro multiplicações e duas somas reais; uma divisão, isso mais a divisão pelo módulo ao quadrado. O compilador gera essas sequências e o TASM relata os blocos instanciados, como sempre.

## Complexos na forma de onda

Na simulação, cada variável `comp` aparece como um único sinal decodificado no formato `a + bi`, legível diretamente:

```{figure} ../_static/assets/screenshots/aurora-gtkwave-complexos.png
:alt: GTKWave mostrando um sinal complexo decodificado como a + bi.
:width: 100%
:align: center

A decodificação funciona no GTKWave e no Surfer, com o formato de ponto flutuante do processador aplicado automaticamente.
```

## Exemplo rápido

O clássico $e^{i\pi} = -1$, direto no processador:

```{code-block} c
:caption: euler.cmm (trecho)

comp z = 0.0 + 3.14159i;
comp e = exp(z);
fout(0, real(e));    // -1.000 (com o erro do formato escolhido)
fout(0, imag(e));    //  0.000
```

Compare o resultado com diferentes configurações de mantissa: é um bom exercício para fechar este capítulo com o anterior. O uso pesado de complexos aparece no capítulo da {doc}`FFT <fft>`.
