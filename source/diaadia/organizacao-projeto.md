# Organização de um projeto

Um projeto é uma pasta no disco governada por um arquivo {file}`.spf` (*SAPHO Project File*). Tudo o que a AURORA sabe sobre o projeto está nele: quais arquivos participam, qual é o Top Level, qual é o Testbench Top e quais processadores existem.

## A pasta

Um projeto que já tem um processador e alguns fontes Verilog fica assim:

```text
MeuProjeto/
├── MeuProjeto.spf              o arquivo do projeto
├── contador.v                  fonte Verilog importado
├── tb_contador.v               testbench importado
├── media_movel/                um processador SAPHO
│   ├── Software/               o que você escreve
│   │   ├── media_movel.cmm
│   │   └── media_movel.asm     gerado na compilação
│   ├── Hardware/               o que o YANC gera
│   │   ├── media_movel.v
│   │   ├── media_movel_inst.mif
│   │   └── media_movel_data.mif
│   └── Simulation/             estímulos e resultados
│       ├── media_movel_tb.v
│       ├── input_0.txt
│       └── output_0.txt
├── testbench/                  estado de ondas por testbench
└── Backup/                     zips gerados pelo botão de backup
```

O projeto nasce só com o {file}`.spf`. As pastas de processador aparecem quando você cria um processador no Hub; as demais, conforme o uso.

## O arquivo .spf

É um JSON legível. Guarda o nome e o caminho base do projeto, a lista de processadores com suas configurações de simulação, as listas de fontes sintetizáveis e de testbenches, e os dois ponteiros centrais: `topLevelFile` e `testbenchFile`. Caminhos dentro do projeto são gravados relativos, então o projeto pode ser movido ou copiado de máquina para máquina sem quebrar.

:::{tip}
O {file}`.spf` abre no editor como JSON com realce. Ler o seu é uma boa forma de entender o que a AURORA registra. Editar à mão raramente é necessário; a interface cuida dele.
:::

:::{warning}
Os parâmetros de arquitetura do processador (largura de bits, mantissa, portas) não ficam no {file}`.spf`. Eles vivem nas diretivas no topo do arquivo {file}`.cmm`, que é a fonte da verdade: editar uma diretiva muda o processador na próxima compilação. No {file}`.spf` ficam apenas as preferências de simulação de cada processador (clock, número de ciclos).
:::

## Sintetizável ou testbench: quem decide é o conteúdo

Ao importar um {file}`.v`, a AURORA o classifica sozinha lendo o conteúdo: sinais típicos de testbench (gravação de onda, `$finish`, módulo sem portas, blocos `initial`, atrasos `#`, nome terminando em `_tb`) somam pontos; passando do limiar, o arquivo é testbench, senão é sintetizável. Arquivos `.py` são sempre testbenches cocotb. A classificação se refaz a cada atualização da árvore, então um arquivo editado pode mudar de categoria sozinho.

O que a classificação não escolhe é o papel de raiz, e isso é seu:

Top Level
: O módulo raiz do circuito sintetizável. Define de onde a elaboração parte e o que o PRISM desenha. Marque pelo menu de contexto do arquivo na visão Arquivos: {guilabel}`Definir como Top Level`.

Testbench Top
: O arquivo que comanda a simulação, {file}`.v` ou {file}`.py`. Define o que roda quando você clica em {guilabel}`Analisar Verilog`. Marque por {guilabel}`Marcar como Testbench`.

```{list-table}
:widths: 50 50
:align: center

* - **Top Level**

    ```{image} ../_static/assets/screenshots/aurora-top-level.png
    :alt: Arquivo Verilog marcado como Top Level na árvore de arquivos.
    :width: 100%
    ```
  - **Testbench Top**

    ```{image} ../_static/assets/screenshots/aurora-top-testbench.png
    :alt: Arquivo de teste marcado como Testbench Top na árvore de arquivos.
    :width: 100%
    ```
```

Os dois papéis são exclusivos: marcar um arquivo desmarca o anterior. A barra de status mostra os dois o tempo todo.

## Importar e criar arquivos

Arraste arquivos {file}`.v`, {file}`.sv`, {file}`.vh` ou {file}`.py` de fora para a árvore, ou use o menu de contexto da área vazia: {guilabel}`Novo arquivo`, {guilabel}`Novo testbench cocotb (.py)`, {guilabel}`Novo .gitignore`. Na visão Pastas, o menu de contexto oferece o conjunto completo de operações de disco, com lixeira e desfazer.

## Backup

O botão de backup no cabeçalho da árvore gera {file}`Backup/<projeto>_<data>.zip` com tudo, exceto os backups anteriores. É a forma rápida de congelar um estado antes de uma mudança grande. Para histórico de verdade, o painel de controle de versão está em {doc}`apoio`.

Pronto para trabalhar. A Parte II começa criando um projeto Verilog do zero: {doc}`../verilog/tutorial-contador`.
