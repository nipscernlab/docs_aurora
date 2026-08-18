# Tutorial: um processador SAPHO

No tutorial anterior você escreveu o circuito à mão. Agora o caminho é outro: descrever um algoritmo em C± e deixar a plataforma gerar o processador. Ao final, você terá criado um processador sob medida, compilado até Verilog, simulado e lido o resultado na onda. Reserve uns trinta minutos.

:::{admonition} O que vamos construir
:class: tip

Um filtro de média móvel de quatro amostras: lê um valor pela porta de entrada, guarda as quatro últimas leituras, soma e devolve a média pela porta de saída. É o filtro mais simples do processamento de sinais, e exercita em vinte linhas tudo o que um projeto SAPHO tem: entrada e saída, um vetor na memória, aritmética e um laço infinito.
:::

## Passo 1: criar o projeto

Crie um projeto chamado `MeuFiltro`, como no tutorial anterior: {guilabel}`Novo Projeto`, nome, local, {guilabel}`Gerar Projeto`.

:::{warning}
Se você ainda estiver com o projeto do contador aberto, feche-o ou confira os papéis antes de simular. Top Level e Testbench Top são marcações do projeto ativo, e um {file}`contador.v` esquecido no papel de Top Level faz a compilação do filtro simular o circuito errado, sem erro nenhum. A barra de status mostra os dois o tempo todo: neste tutorial, os dois nomes têm que ser do `media_movel`.
:::

## Passo 2: criar o processador

1. Clique em {guilabel}`Hub de Processadores`, na barra superior.
2. Preencha conforme a tabela e clique em {guilabel}`Gerar Processador`.

:::{list-table} Valores para este tutorial
:header-rows: 1
:widths: 34 14 52

* - Campo
  - Valor
  - Por quê
* - Nome do Processador
  - `media_movel`
  - Vira o nome da pasta, do módulo Verilog e da diretiva `#PRNAME`
* - Total de Bits
  - `16`
  - Largura da palavra; 16 bits bastam para sinais de instrumentação
* - Bits da Mantissa
  - `10`
  - Precisão do ponto flutuante
* - Bits do Expoente
  - `5`
  - Faixa do ponto flutuante
* - Ganho
  - `128`
  - Usado só por `norm()`; deve ser potência de dois
* - Pilha de Instruções
  - `2`
  - Profundidade de chamadas de função aninhadas
* - Pilha de Dados
  - `4`
  - Complexidade das expressões
* - Portas de Entrada
  - `1`
  - Uma porta para receber as amostras
* - Portas de Saída
  - `1`
  - Uma porta para publicar a média
:::

```{figure} ../_static/assets/screenshots/aurora-hub-processadores.png
:alt: Hub de Processadores preenchido com os valores do tutorial.
:width: 85%
:align: center
:name: fig-hub

A validação roda enquanto você digita, e o botão só habilita com tudo consistente.
```

:::{important}
A regra que mais reprova o formulário: o total de bits deve ser a soma da mantissa, do expoente e do bit de sinal. Aqui, $16 = 10 + 5 + 1$. É uma exigência estrutural do hardware de ponto flutuante, explicada em {doc}`../avancado/ponto-flutuante`.
:::

```{figure} ../_static/assets/screenshots/aurora-hub-validacao.png
:alt: Hub com um campo inválido em vermelho e o botão desabilitado.
:width: 85%
:align: center

Um campo fora da regra fica com a borda vermelha e trava o botão.
```

**Confira:** a árvore mostra `media_movel` com as pastas {file}`Software`, {file}`Hardware` (vazia) e {file}`Simulation` (vazia). O arquivo {file}`media_movel.cmm` nasceu com o cabeçalho preenchido pelo formulário.

## Passo 3: escrever o algoritmo

Abra {file}`Software/media_movel.cmm` e substitua o conteúdo por:

```{code-block} cmm
:caption: media_movel.cmm
:linenos:

#PRNAME media_movel
#NUBITS 16
#NDSTAC 4
#SDEPTH 2
#NUIOIN 1
#NUIOOU 1
#NBMANT 10
#NBEXPO 5
#NUGAIN 128

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
        out(0, soma >> 2);    // media = soma/4, sem divisor
    }
}
```

Salve com {kbd}`Ctrl+S`. Três observações sobre o programa:

As nove primeiras linhas são diretivas
: Não são código executável: configuram o hardware que será gerado. O formulário as escreveu, e a partir de agora o arquivo é a fonte da verdade. Editar uma diretiva muda o processador na próxima compilação.

O `while (1)` é a forma canônica
: O programa modela um circuito, e circuitos não terminam: processam amostras para sempre.

A divisão virou deslocamento
: `soma >> 2` dá o mesmo resultado de `soma / 4`, mas `/` instanciaria um divisor inteiro, um dos blocos mais caros da ULA. O deslocamento sai quase de graça. Você vai ver essa diferença com os próprios olhos no passo 7.

## Passo 4: compilar

Com o {file}`.cmm` em foco, clique em {guilabel}`Compilar C±`. Três compiladores rodam em sequência:

```{mermaid}
flowchart LR
  A[".cmm"] -->|cmmcomp| B[".asm"]
  B -->|appcomp| C["endereços<br>resolvidos"]
  C -->|asmcomp| D[".v + .mif<br>+ testbench"]
```

O terminal TCMM mostra a tradução para assembly; o TASM mostra a montagem e, o mais interessante, os avisos de recurso instanciado: cada bloco de hardware que o seu programa ligou no circuito.

```{figure} ../_static/assets/screenshots/aurora-compilacao-sucesso.png
:alt: Terminais TCMM e TASM após a compilação bem-sucedida.
:width: 90%
:align: center
```

