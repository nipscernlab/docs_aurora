# O ponto flutuante do SAPHO

O SAPHO tem *hardware* de ponto flutuante próprio, que não segue o padrão IEEE 754. Esta página explica o formato, o que se pode esperar dele em precisão e por que a escolha faz sentido em um processador gerado sob demanda.

Se o seu programa só usa inteiros, a leitura é opcional. Se ele usa `float` ou `comp`, vale conhecer o terreno.

## O formato

O número reúne três campos:

```text
 ┌────────┬──────────────────────┬────────────────────────────────┐
 │ sinal  │       expoente       │            mantissa            │
 │ 1 bit  │    #NBEXPO bits      │         #NBMANT bits           │
 └────────┴──────────────────────┴────────────────────────────────┘
 └──────────────────────  #NUBITS bits  ─────────────────────────┘
```

Um bit de sinal, `#NBEXPO` bits de expoente em complemento de dois e `#NBMANT` bits de mantissa com o bit líder explícito. A soma dos três é exatamente `#NUBITS`, que é a origem da restrição estrutural cobrada pelo formulário de criação:

$$\texttt{NUBITS} = \texttt{NBMANT} + \texttt{NBEXPO} + 1$$

## Por que não IEEE 754

A pergunta é justa, e a resposta é o princípio da plataforma. O padrão IEEE 754 fixa precisões: 32 bits com 23 de mantissa e 8 de expoente, ou 64 bits com 52 e 11. Um processador gerado sob medida não tem motivo para aceitar essa imposição.

Com o formato próprio, você escolhe precisões arbitrárias. Uma mantissa de 10 bits com expoente de 5, como no exemplo condutor, economiza *hardware* exatamente onde a aplicação permite: se o sinal que você processa tem três dígitos significativos úteis, pagar por 23 bits de mantissa é desperdiçar área de FPGA em zeros.

:::{important}
A escolha do formato é uma decisão de projeto, não um detalhe. Em um processador que roda em tempo real dentro de um detector de partículas, cada elemento lógico economizado é orçamento para outro canal de leitura.
:::

## O que esperar em precisão

A precisão obtida é exatamente a configurada. Com `#NBMANT 10`, espere cerca de três dígitos decimais significativos. A regra prática é que cada bit de mantissa vale aproximadamente 0,3 dígito decimal.

:::{list-table} Precisão aproximada por largura de mantissa
:header-rows: 1
:widths: 30 30 40

* - `#NBMANT`
  - Dígitos decimais
  - Uso típico
* - 10
  - cerca de 3
  - Sinais de instrumentação com dinâmica modesta
* - 16
  - cerca de 5
  - Padrão de fábrica, folgado para a maioria dos algoritmos
* - 23
  - cerca de 7
  - Equivalente à precisão simples do IEEE 754
:::

O expoente, por sua vez, define a faixa: com `#NBEXPO 5` em complemento de dois, o expoente varia de -16 a 15, o que cobre cerca de dez ordens de grandeza. Valores fora da faixa do formato configurado são apontados como erro de faixa na compilação.

:::{admonition} Um dado experimental do laboratório
:class: seealso

Na verificação de uma Unidade de Medição Fasorial implementada no SAPHO, a saída do processador com `float` de 24 bits reproduziu um modelo de referência em dupla precisão com desvio máximo da ordem de $5\times10^{-6}$ no fasor. O erro remanescente na conformidade com a norma foi atribuído ao método de estimação, e não à aritmética do *hardware*.

A conclusão prática é que o formato reduzido raramente é o fator limitante: antes de ampliar a mantissa, confira se o gargalo não está no algoritmo.
:::

## Na prática, dentro do programa

Dentro do programa C±, o tipo `float` simplesmente funciona. Literais, aritmética e as funções da biblioteca operam nesse formato interno, e a conversão entre o formato IEEE do seu computador e o formato do SAPHO é feita em *software* pela cadeia de ferramentas, na carga das memórias e na leitura dos resultados.

```{code-block} c
:caption: Ponto flutuante em uso, sem cerimônia

#NUBITS 16
#NBMANT 10
#NBEXPO 5

void main()
{
    float x;
    float y;
    while (1)
    {
        x = fin(0);          // le convertendo para float
        y = sqrt(x) * 2.5;
        fout(0, y);          // escreve em formato float
    }
}
```

## Números complexos

O tipo `comp` não tem *hardware* dedicado. Cada complexo é um par de `float`, parte real e imaginária, manipulado componente a componente pelo código gerado. As quatro operações aritméticas funcionam e expandem para o conjunto de operações reais necessárias.

Isso tem duas consequências práticas. A primeira é de custo: uma multiplicação de complexos gera quatro multiplicações e duas somas reais. A segunda é de precisão: cada componente tem a precisão do `float` configurado, e não mais do que isso.

:::{tip}
Nas formas de onda, as variáveis do tipo `comp` são decodificadas para a forma legível $a+bi$ pelo conversor `comp2gtkw` do YANC, de modo que você não precisa ler dois sinais separados e recompor mentalmente o número.
:::

## Quando o float não vale a pena

Uma regra de bolso do laboratório: se a dinâmica do sinal cabe em inteiros, use inteiros.

Ponto flutuante instancia blocos de *hardware* substanciais na unidade lógica e aritmética, um por operação usada, e consome mais ciclos que a aritmética inteira. Em processamento de sinais de instrumentação, é muito comum que uma escala fixa bem escolhida com `int` produza o mesmo resultado por uma fração do custo.

O caminho intermediário é a função `norm()`, que divide por uma potência de dois definida em `#NUGAIN` e permite trabalhar com inteiros escalados sem instanciar o divisor. Veja {doc}`../linguagem/io-biblioteca`.

## Leitura relacionada

- {doc}`processador` descreve onde o bloco de ponto flutuante se encaixa no caminho de dados.
- {doc}`instrucoes` lista os *opcodes* de ponto flutuante, que começam por `F_`.
- {doc}`../linguagem/diretivas` explica como escolher `#NBMANT` e `#NBEXPO`.
