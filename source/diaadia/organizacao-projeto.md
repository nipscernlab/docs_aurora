# Organização de um projeto

Um projeto é uma pasta no disco governada por um arquivo {file}`.spf` (*SAPHO Project File*). Tudo o que a AURORA sabe sobre o projeto está nele: quais arquivos participam, qual é o Top Level, qual é o Testbench Top e quais processadores existem.

## A pasta

Um projeto que já tem um processador e alguns fontes Verilog fica assim:

```text
MeuProjeto/
├── MeuProjeto.spf              o arquivo do projeto
├── contador.v                  fonte Verilog importado
├── tb_contador.v               testbench importado
├── media_movel/                um processador SAPHO: o que você escreve
│   ├── media_movel.cmm         o programa (ou media_movel.cpp)
│   ├── input_0.txt             estímulo da porta de entrada 0
│   └── media_movel/            a pasta de saída: tudo o que o YANC gera
│       ├── media_movel.asm
│       ├── media_movel.v
│       ├── media_movel_inst.mif
│       ├── media_movel_data.mif
│       ├── media_movel_tb.v
│       └── output_0.txt        o que a simulação do processador escreveu
├── testbench/                  estado de ondas por testbench
├── .aurora/                    registros da AURORA (histórico de execuções)
└── Backup/                     zips gerados pelo botão de backup
```

O projeto nasce só com o {file}`.spf`. A pasta de um processador aparece quando você o cria no Hub, só com o fonte dentro; a pasta de saída, com o mesmo nome do processador, o YANC cria na primeira compilação. As demais aparecem conforme o uso.

Cada processador tem, então, duas pastas:

- {file}`media_movel/` guarda o que **você escreve**: o fonte, os arquivos que inicializam vetores e os {file}`input_N.txt` (e os {file}`cade_k.txt`, se o processador usar links; veja {doc}`../sapho/linguagem`);
- {file}`media_movel/media_movel/` guarda o que **o YANC gera**: o assembly, o Verilog, as memórias, o testbench, as tabelas da forma de onda e as saídas da simulação. Não escreva nada lá dentro: a próxima compilação sobrescreve.

O nome do processador é o nome do arquivo fonte, e vira o nome do módulo Verilog. Por isso ele só aceita letras sem acento, dígitos e `_`, não pode começar com dígito nem com `__`, e não pode ser uma palavra reservada do Verilog (`wire`, `module`, `begin`...). A AURORA confere isso ao criar e ao renomear. Para renomear um processador, use a opção da árvore ou do Hub: ela troca a pasta, o fonte e a pasta de saída juntos.

## Projetos de versões antigas

Antes do YANC 7.1, cada processador tinha três subpastas, {file}`Software/`, {file}`Hardware/` e {file}`Simulation/`, e o nome do módulo vinha da diretiva `#PRNAME`. O compilador novo não aceita mais nenhuma das duas coisas. Ao abrir um projeto assim, a AURORA pergunta, uma vez, se pode convertê-lo:

- o que você escreveu (o fonte, os arquivos de vetor, os {file}`input_N.txt`, um {file}`.v` seu que estivesse em {file}`Hardware/`) vai para a pasta do processador;
- o que o YANC tinha gerado vai para a pasta de saída;
- nada é apagado e nada é sobrescrito: se o destino já existe, o arquivo fica onde estava e aparece no relatório;
- a linha `#PRNAME` sai do fonte, e o {file}`.spf` passa a apontar para os lugares novos.

No fim, um relatório lista o que foi movido e o que ficou. Se o `#PRNAME` antigo dava ao módulo um nome diferente do nome da pasta, o relatório oferece renomear o processador para esse nome, para o seu top-level continuar achando o módulo. O mesmo vale para um nome que não serve mais (com hífen ou acento). Quem responder {guilabel}`Agora não` pode converter depois, abrindo o projeto de novo; até lá ele não compila.

## Projetos de exemplo

Quem prefere partir de algo pronto tem o botão {guilabel}`Projetos de exemplo...` na tela de boas-vindas: ele pergunta só onde salvar e cria **cinco projetos completos**, cada um com o seu {file}`.spf` e o testbench já registrado, todos dentro de uma pasta {file}`exemplos-sapho`. Os cinco entram na lista de recentes, do mais simples para o mais completo:

