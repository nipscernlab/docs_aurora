# Simulação do processador

Um processador SAPHO se simula pelos mesmos botões e chaves de {doc}`../verilog/ondas`, com três superpoderes específicos: as suas variáveis aparecem pelo nome, duas trilhas de texto acompanham a execução, e existe um modo de teste rápido só de entrada e saída.

## Os três jeitos de rodar

{guilabel}`Analisar Verilog`
: O caminho completo: compila, simula o Testbench Top e abre a forma de onda.

{guilabel}`Execução rápida`
: Roda sem gravar onda. Para quando você só quer os arquivos de saída ou o veredito dos testes cocotb.

{guilabel}`Teste do processador sintetizado`
: O mais direto para processadores: pega o processador ativo, monta um executor nativo com o Verilator e roda só a interface de entrada e saída, lendo {file}`input_N.txt` e escrevendo {file}`output_N.txt`, com barra de progresso no terminal **THTEST**. Serve para validar o comportamento com muitos dados, rápido. O fim do programa é detectado por um marcador que a AURORA injeta no {file}`.cmm` (a diretiva `#TOAQUI`, que cria o pino `cheguei`).

```{figure} ../_static/assets/screenshots/aurora-teste-hardware.png
:alt: Terminal THTEST com as etapas do teste e a barra de progresso.
:width: 90%
:align: center
```

:::{note}
Com o Verilator, os sinais internos do processador (núcleo, pilhas, ULA) ficam fora da onda; as suas variáveis continuam visíveis. Para ver o processador por dentro, use o Icarus.
:::

## As variáveis pelo nome

Como toda memória do C± é estática, cada variável do seu programa vira um sinal nomeado na onda: `soma`, `x[0]`, `x[1]`. Vetores aparecem elemento a elemento quando a opção {guilabel}`Mostrar arrays` está ligada na engrenagem do processador. Floats aparecem decodificados como número real, e complexos no formato `a + bi`.

## As trilhas Assembly e C±

Na onda de um processador, duas trilhas de texto acompanham o clock: o mnemônico da instrução em execução e a linha do {file}`.cmm` correspondente. É o vínculo mais direto entre o código e o circuito: dá para seguir um `while` acontecendo, ciclo a ciclo.

```{figure} ../_static/assets/screenshots/aurora-gtkwave-media-movel.png
:alt: Onda com as trilhas de assembly e de linha C± visíveis.
:width: 100%
:align: center
```

## Onde os resultados ficam

| Arquivo | Conteúdo |
|---|---|
| {file}`Simulation/input_N.txt` | estímulo da porta de entrada N, um inteiro por linha (você escreve) |
| {file}`Simulation/output_N.txt` | o que o programa escreveu na porta N (a simulação gera) |
| o arquivo de onda | os sinais gravados, aberto pelo visualizador |

Os {file}`output_N.txt` são a ponte para a análise externa: planilha, script Python, comparação com um modelo de referência.

## Exercícios

1. Rode o filtro do tutorial com o {guilabel}`Teste do processador sintetizado` alimentando mil amostras (gere o {file}`input_0.txt` com um script) e confira o {file}`output_0.txt` contra uma média móvel calculada em Python.
2. Na onda, siga uma iteração completa do `while` pela trilha C±: identifique em que ciclos acontecem as quatro cópias do histórico, a leitura da porta e a escrita.
3. Aumente o clock configurado de 100 para 200 MHz na engrenagem e observe o que muda (e o que não muda) na simulação.
