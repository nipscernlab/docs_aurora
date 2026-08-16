# Simulação e formas de onda

Um processador SAPHO se simula pelos mesmos botões do fluxo Verilog, com alguns superpoderes a mais: as suas variáveis aparecem pelo nome na onda, e duas trilhas de texto mostram a instrução assembly e a linha C± executadas a cada ciclo.

## Os três jeitos de simular

{guilabel}`Analisar Verilog`
: O caminho completo: compila, simula o Testbench Top e abre a forma de onda. Use quando quiser ver sinais.

{guilabel}`Execução rápida`
: Roda o testbench sem gravar onda. Ideal para o ciclo de ajuste fino quando você só quer os arquivos de saída ou o veredito dos testes cocotb. Disponível com Verilator selecionado ou testbench em Python.

{guilabel}`Teste do processador sintetizado`
: O mais direto para processadores: pega o processador ativo, monta um executor nativo com o Verilator e roda só a interface de entrada e saída, lendo {file}`input_N.txt` e escrevendo {file}`output_N.txt`, com barra de progresso no terminal **THTEST**. Sem onda e sem testbench: serve para validar o comportamento com muitos dados, rápido. O fim do programa é detectado por um marcador que a AURORA injeta no {file}`.cmm` (a diretiva `#TOAQUI`, que cria o pino `cheguei` no hardware).

```{figure} ../_static/assets/screenshots/aurora-teste-hardware.png
:alt: Terminal THTEST com as etapas do teste e a barra de progresso.
:width: 90%
:align: center
```

## Icarus ou Verilator

A chave da barra de ferramentas vale também para processadores, com uma diferença que importa:

- **Icarus** enxerga tudo: variáveis, pilhas, sinais internos do núcleo. É a escolha para depurar de perto.
- **Verilator** é muito mais rápido, mas os sinais internos do processador ficam fora da onda por construção. As suas variáveis continuam visíveis. A AURORA avisa quando essa limitação afeta o que você selecionou.

## Configuração de ondas

O modal {guilabel}`Configuração de ondas` escolhe quais sinais a simulação grava. Menos sinais, simulação mais leve e arquivo menor.

```{figure} ../_static/assets/screenshots/aurora-wave-config.png
:alt: Modal de configuração de ondas com a árvore de sinais.
:width: 85%
:align: center

A árvore reflete a hierarquia do projeto. O filtro aceita texto e expressão regular, e a opção de mostrar só sinais de processador reduz a lista ao que costuma importar.
```

A seleção vale por testbench e segue uma ordem de precedência: um arquivo de layout ativo no seletor da barra vence a configuração do modal, que vence um `$dumpvars` escrito à mão no testbench, que vence o padrão (tudo no escopo do módulo do testbench).

## O layout do visualizador

Ao abrir o GTKWave, a AURORA gera um layout com os sinais agrupados: clock e reset, portas, as variáveis do seu programa, as pilhas, e as trilhas decodificadas. Para o Surfer, o equivalente.

Se você reorganizar os sinais no GTKWave e salvar um {file}`.gtkw` (File, Write Save File), registre-o no seletor da barra de ferramentas: ele passa a ser o layout daquele testbench, e o botão {guilabel}`padrão` volta ao automático quando quiser.

```{figure} ../_static/assets/screenshots/aurora-gtkw-picker.png
:alt: Seletor de arquivo de layout aberto na barra de ferramentas.
:width: 60%
:align: center
```

## As trilhas Assembly e C±

Na onda de um processador SAPHO, duas trilhas de texto acompanham o clock: uma mostra o mnemônico da instrução em execução, a outra mostra a linha do seu arquivo {file}`.cmm` correspondente. É o vínculo mais direto entre o código que você escreveu e o circuito que ele virou: dá para seguir um laço `while` acontecendo, ciclo a ciclo.

```{figure} ../_static/assets/screenshots/aurora-gtkwave-media-movel.png
:alt: Onda com as trilhas de assembly e de linha C± visíveis.
:width: 100%
:align: center
```

## Surfer

O Surfer é o visualizador alternativo, moderno e rápido. A chave na barra troca o destino das ondas; os layouts dele têm extensão própria e o mesmo seletor os gerencia. Há uma opção na configuração de ondas para manter janelas antigas abertas, útil para comparar duas simulações lado a lado.

```{figure} ../_static/assets/screenshots/aurora-surfer.png
:alt: Surfer aberto com uma forma de onda do projeto.
:width: 100%
:align: center
```

## Onde os resultados ficam

| Arquivo | Conteúdo |
|---|---|
| {file}`Simulation/input_N.txt` | estímulo da porta de entrada N, um inteiro por linha (você escreve) |
| {file}`Simulation/output_N.txt` | tudo o que o programa escreveu na porta N (a simulação gera) |
| o arquivo de onda | os sinais gravados, aberto pelo visualizador |

Os {file}`output_N.txt` são a ponte para a análise externa: uma planilha, um script Python, uma comparação com o modelo de referência.
