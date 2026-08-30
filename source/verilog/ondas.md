# Formas de onda

A forma de onda é o osciloscópio do projetista digital: cada sinal ao longo do tempo, ciclo a ciclo. Este capítulo cobre as escolhas que valem para qualquer projeto; o que é específico de processadores SAPHO (as trilhas de assembly e de linha C±) está em {doc}`../sapho/simulacao`.

## Icarus ou Verilator

A chave na barra de ferramentas escolhe o motor de simulação:

| | Icarus Verilog | Verilator |
|---|---|---|
| Velocidade | referência | 10 a 100 vezes mais rápido |
| Sinais visíveis | todos | quase todos: os monitores didáticos dos processadores SAPHO (pilhas, ULA) entram por espelhos no testbench; o miolo mais profundo fica de fora |
| Uso típico | ondas curtas, depuração fina | testbenches longos, regressões |

A troca vale na próxima simulação, e a barra de status mostra o motor atual.

## GTKWave ou Surfer

A segunda chave escolhe o visualizador. O GTKWave é o clássico e abre em janela própria; o Surfer é o moderno e abre como **aba do próprio editor**, ao lado dos fontes — a onda e o código na mesma janela. Nos dois casos o layout chega preparado pela AURORA: sinais agrupados, nomeados e coloridos, em vez do despejo bruto.

Quem preferir o Surfer em janela própria troca em {guilabel}`Configurações`, aba {guilabel}`Geral`, {guilabel}`Onde o Surfer abre`; a aba é o padrão. E trabalhar na aba tem uma vantagem a mais: salvar ali de dentro grava o estado no projeto e o registra como layout ativo daquele testbench, e a próxima simulação abre a onda do jeito que você deixou.

```{figure} ../_static/assets/screenshots/aurora-surfer.png
:alt: Surfer aberto como aba do editor, ao lado dos fontes.
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

Sob o Verilator há uma diferença de grão, que o próprio modal avisa: ele grava por **escopo**, não por sinal. Todo sinal público de um módulo com ao menos um sinal selecionado entra no dump; módulos sem nada selecionado ficam fora; o escopo do testbench é sempre gravado. A seleção continua valendo — ela decide quais módulos entram —, só não desce ao sinal individual.

## Layouts salvos

Organizou os sinais do seu jeito no GTKWave? Salve um {file}`.gtkw` (File, Write Save File) e registre-o no seletor da barra de ferramentas: ele vira o layout daquele testbench. O item {guilabel}`padrão` volta ao layout automático. Com o Surfer, o mesmo seletor gerencia os arquivos de layout dele. A Aurora Intelligence também sabe **criar** um layout sob encomenda: peça no chat os sinais e a organização que quer, e ela grava o arquivo e o registra no seletor.

```{figure} ../_static/assets/screenshots/aurora-gtkw-picker.png
:alt: Seletor de arquivo de layout aberto.
:width: 60%
:align: center
```

## Exercícios

1. No projeto do contador, abra a {guilabel}`Configuração de ondas`, grave só `clk`, `habilita` e `conta`, e compare o tamanho do arquivo de onda com a gravação completa.
2. No GTKWave, reordene os sinais, troque a base de `conta` para decimal, salve um {file}`.gtkw` e registre-o no seletor. Rode de novo e confirme que o layout voltou como você deixou.
3. Rode a mesma simulação com Icarus e com Verilator e compare o tempo relatado no terminal TWAVE.