1. **Contador em Verilog** — Verilog puro, sem processador; o caminho mais curto para ver a AURORA elaborar e simular.
2. **Média móvel** — o processador do {doc}`tutorial <../sapho/tutorial-filtro>`, em aritmética inteira.
3. **Trigonometria** — ponto flutuante: seno, cosseno e arco-tangente.
4. **Notação de Dirac** — a álgebra linear escrita como na física, uma operação por linha.
5. **Cruzamento por zero** — duas entradas, cinco saídas, filtros IIR e o endereçamento de porta.

Os fontes viajam dentro do aplicativo, então o botão funciona sem internet. Instalar de novo na mesma pasta não sobrescreve nada: o que já existe é respeitado. A Aurora Intelligence conhece os cinco e também sabe criá-los, a pedido, pelo chat.

Em desenho, o caminho de um arquivo até o hardware:

```{mermaid}
flowchart TB
  subgraph P["MeuProjeto/"]
    SPF["MeuProjeto.spf<br><i>quem é top level, quem é testbench</i>"]
    V["contador.v, tb_contador.v<br><i>Verilog escrito à mão</i>"]
    subgraph PROC["media_movel/ (um processador)"]
      direction LR
      SW["media_movel/<br><b>você escreve</b><br>.cmm, input_N.txt"]
      OUT["media_movel/media_movel/<br><b>YANC gera</b><br>.asm, .v, .mif, testbench, saídas"]
      SW -->|compilar e simular| OUT
    end
  end
  SPF -.governa.- PROC
  SPF -.governa.- V
```

:::{warning}
**Escolha bem o caminho da pasta.** As ferramentas de linha de comando que rodam por baixo (compiladores, Icarus, Verilator, Yosys) recebem esse caminho como argumento, e várias delas engasgam com acentos, espaços duplos, cedilha, `#`, `&`, `%` ou parênteses. O sintoma é ruim de diagnosticar: um erro estranho de arquivo não encontrado, vindo de uma etapa que não tem nada a ver com o seu código.

Use letras sem acento, números, hífen e sublinhado. `C:\Projetos\meu_filtro` está bom; `C:\Meus Projetos (2026)\Simulação #1` não. Vale para o nome do projeto e para toda a árvore de pastas acima dele, inclusive o nome de usuário do Windows. O compilador e os simuladores já aceitam acento no caminho; o espaço continua sendo o que mais atrapalha, porque o Verilator não aceita espaço no caminho do projeto. O nome do processador tem regra mais estrita, descrita acima.
:::

## O arquivo .spf

É um JSON legível. Guarda o nome e o caminho base do projeto, a lista de processadores com suas configurações de simulação, as listas de fontes sintetizáveis e de testbenches, e os dois ponteiros centrais: `topLevelFile` e `testbenchFile`. Caminhos dentro do projeto são gravados relativos, então o projeto pode ser movido ou copiado de máquina para máquina sem quebrar.

:::{tip}
O {file}`.spf` abre no editor como JSON com realce. Ler o seu é uma boa forma de entender o que a AURORA registra. Editar à mão raramente é necessário; a interface cuida dele.
:::

:::{warning}
Os parâmetros de arquitetura do processador (largura de bits, mantissa, portas) não ficam no {file}`.spf`. Eles vivem nas diretivas no topo do arquivo {file}`.cmm` (ou nos `#pragma yanc` do {file}`.cpp`), que é a fonte da verdade: editar uma diretiva muda o processador na próxima compilação. No {file}`.spf` ficam apenas as preferências de simulação de cada processador (clock, número de ciclos).
:::

(sintetizavel-ou-testbench-quem-decide-e-o-conteudo)=

## Sintetizável ou testbench: quem decide é você

Todo arquivo Verilog do projeto tem um papel, guardado no {file}`.spf`: **sintetizável** (entra na elaboração e no PRISM), **testbench**, ou **sem papel**. Um arquivo novo ou importado entra sem papel, com um ponto de interrogação no ícone, e fica fora de toda compilação até você escolher, pelo botão direito do mouse. Antes de compilar, o terminal lista os arquivos que ficaram de fora por não ter papel. Arquivos `.py` entram como testbenches cocotb, e o que o YANC gera já nasce com o papel certo: o {file}`<proc>.v` é sintetizável e o {file}`<proc>_tb.v` é testbench. Nada muda de papel sozinho.

Além do papel, há o papel de raiz, que também é seu:

```{figure} ../_static/assets/screenshots/aurora-arvore-menu-contexto.png
:alt: Menu de contexto de um arquivo Verilog com a opcao Definir como Top Level.
:width: 45%
:align: center

O menu de contexto de um {file}`.v` sintetizável na visão Arquivos.
```

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
