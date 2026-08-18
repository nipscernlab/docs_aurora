# Testbenches: Verilog e cocotb

Um testbench é o programa que exercita o circuito na simulação: gera clock e reset, aplica estímulos, observa saídas e decide quando parar. Na AURORA ele pode ser escrito em Verilog ou em Python, com o cocotb. Este capítulo cobre os dois.

## Anatomia de um testbench Verilog

O do tutorial serve de modelo:

- **Clock**: `always #5 clk = ~clk;` gera 100 MHz com `timescale 1ns/1ps`.
- **Reset**: comece em 1 e solte fora da borda de clock, para o circuito nascer em estado conhecido.
- **Estímulos**: um bloco `initial` com atrasos `#` sequenciando os eventos.
- **Gravação**: `$dumpfile` e `$dumpvars` escolhem o arquivo e os sinais gravados. Se o seu testbench já os traz, a AURORA os respeita; se não traz, ela os injeta com uma seleção padrão, e o modal {guilabel}`Configuração de ondas` permite refinar sem editar o arquivo.
- **Término**: `$finish` encerra. Sem ele, a simulação corre até o limite e o visualizador abre com o que houver.

:::{tip}
O testbench original nunca é modificado pela AURORA. Quando é preciso instrumentar (para injetar a gravação de ondas, por exemplo), uma cópia é gerada na área temporária e é ela que compila. O seu arquivo permanece como você escreveu.
:::

A escolha entre os motores Icarus e Verilator, os visualizadores e a seleção de sinais estão no capítulo anterior, {doc}`ondas`.

## Testbench em Python: cocotb

Com o cocotb, o testbench é um módulo Python: o simulador roda o circuito e o Python dirige os sinais. A vantagem é usar a linguagem inteira na verificação, incluindo bibliotecas de análise.

Crie pelo menu de contexto da árvore: {guilabel}`Novo testbench cocotb (.py)`. O modelo gerado já traz a estrutura:

:::{note}
Na primeira execução de um testbench cocotb o simulador precisa ser construído, e a AURORA gera um executável a partir do seu Verilog antes de rodar o Python. Isso leva alguns segundos e aparece no terminal TWAVE; da segunda vez em diante o executável é reaproveitado, e só é refeito quando o Verilog muda. Se o antivírus do Windows perguntar sobre esse executável recém-criado dentro da pasta do projeto, é ele.
:::

```{code-block} python
:caption: teste_contador.py
:linenos:

# aurora-toplevel: contador

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer


@cocotb.test()
async def test_contador(dut):
    dut.clk.value = 0
    dut.rst.value = 1
    dut.habilita.value = 0
    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    await Timer(12, unit="ns")
    dut.rst.value = 0

    await Timer(8, unit="ns")
    dut.habilita.value = 1

    await Timer(200, unit="ns")
    dut.habilita.value = 0

    await Timer(40, unit="ns")
```

```{figure} ../_static/assets/screenshots/aurora-testbench-cocotb.png
:alt: Editor com um testbench cocotb e a diretiva aurora-toplevel na primeira linha.
:width: 90%
:align: center

A primeira linha importa: o comentário `# aurora-toplevel: contador` diz qual módulo Verilog é o alvo do teste. Fora da AURORA a linha é um comentário inerte.
```

Marque o {file}`.py` como Testbench Top e use os mesmos botões de sempre: {guilabel}`Analisar Verilog` roda os testes e abre a onda; {guilabel}`Execução rápida` roda sem gravar onda, ideal para o ciclo de ajuste.

```{figure} ../_static/assets/screenshots/aurora-fast-sim.png
:alt: Terminal TWAVE com o resultado dos testes cocotb em uma execução rápida.
:width: 90%
:align: center

Na execução rápida, o veredito de cada teste sai no terminal TWAVE.
```

Três coisas que valem saber:

- Nada de Makefile: a AURORA monta e executa o projeto cocotb sozinha, com o Python embarcado. Você escreve só as funções `@cocotb.test()`.
- Teste que falha não esconde a onda: se a simulação rodou e as asserções falharam, o erro aparece em vermelho e a forma de onda abre mesmo assim, porque é nela que se investiga.
- Bibliotecas extras (pyuvm, extensões de barramento, análise de VCD) se instalam pelo painel {guilabel}`Bibliotecas Python`, descrito em {doc}`../diaadia/apoio`.

## Verilog ou cocotb?

Para exercícios curtos e primeiros contatos, o testbench Verilog é mais direto: tudo em um arquivo, sem camadas. O cocotb compensa quando a verificação cresce: laços de referência em Python, comparação com modelos, geração de estímulos complexos. Os dois convivem no mesmo projeto; o Testbench Top decide qual roda.
