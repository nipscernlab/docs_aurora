# Fluxo completo para processadores SAPHO

Esta página é o roteiro de referência do fluxo SAPHO, para consulta quando você já conhece o caminho e precisa conferir uma etapa ou tratar um caso menos comum. Se esta é a sua primeira vez, faça antes o {doc}`../inicio/primeiro-projeto`, que percorre o mesmo caminho ensinando cada conceito.

```{figure} ../_static/assets/screenshots/aurora-pmu-cmm-editor.png
:alt: Projeto proj_PMU_padrao aberto na AURORA com o algoritmo PMU_padrao.cmm no editor.
:width: 100%
:align: center
:name: fig-fluxo-sapho

Ao abrir um algoritmo C±, o processador correspondente fica ativo e as ações relacionadas a ele são habilitadas na barra superior.
```

## O caminho em uma olhada

```{mermaid}
flowchart TD
  A["1 · Projeto .spf"] --> B["2 · Processador<br><small>Hub de Processadores</small>"]
  B --> C["3 · Algoritmo C±"]
  C --> D["4 · Compilar<br><small>Verilog + .mif + testbench</small>"]
  D --> E["5 · Top-level e testbench"]
  E --> F{"6 · Forma<br>de execução"}
  F --> G["Teste do processador<br>sintetizado"]
  F --> H["Execução rápida"]
  F --> I["Analisar Verilog<br>(forma de onda)"]
  I --> J["7 · Inspecionar<br><small>ondas e PRISM</small>"]
```

## 1. Criar ou abrir o projeto

Clique em {guilabel}`Novo Projeto`, informe um nome sem espaços nem acentos e escolha uma pasta com permissão de escrita.

O arquivo {file}`.spf` criado pela AURORA registra os processadores, as fontes e as seleções do projeto. Ele é JSON legível e amigável a *diffs*, mas a AURORA é a sua única escritora: não o edite à mão no fluxo normal. Detalhes em {doc}`../uso/projetos`.

## 2. Criar o processador

Abra o {guilabel}`Hub de Processadores`, informe o nome e os parâmetros e confirme em {guilabel}`Gerar Processador`. No primeiro projeto, mantenha os valores de fábrica, que já formam uma configuração válida.

A referência de cada campo, das validações e do que é gerado está em {doc}`../uso/processadores`; o significado de cada parâmetro em termos de *hardware*, em {doc}`../arquitetura/processador`.

Depois da confirmação, o processador aparece na árvore com as três subpastas:

```text
<processador>/
├── Software/     o algoritmo C± editável
├── Hardware/     o Verilog e as memórias, gerados
└── Simulation/   o testbench, os estímulos e as saídas
```

## 3. Escrever o algoritmo C±

Abra {file}`Software/<processador>.cmm`, preserve as diretivas geradas e escreva o algoritmo. Salve antes de compilar: os compiladores leem o conteúdo gravado no disco, não o que está no editor.

A linguagem inteira está documentada em {doc}`../linguagem/index`. Para testes que precisam identificar o término do algoritmo, use `#TOAQUI` no ponto adequado.

## 4. Gerar o hardware

1. Mantenha o arquivo {file}`.cmm` aberto e em foco.
2. Clique em {guilabel}`Compilar C±`.
3. Acompanhe os terminais **TCMM** e **TASM**.
4. Aguarde a criação ou atualização dos arquivos em {file}`Hardware`.

O YANC transforma o algoritmo em *assembly*, depois gera o módulo Verilog, as imagens de memória e o *testbench* padrão. O detalhamento dos três estágios está em {doc}`compilacao`.

:::{warning}
Um arquivo antigo em {file}`Hardware` não comprova que a compilação atual passou. Confirme o resultado nos terminais.
:::

## 5. Definir top-level e testbench

O módulo em {file}`Hardware/<processador>.v` pode servir como *top-level* quando o projeto testa apenas esse processador. Clique nele com o botão direito e escolha {guilabel}`Definir como Top Level`.