**Confira:** a pasta {file}`Hardware` ganhou {file}`media_movel.v` (o processador), {file}`media_movel_inst.mif` e {file}`media_movel_data.mif` (as memórias). Em {file}`Simulation` apareceu o testbench gerado.

Se a compilação falhar, vá à primeira mensagem de erro, não à última. A referência de linha é um link que abre o editor no ponto exato.

```{figure} ../_static/assets/screenshots/aurora-compilacao-erro.png
:alt: Terminal TCMM com um erro e o link de linha clicável.
:width: 90%
:align: center
```

## Passo 5: preparar o estímulo e simular

O testbench gerado alimenta cada porta de entrada com um arquivo de texto, um valor por linha, e grava cada porta de saída em outro.

1. Na visão {guilabel}`Pastas`, botão direito em {file}`media_movel/Simulation`, {guilabel}`Novo arquivo`, nomeie {file}`input_0.txt`.
2. Escreva um degrau: quatro zeros e depois valores 100.

```{code-block} text
:caption: Simulation/input_0.txt

0
0
0
0
100
100
100
100
100
100
100
100
```

```{figure} ../_static/assets/screenshots/aurora-simulacao-input.png
:alt: Editor com o arquivo de estímulo aberto na visão Pastas.
:width: 85%
:align: center
```

3. Confirme na barra: simulador **Icarus Verilog**, visualizador **GTKWave**.
4. Clique em {guilabel}`Analisar Verilog`.

:::{admonition} Se a simulação acabar antes do resultado
:class: note

Quase sempre é o número de ciclos. Clique na engrenagem ao lado do botão C± e aumente o valor, que por padrão é 2000. O mesmo painel ajusta a frequência de clock e mostra o tempo simulado estimado.

```{figure} ../_static/assets/screenshots/aurora-config-processador.png
:alt: Popover de configuração de simulação do processador.
:width: 60%
:align: center
```
:::

## Passo 6: ler a forma de onda

O visualizador abre com os sinais já agrupados, nomeados e coloridos, uma curadoria feita pela AURORA.

```{figure} ../_static/assets/screenshots/aurora-gtkwave-media-movel.png
:alt: GTKWave com o histórico, a soma, a saída e as trilhas Assembly e C±.
:width: 100%
:align: center
:name: fig-onda-filtro

O degrau entra e sai suavizado em quatro passos, o comportamento esperado de uma média móvel de quatro amostras.
```

Procure na janela:

- as variáveis `x[0]` a `x[3]` deslizando a cada amostra;
- `soma` subindo em degraus de 100 conforme o histórico se preenche;
- a porta de saída com o degrau suavizado;
- as trilhas de texto que mostram, a cada ciclo, a instrução assembly executada e a linha do seu C± correspondente. É o seu programa rodando dentro do hardware, em sincronia com o clock.

Os valores de saída também ficam em {file}`Simulation/output_0.txt`, prontos para uma planilha ou um script.

## Passo 7: ver o circuito por dentro

1. Botão direito em {file}`Hardware/media_movel.v`, {guilabel}`Definir como Top Level`.
2. Clique em {guilabel}`Abrir PRISM`.

O PRISM desenha o circuito como um diagrama navegável: clique em um módulo para entrar nele.

```{figure} ../_static/assets/screenshots/aurora-prism-media-movel.png
:alt: PRISM exibindo o processador media_movel.
:width: 100%
:align: center
```

:::{tip}
O experimento que mais ensina: troque `soma >> 2` por `soma / 4`, recompile e clique em {guilabel}`Recompile` no PRISM. Um divisor inteiro aparece no diagrama, e o TASM anuncia o bloco novo. Desfaça e ele some. É a relação entre construção de linguagem e custo de hardware, tornada visível.

Para enxergar o divisor, desça até a ULA: no diagrama recompilado, clique no processador para entrar nele e depois em {guilabel}`ula`. No nível do topo nada muda de aparência, porque as portas externas do processador continuam as mesmas; o que muda é o conteúdo da unidade aritmética.

```{figure} ../_static/assets/screenshots/aurora-prism-divisor.png
:alt: PRISM mostrando o divisor instanciado após a troca do deslocamento pela divisão.
:width: 100%
:align: center
```
:::

## O que você aprendeu

- [x] Um processador é uma pasta com {file}`Software`, {file}`Hardware` e {file}`Simulation`, criada pelo Hub.
- [x] As diretivas no topo do {file}`.cmm` definem o hardware; o corpo define o comportamento.
- [x] Compilar produz Verilog, imagens de memória e um testbench, por três compiladores encadeados.
- [x] A simulação lê {file}`input_N.txt` e grava {file}`output_N.txt`.
- [x] A onda mostra as suas variáveis pelo nome e a linha do seu código a cada ciclo.
- [x] Escolhas de linguagem têm custo em hardware, e o PRISM mostra esse custo.

## Exercícios

1. Mude o filtro para média de 8 amostras. O que precisa mudar além do vetor e do deslocamento?
2. Acrescente uma segunda porta de saída (`#NUIOOU 2`) publicando a amostra crua em paralelo com a média, e compare as duas curvas na onda.
3. Troque `soma >> 2` por `soma / 4`, recompile e meça a diferença: no relatório do TASM e no diagrama do PRISM.
4. Sature a saída com `pset()` para o filtro nunca publicar valor negativo, e teste com um degrau que desce.

Siga para a linguagem: {doc}`linguagem`. Ou, se preferir ver os detalhes da cadeia de compilação, {doc}`compilacao`.
