# Formas de onda

A forma de onda é o osciloscópio do projetista digital: cada sinal ao longo do tempo, ciclo a ciclo. Este capítulo cobre as escolhas que valem para qualquer projeto; o que é específico de processadores SAPHO (as trilhas de assembly e de linha C±) está em {doc}`../sapho/simulacao`.

## Icarus ou Verilator

A chave na barra de ferramentas escolhe o motor de simulação:

| | Icarus Verilog | Verilator |
|---|---|---|
| Velocidade | referência | 10 a 100 vezes mais rápido |
| Sinais visíveis | todos | sinais internos de processadores SAPHO ficam de fora |
| Uso típico | ondas curtas, depuração fina | testbenches longos, regressões |

A troca vale na próxima simulação, e a barra de status mostra o motor atual.

## GTKWave ou Surfer

A segunda chave escolhe o visualizador. O GTKWave é o clássico; o Surfer é o alternativo, moderno e rápido. Os dois abrem em janela própria com o layout preparado pela AURORA: sinais agrupados, nomeados e coloridos, em vez do despejo bruto.

```{figure} ../_static/assets/screenshots/aurora-surfer.png
:alt: Surfer aberto com uma forma de onda.
:width: 100%
:align: center
```

## Escolher o que gravar

O modal {guilabel}`Configuração de ondas` define quais sinais a simulação grava. Menos sinais, simulação mais leve e arquivo menor.

```{figure} ../_static/assets/screenshots/aurora-wave-config.png
:alt: Modal de configuração de ondas com a árvore de sinais.
:width: 85%
:align: center

A árvore reflete a hierarquia do projeto; o filtro aceita texto e expressão regular.
```

A seleção vale por testbench e segue uma precedência: um arquivo de layout ativo vence a configuração do modal, que vence um `$dumpvars` escrito à mão no testbench, que vence o padrão (tudo no escopo do módulo do testbench).

## Layouts salvos

Organizou os sinais do seu jeito no GTKWave? Salve um {file}`.gtkw` (File, Write Save File) e registre-o no seletor da barra de ferramentas: ele vira o layout daquele testbench. O item {guilabel}`padrão` volta ao layout automático. Com o Surfer, o mesmo seletor gerencia os arquivos de layout dele.

```{figure} ../_static/assets/screenshots/aurora-gtkw-picker.png
:alt: Seletor de arquivo de layout aberto.
:width: 60%
:align: center
```

## Exercícios

1. No projeto do contador, abra a {guilabel}`Configuração de ondas`, grave só `clk`, `habilita` e `conta`, e compare o tamanho do arquivo de onda com a gravação completa.
2. No GTKWave, reordene os sinais, troque a base de `conta` para decimal, salve um {file}`.gtkw` e registre-o no seletor. Rode de novo e confirme que o layout voltou como você deixou.
3. Rode a mesma simulação com Icarus e com Verilator e compare o tempo relatado no terminal TWAVE.