Em sistemas maiores, o *top-level* é outro módulo Verilog, escrito por você, que instancia um ou mais processadores gerados junto com a infraestrutura convencional de *hardware*. Esse é o padrão de projeto do SAPHO, discutido em {doc}`../arquitetura/processador`.

Como *testbench*, escolha uma das três opções:

::::{tab-set}

:::{tab-item} O gerado
O {file}`Simulation/<processador>_tb.v` produzido pela compilação. Gera *clock* e *reset*, lê os estímulos de {file}`input_<i>.txt` e grava as saídas em {file}`output_<i>.txt`. Basta para a maioria dos projetos de um único processador.
:::

:::{tab-item} Um Verilog seu
Um {file}`.v` escrito por você, quando o estímulo exige lógica que os arquivos de texto não expressam, ou quando o teste envolve vários blocos.
:::

:::{tab-item} Um cocotb em Python
Um {file}`.py` com a diretiva `# aurora-toplevel: <processador>` em comentário, ou herdada da configuração do projeto. Indicado quando a verificação se beneficia de NumPy, SciPy e asserções legíveis. Veja {doc}`simulacao`.
:::

::::

Clique com o botão direito no arquivo escolhido e selecione {guilabel}`Marcar como Testbench`. Confirme os dois papéis na barra de status antes de simular.

## 6. Escolher a forma de execução

:::{list-table}
:header-rows: 1
:widths: 34 66

* - Ação
  - Quando usar
* - {guilabel}`Teste do processador sintetizado`
  - Validação rápida de entradas, saídas e término, sem inspeção visual. Usa um *harness* do Verilator e reporta no terminal **THTEST**
* - {guilabel}`Execução rápida`
  - Verificações automatizadas e regressões curtas, sem abrir formas de onda
* - {guilabel}`Analisar Verilog (forma de onda)`
  - Quando você precisa observar sinais, portas e estados internos ao longo do tempo
:::

## 7. Conferir entradas e saídas

Nos processadores gerados, `out` transporta o valor e `out_en` identifica a porta de saída escrita. O sinal `cheguei` indica que a execução alcançou o marcador `#TOAQUI`.

Um teste adequado verifica:

- [ ] se cada porta recebeu os valores esperados;
- [ ] se a quantidade e a ordem das saídas estão corretas;
- [ ] se o processador alcançou o ponto de término;
- [ ] se existe um limite de ciclos que evita espera infinita.

## 8. Analisar o hardware gerado

Use {guilabel}`Analisar Verilog (forma de onda)` para observar o comportamento temporal e {guilabel}`Abrir PRISM` para examinar a estrutura RTL.

```{figure} ../_static/assets/screenshots/aurora-wave-configuration-sapho.png
:alt: Configuração de ondas de um processador SAPHO com clock, reset, portas de saída e sinal de término.
:width: 85%
:align: center
:name: fig-ondas-fluxo

No fluxo SAPHO, comece por `clk`, `rst`, as portas de saída e o sinal de término. Expanda o processador somente quando precisar investigar sinais internos.
```

:::{important}
O algoritmo {file}`.cmm` continua sendo a única fonte editável. Os arquivos da pasta {file}`Hardware` são resultado da geração e serão substituídos na próxima compilação: qualquer edição manual neles se perde.
:::

## Resultado esperado

O fluxo está concluído quando:

- [x] o Hub de Processadores criou a estrutura do processador;
- [x] o algoritmo {file}`.cmm` compila sem erro;
- [x] o Verilog e as imagens de memória estão atualizados;
- [x] o *top-level* e o *testbench* aparecem corretamente na barra de status;
- [x] a execução produz as saídas esperadas e alcança o término;
- [x] o visualizador de ondas ou o PRISM apresenta o resultado desejado, quando utilizado.

## Leitura relacionada

- {doc}`../linguagem/index` para escrever o algoritmo.
- {doc}`../uso/processadores` para os campos do Hub e as configurações de simulação.
- {doc}`../exemplos/galeria-testbenches` para exemplos C± com *testbenches* Verilog e cocotb.
- {doc}`verilog` se o seu projeto não gera processadores e trabalha só com RTL.
