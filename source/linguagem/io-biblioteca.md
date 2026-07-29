# Entrada, saída e biblioteca padrão

Um processador que não conversa com o mundo não serve para nada. Esta página cobre as portas, pelas quais o SAPHO recebe e devolve dados, e a biblioteca de funções intrínsecas que a linguagem oferece, incluindo o recurso mais idiossincrático da C±: a álgebra linear escrita em notação de Dirac.

## As portas de entrada e saída

O processador conversa com o exterior por portas numeradas, criadas pelas diretivas `#NUIOIN` e `#NUIOOU`. Todo o tráfego passa por quatro funções intrínsecas.

:::{list-table}
:header-rows: 1
:widths: 22 14 64

* - Função
  - Tipo
  - O que faz
* - `in(p)`
  - `int`
  - Lê um inteiro da porta de entrada `p`
* - `fin(p)`
  - `float`
  - Lê da porta `p` convertendo para `float`
* - `out(p, x);`
  - qualquer
  - Escreve o valor de `x` na porta de saída `p`
* - `fout(p, x);`
  - `float`
  - Escreve em formato `float`
:::

O número da porta é um literal inteiro, validado contra as diretivas: usar `in(2)` em um processador com `#NUIOIN 1` é erro de compilação.

No exemplo condutor, uma porta de cada lado basta: `x[0] = in(0);` lê a amostra e `out(0, soma >> 2);` publica a média.

### O que acontece no hardware

Vale saber, porque é isso que o projeto de FPGA precisa conectar. A leitura por `in()` é um *handshake*, no qual o processador sinaliza `req_in` e aguarda o dado. A escrita por `out()` pulsa `out_en` com o dado estável no barramento. Esses sinais bastam para acoplar FIFOs, conversores analógico-digitais e outros blocos.

```{mermaid}
flowchart LR
  ADC["Conversor<br>ou FIFO externa"] -->|dado| IN["porta de<br>entrada 0"]
  IN --> P["Processador<br>SAPHO"]
  P --> OUT["porta de<br>saída 0"]
  OUT -->|dado + out_en| EXT["Bloco<br>seguinte"]
```

Na simulação, o *testbench* gerado assume esse papel: alimenta cada porta de entrada com o conteúdo de {file}`input_<i>.txt`, um valor por linha, e grava cada porta de saída em {file}`output_<i>.txt`.

## Funções especiais

Cinco funções existem por um motivo bem específico: economizar *hardware*. Cada uma evita um bloco caro da unidade lógica e aritmética ou uma sequência de instruções.

`norm(x)`
: Divide pelo valor da diretiva `#NUGAIN`, que é uma potência de dois, entregando a normalização sem instanciar o divisor completo. Funciona só com inteiros.

`pset(x)`
: Devolve `x` quando positivo e zero quando negativo. É o equivalente de `if (x<0) x=0;` em uma única instrução, e também a forma natural de implementar a função de ativação ReLU de redes neurais.

`abs(x)`
: Valor absoluto e, sobre um complexo, a magnitude.

`sign(x, y)`
: Devolve `y` com o sinal de `x`.

`copy(x, y);`
: Copia os bits de `x` em `y` sem conversão nem checagem de tipo. É uma reinterpretação crua, a ser usada com consciência.

## Funções não lineares e de arredondamento

A biblioteca cobre raiz e trigonometria (`sqrt`, `sin`, `cos`, `tan`, `atan`), as hiperbólicas (`sinh`, `cosh`, `tanh`), exponencial e logaritmo (`exp`, `log`, `pow`) e os arredondamentos `floor`, `ceil` e `round`, que retornam `float`, com o `round` arredondando o meio para longe do zero.

:::{important} Elas custam ciclos, não blocos
Essas funções não são circuitos dedicados: são macros de *assembly* otimizadas, como o método de Newton na `sqrt` e séries nas trigonométricas, injetadas no programa quando usadas.

Elas custam instruções e tempo de execução, não área de *hardware*, exceto pelas operações de ponto flutuante que elas próprias empregam. É o contrário do que acontece com os operadores aritméticos.
:::

A `pow(x, y)` merece nota, porque o compilador escolhe entre três estratégias: com expoente inteiro constante, gera a sequência mínima de multiplicações; com expoente inteiro variável, um laço em tempo de execução; nos demais casos, a identidade $x^y = e^{y \ln x}$.

## Funções para complexos

Seis funções operam sobre o tipo `comp`:

:::{list-table}
:header-rows: 1
:widths: 26 74

* - Função
  - O que devolve
* - `real(z)`, `imag(z)`
  - As partes real e imaginária
* - `fase(z)`
  - O argumento, ou ângulo
* - `mod2(z)`
  - A magnitude ao quadrado, $a^2+b^2$, mais barata que `abs` por dispensar a raiz
* - `complex(re, im)`
  - Monta um complexo a partir de dois `float`
* - `conj(z)`
  - O conjugado
:::

```{code-block} c
:caption: Multiplicação de complexos e emissão das partes

comp x; comp y; comp r;
x = 1.0 + 2.0i;
y = 3.0 + 4.0i;
r = x * y;
fout(0, real(r));
fout(0, imag(r));
```

:::{warning} Nem tudo se aplica a `comp`
`sqrt`, `exp`, `log`, `pow`, `sign` e `pset` sobre complexos são erro de compilação, assim como o incremento `z++`. O módulo `%` e a `norm()` são exclusivos de inteiros.
:::

:::{tip}
Quando só interessa comparar magnitudes, prefira `mod2()` a `abs()`. A comparação dá o mesmo resultado e você evita instanciar a raiz quadrada.
:::

## Álgebra linear em notação de Dirac

O recurso mais distintivo da C± é a escrita de operações vetoriais e matriciais em notação *bra-ket*, familiar a quem vem da física. Sendo `a` e `b` vetores e `M` uma matriz:

:::{list-table} Construções em notação de Dirac
:header-rows: 1
:widths: 32 68
:name: tab-dirac

* - Sintaxe
  - Operação
* - `<a|b>`
  - Produto interno, usado como expressão
* - `a # |0>;`
  - Zera o vetor
* - `a # |M|b>;`
  - Produto matriz-vetor
* - `a # c|b>;`
  - Vetor escalado por uma constante
* - `A # |a><b|;`
  - Produto externo
* - `out(p, c|a>);`
  - Emite o vetor escalado por uma porta de saída
:::

Essas construções expandem para os laços e instruções indexadas adequados, e são a forma idiomática de escrever filtros FIR, correlações e projeções em C±.

Um filtro de resposta finita ao impulso, por exemplo, cabe em uma linha:

```{code-block} c
:caption: Um FIR completo em notação de Dirac
:linenos:

int h[16] "coefs.txt";   // coeficientes, carregados na compilacao
int x[16];               // janela de amostras
int y;

void main()
{
    int k;
    while (1)
    {
        for (k = 15; k > 0; k = k - 1)
            x[k] = x[k-1];
        x[0] = in(0);

        y = <h|x>;       // produto interno: o filtro inteiro
        out(0, y);
    }
}
```

Compare com a alternativa: um laço acumulando `y = y + h[k]*x[k]`. O resultado compilado é equivalente, mas a intenção fica muito mais legível, e é assim que os projetos do laboratório são escritos.

## Referência rápida

A tabela completa da biblioteca, agrupada por família, está em {doc}`../referencia/biblioteca`.

## O próximo passo

{doc}`avancado` cobre a interrupção, a sincronização com o *hardware* externo, o endereçamento de FFT, o custo de cada construção e o caminho alternativo em C++.
