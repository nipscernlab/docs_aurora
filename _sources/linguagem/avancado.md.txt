# Recursos avançados

Esta página reúne o que você não precisa no primeiro programa, mas vai querer no terceiro: interrupção, sincronização com o *hardware* externo, endereçamento de FFT, o custo em área de cada construção e o caminho alternativo em C++. Fecha com a leitura das mensagens do compilador.

## Interrupção: `#PRACA`

O processador SAPHO tem um pino de interrupção, o `itr`. Quando ele pulsa, o contador de programa desvia para o ponto do código marcado pela diretiva `#PRACA`, que, diferentemente das diretivas de configuração, aparece no meio do programa e marca a linha de retorno.

O uso típico é reiniciar o laço de processamento quando o *hardware* externo sinaliza um novo evento, como um gatilho de aquisição, sem esperar o programa completar a volta.

```{code-block} c
:caption: Estrutura de um programa acionado por interrupção
:linenos:

void main()
{
    int amostra;

    #PRACA                    // a interrupcao devolve a execucao para aqui
    while (1)
    {
        amostra = in(0);
        // processamento de uma janela completa
        out(0, amostra);
    }
}
```

Esse padrão é o que sustenta aplicações de aquisição em tempo real, nas quais o processador precisa abandonar o trabalho em curso assim que uma nova janela de dados chega.

## Sincronização com o hardware: `#TOAQUI`

A diretiva `#TOAQUI`, colocada em um ponto do programa, faz o pino `cheguei` do processador pulsar sempre que a execução passa por ali. É um farol para o mundo externo, útil para sincronizar blocos de *hardware* com fases do algoritmo.

Ela é também um mecanismo interno da própria AURORA: no teste do processador sintetizado e nas simulações com o Verilator, a IDE insere um `#TOAQUI` ao final do `main()` para detectar o término do programa e encerrar a simulação no instante certo.

:::{tip}
Se você escreve o seu próprio *testbench* e precisa saber quando o algoritmo terminou uma passada, `#TOAQUI` no ponto certo é mais confiável do que contar ciclos.
:::

## FFT e o endereçamento bit-reverso

A diretiva `#FFTSIZ n` configura o circuito de reversão de bits para transformadas de $2^n$ pontos, usado pela indexação `x[k)` apresentada em {doc}`tipos-operadores`.

Na FFT radix-2 os resultados saem em ordem bit-reversa, e reordená-los custaria um laço inteiro. Com `x[k)` a reordenação é gratuita: o *hardware* inverte os bits do índice na própria leitura ou escrita, sem instruções extras.

```{mermaid}
flowchart LR
  A["índice k<br>0b001"] -->|"x[k]"| B["endereço 1<br>ordem natural"]
  A -->|"x[k)"| C["endereço 4<br>bits invertidos: 0b100"]
```

O repositório do YANC traz um projeto de exemplo completo, o `proc_fft`, com uma FFT inteira escrita em C±.

## Quanto custa cada construção

O princípio de pagar apenas pelo que se usa tem uma consequência prática direta: o custo em FPGA do processador é proporcional ao subconjunto da linguagem que o programa emprega.

Durante a compilação, o terminal TASM informa cada bloco de *hardware* instanciado à medida que os *opcodes* aparecem pela primeira vez. Ao final, ele resume o percentual do conjunto de instruções e da unidade lógica e aritmética efetivamente usados.

:::{list-table} O que cada construção liga no circuito
:header-rows: 1
:widths: 40 60
:name: tab-custo

* - Construção no programa
  - O que instancia no hardware
* - Chamar uma função
  - A memória da pilha de sub-rotinas
* - Usar um vetor
  - O circuito de endereçamento indexado
* - Usar a forma `x[k)`
  - O circuito de reversão de bits
* - Dividir com `/`
  - O divisor inteiro, um dos blocos mais caros
* - Usar `%`
  - O bloco de módulo
* - Operar em `float`
  - Os blocos de ponto flutuante correspondentes a cada operação usada
* - Deslocar com `<<`, `>>`, `>>>`
  - O deslocador, um dos blocos mais baratos
:::

