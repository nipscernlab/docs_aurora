# Folha de consulta rápida

Uma página para deixar na bancada. Imprima pelo navegador ou pelo PDF do manual.

## O fluxo

```{mermaid}
flowchart LR
  CMM[".cmm"] -->|"Compilar C±"| HW[".v + .mif"]
  V["seus .v"] --> VAL
  HW --> VAL["Sintetizar Verilog"]
  VAL --> SIM["Analisar Verilog"]
  SIM --> ONDA["forma de onda"]
  VAL --> PRISM["PRISM"]
```

## Os botões e seus pré-requisitos

| Botão | Faz | Exige |
|---|---|---|
| {guilabel}`Compilar C±` | C± até Verilog e memórias | um {file}`.cmm` em foco |
| {guilabel}`Sintetizar Verilog` | valida a elaboração, gera a hierarquia | Top Level |
| {guilabel}`Analisar Verilog` | simula e abre a onda | Testbench Top |
| {guilabel}`Execução rápida` | simula sem onda | Testbench Top e Verilator (ou testbench .py) |
| {guilabel}`Teste do processador sintetizado` | roda só a E/S, com arquivos | processador ativo |
| {guilabel}`Abrir PRISM` | desenha o circuito | Top Level |
| {guilabel}`Cancelar` | interrompe o que roda | nada |

## Os papéis

| Termo | Significa | Onde se define |
|---|---|---|
| Top Level | módulo raiz do circuito | botão direito no {file}`.v`, visão Arquivos |
| Testbench Top | quem comanda a simulação | botão direito no {file}`.v` ou {file}`.py` |
| Processador ativo | o {file}`.cmm` em foco no editor | abrir o arquivo |

A barra de status mostra os três o tempo todo.

## Arquivos de um processador

```text
<proc>/Software/<proc>.cmm       voce escreve
<proc>/Hardware/<proc>.v + .mif  a compilacao gera (levar ao FPGA)
<proc>/Simulation/input_N.txt    estimulo, um inteiro por linha
<proc>/Simulation/output_N.txt   resultado da simulacao
```

## A regra de ouro do Hub

`Total de bits = mantissa + expoente + 1`

## Atalhos que mais valem

| | |
|---|---|
| {kbd}`Ctrl+S` salvar | {kbd}`Ctrl+Shift+F` buscar nos arquivos |
| {kbd}`Ctrl+Shift+K` paleta de comandos | {kbd}`Ctrl+K` assistente de IA |
| {kbd}`Shift+Alt+F` formatar | {kbd}`F12` ir à definição |

## Quando algo der errado

Leia a primeira mensagem de erro, não a última; clique no link de linha; e {doc}`diagnostico` tem os sintomas mais comuns.
