# Diretivas: configurando o processador no código

As diretivas são as linhas que começam com `#`, uma por linha, sem ponto e vírgula ao final. Elas não são código executável: são a especificação do *hardware* que será gerado. É por elas que o mesmo programa pode virar um processador de 16 bits com duas portas ou um de 32 bits com oito.

Quando você cria um processador pelo {guilabel}`Hub de Processadores`, o formulário escreve essas diretivas no {file}`.cmm` inicial. A partir daí o arquivo é a fonte da verdade: editar uma diretiva muda o processador na compilação seguinte, sem passar pelo formulário de novo.

## As diretivas de configuração

Aparecem no topo do arquivo. A tabela abaixo é a referência completa; a coluna do padrão indica o valor assumido quando a diretiva é omitida, embora o Hub as escreva todas explicitamente.

:::{list-table} Diretivas de configuração da arquitetura
:header-rows: 1
:widths: 16 14 10 60
:name: tab-diretivas-config

* - Diretiva
  - Argumento
  - Padrão
  - Efeito
* - `#PRNAME`
  - nome
  -
  - Nome do processador. Deve casar com o nome do arquivo e da pasta
* - `#NUBITS`
  - inteiro
  - 23
  - Largura da palavra e dos inteiros, em complemento de dois
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
  - Número de portas de entrada; `in(p)` exige `p` menor que esse valor
* - `#NUIOOU`
  - inteiro
  - 1
  - Número de portas de saída; a mesma regra vale para `out`
* - `#NUGAIN`
  - potência de 2
  - 64
  - Divisor fixo usado pela função `norm()`
* - `#FFTSIZ`
  - inteiro
  - 8
  - Bits invertidos no endereçamento bit-reverso `x[k)`, para FFT de $2^n$ pontos
:::

:::{danger} A restrição estrutural
`#NUBITS` deve ser exatamente igual a `#NBMANT` mais `#NBEXPO` mais um, o bit de sinal.

No exemplo condutor, $16 = 10 + 5 + 1$. A AURORA valida essa igualdade no formulário de criação e recusa combinações inválidas, mas quem edita as diretivas à mão responde por mantê-la.
:::

## Como escolher cada valor

A tabela diz o que cada diretiva faz. Esta seção diz como decidir.

`#NUBITS`, a largura da palavra
: Dimensiona os inteiros e boa parte do consumo de *hardware*. Dezesseis bits bastam para muitos sinais de instrumentação; o padrão de 23 dá folga com um `float` de boa precisão. Lembre que ela está amarrada às duas seguintes pela restrição estrutural.

`#NBMANT` e `#NBEXPO`, o formato do ponto flutuante
: Definem precisão e faixa. Com dez bits de mantissa, espere cerca de três dígitos decimais significativos. Se o programa só usa inteiros, esses valores têm pouco efeito prático, mas a igualdade continua obrigatória. Veja {doc}`../arquitetura/ponto-flutuante`.

`#SDEPTH`, a pilha de sub-rotinas
: Limita a profundidade de chamadas de função aninhadas. Se o seu `main()` chama `a()`, que chama `b()`, você precisa de pelo menos três níveis. Os padrões atendem programas típicos.

`#NDSTAC`, a pilha de dados
: Limita a complexidade das expressões. Uma expressão como `a*b + c*d - e*f` empilha resultados parciais; expressões muito aninhadas exigem mais profundidade.

`#NUIOIN` e `#NUIOOU`, as portas
: Reserve uma porta para cada fluxo de dados que o processador troca com o mundo. Com uma única porta a ligação é direta; com mais de uma, o *hardware* instancia automaticamente um decodificador de endereços.

`#NUGAIN`, o ganho
: Só importa se o programa usa `norm()`. Deve ser potência de dois, porque é isso que permite implementar a divisão como deslocamento.

`#FFTSIZ`, o tamanho da FFT
: Só importa se o programa usa a indexação bit-reversa `x[k)`. Veja {doc}`avancado`.

:::{tip}
Ao ajustar parâmetros, mude um de cada vez e recompile. O terminal TASM informa, a cada compilação, o percentual do conjunto de instruções e da unidade lógica e aritmética efetivamente usados, o que dá uma medida direta do efeito de cada mudança.
:::

## As diretivas comportamentais

Duas diretivas fogem ao padrão: aparecem no meio do programa e marcam pontos do código, em vez de configurar a arquitetura.

`#PRACA`
: Marca o ponto para onde o processador desvia quando o pino de interrupção pulsa. O uso típico é reiniciar o laço de processamento quando o *hardware* externo sinaliza um novo evento, como um gatilho de aquisição, sem esperar o programa completar a volta.

`#TOAQUI`
: Marca um endereço cujo alcance faz pulsar o pino `cheguei` do processador. Serve como farol para sincronizar blocos externos com fases do algoritmo, e é também o mecanismo interno pelo qual a AURORA detecta o término do programa nos testes de *hardware* e nas simulações com o Verilator.

Ambas são detalhadas, com exemplos, em {doc}`avancado`.

## Onde as diretivas aparecem depois

Vale saber o destino de cada valor, porque ele reaparece em três lugares diferentes ao longo do fluxo.

```{mermaid}
flowchart LR
  D["Diretivas<br>no .cmm"] --> F["Formulário<br>do Hub"]
  D --> P["parameter<br>no Verilog gerado"]
  D --> V["Validação do<br>compilador"]
  F -.->|escreve| D
  P --> S["Circuito<br>sintetizado"]
  V --> E["Erros de faixa<br>e de porta"]
```

No Verilog gerado, cada diretiva vira um `parameter` do módulo, o que torna o circuito legível e ajustável. No compilador, elas viram regras de validação: usar `in(2)` em um processador com `#NUIOIN 1` é erro de compilação, assim como um literal inteiro que não cabe em `#NUBITS` bits.

## Erros comuns com diretivas

:::{list-table}
:header-rows: 1
:widths: 40 60

* - Sintoma
  - Causa e solução
* - O botão {guilabel}`Gerar Processador` não habilita
  - A igualdade estrutural foi violada, ou o ganho não é potência de dois
* - Erro de porta inexistente
  - O índice em `in()` ou `out()` excede `#NUIOIN` ou `#NUIOOU`. Aumente a diretiva e recompile
* - Erro de estouro de inteiro
  - Um literal ou resultado não cabe em `#NUBITS` bits em complemento de dois
* - Erro de faixa de `float`
  - O valor não cabe no formato definido por `#NBMANT` e `#NBEXPO`
* - Os artefatos não são encontrados
  - `#PRNAME` não corresponde ao nome do arquivo e da pasta. Renomeie pela AURORA
:::

## Referência rápida

A tabela completa de diretivas, com argumentos e padrões, também está no apêndice {doc}`../referencia/diretivas`, para consulta sem sair da página de referência.
