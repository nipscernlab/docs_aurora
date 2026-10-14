# Números complexos

O C± tem números complexos como tipo nativo: `comp`. Um complexo é um par de floats (parte real e imaginária) no formato de ponto flutuante do processador, e a aritmética sobre ele é gerada pelo compilador, sem biblioteca externa.

## Declarar e operar

```cmm
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

A soma, a subtração, a multiplicação e a divisão têm a álgebra completa, e `abs` devolve o módulo. Operadores de bits, `%`, `++` e a notação de Dirac não aceitam `comp`, e `out()` não escreve um complexo direto: escreva `fout(p, real(z))` e `fout(p, imag(z))`.

O que vale para cada operador e função, e as funções de acesso (`real`, `imag`, `mod2`, `fase`, `complex`, `conj`): [complexos na linguagem](https://www.nipscern.com/library/yanc/language-cmm.html#complex-numbers) e [na biblioteca](https://www.nipscern.com/library/yanc/library.html#complex-numbers), no manual do YANC.

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

```{code-block} cmm
:caption: euler.cmm (trecho)

comp z = 0.0 + 3.14159i;
comp e = exp(z);
fout(0, real(e));    // -1.000 (com o erro do formato escolhido)
fout(0, imag(e));    //  0.000
```

Compare o resultado com diferentes configurações de mantissa: é um bom exercício para fechar este capítulo com o anterior. O uso pesado de complexos aparece no capítulo da {doc}`FFT <fft>`.