### Regras de bolso para hardware enxuto

- prefira deslocamentos a divisões por potências de dois, ou use `norm()`;
- prefira `mod2()` a `abs()` quando só compara magnitudes, evitando a raiz quadrada;
- evite `float` quando a dinâmica do sinal cabe em inteiros;
- lembre que é a primeira ocorrência de um operador que paga o bloco, pois a segunda em diante reaproveita o circuito.

:::{tip} O experimento que ensina isso em dois minutos
Compile o exemplo condutor, abra o PRISM e guarde o diagrama na memória. Troque `soma >> 2` por `soma / 4`, recompile e clique em {guilabel}`Recompile`. O divisor aparece no desenho, e o TASM anuncia o bloco novo. Desfaça e ele some.
:::

## O caminho C++

Além da C±, o YANC compila C++ para o mesmo processador, por uma cadeia paralela: o pré-processador `cpppp`, com `#include`, `#define` completo e compilação condicional, seguido do compilador `cppcomp`, que aceita um subconjunto de C99 com extensões de C++ e emite o mesmo *assembly* intermediário.

::::{grid} 1 2 2 2
:gutter: 3

:::{grid-item-card} O que o C++ oferece a mais

- ponteiros, restritos à indexação de vetores de tamanho fixo, sem alocação dinâmica;
- recursão, com quadros de pilha de verdade;
- `struct` simples;
- recursos modernos como *lambdas* e destrutores;
- os cabeçalhos padrão adaptados {file}`array`, {file}`cmath`, {file}`cstdint` e {file}`vector`.
:::

:::{grid-item-card} O que se perde

Variáveis locais deixam de ter endereço fixo e, com isso, deixam de aparecer pelo nome nas formas de onda. Perde-se em parte o vínculo íntimo entre código e onda que marca o fluxo C±.

Os parâmetros do processador nesse fluxo têm padrões próprios, palavra de 32 bits com mantissa de 23 e expoente de 8, ajustáveis por `#pragma yanc`.
:::

::::

:::{note} Recomendação prática do laboratório
Comece todo projeto em C± e migre para C++ apenas quando precisar especificamente de recursão, ponteiros ou `struct`. Mantenha em C± os processadores de sinal críticos, nos quais a visibilidade de simulação é total.
:::

## As mensagens do compilador

Os diagnósticos do YANC são bilíngues, acompanhando o idioma da IDE, e têm personalidade: um erro de sintaxe rende um comentário bem-humorado, e esquecer o `main()` provoca a pergunta clássica sobre onde ele está. Por trás do humor, a informação é séria e cai em poucas classes.

::::{tab-set}

:::{tab-item} Erros de estrutura
- falta do `main()`;
- `break` ou `continue` fora de laço;
- contagem errada de parâmetros em uma chamada.
:::

:::{tab-item} Erros de nome
- variável inexistente;
- variável já declarada;
- uso do `i` reservado como identificador.
:::

:::{tab-item} Erros de tipo
- módulo `%` e `norm()` com operandos não inteiros;
- funções intrínsecas sem versão para complexos;
- incremento de um `comp`.
:::

:::{tab-item} Erros de faixa
- estouro de inteiro para o `#NUBITS` escolhido;
- `float` fora da faixa do formato configurado;
- porta de entrada ou saída inexistente.
:::

:::{tab-item} Avisos
- conversões implícitas entre tipos;
- uso de `float` ou `comp` em condições e índices.
:::

::::

Os erros aparecem no terminal TCMM com a linha clicável, e o clique leva o editor ao ponto exato.

:::{tip}
A Aurora Intelligence sabe explicar qualquer mensagem do compilador: ela consulta o catálogo bilíngue de mensagens gerado a partir das próprias fontes do YANC, e não depende da memória do modelo. Veja {doc}`../ia/ferramentas`.
:::

## Leitura relacionada

- {doc}`../arquitetura/processador` explica por que o endereçamento fixo impede a recursão.
- {doc}`../arquitetura/instrucoes` ajuda a ler as trilhas de *assembly* nas formas de onda.
- {doc}`../fluxos/compilacao` detalha o que cada compilador da cadeia produz.
