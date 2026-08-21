# Glossário

AURORA
: A IDE da plataforma SAPHO: editor, projetos, compilação, simulação e visualização em uma janela.

C±
: A linguagem de descrição de algoritmos, dialeto reduzido de C, em arquivos {file}`.cmm`.

cocotb
: Framework de testbenches em Python: o simulador roda o circuito, o Python dirige os sinais.

Fonte sintetizável
: Arquivo Verilog classificado como parte do circuito. A classificação é automática, pelo conteúdo.

Icarus Verilog
: Simulador interpretado, o padrão para ondas curtas; enxerga todos os sinais.

MIF
: Imagem de memória em texto ({file}`_inst.mif` para o programa, {file}`_data.mif` para os dados), carregada pelo processador na inicialização e usada também na síntese em FPGA.

Notação de Dirac
: Sintaxe vetorial do C± (`⟨a|b⟩`, `a # |M|b⟩`) que desenrola álgebra linear em código de linha reta.

Processador ativo
: O processador cujo {file}`.cmm` está em foco no editor. É o alvo do botão C±, da engrenagem e do teste de hardware, e aparece na barra de status.

PRISM
: O visualizador de circuito: desenha o RTL elaborado como diagrama navegável.

Processador SAPHO
: O núcleo gerado pelo YANC: acumulador único, memórias separadas de programa e dados, e apenas os blocos que o programa usa.

SAPHO
: A plataforma completa (e o nome do processador que ela gera).

spf
: *SAPHO Project File*, o JSON que define um projeto: fontes, papéis, processadores.

Surfer
: O visualizador de ondas alternativo ao GTKWave.

Testbench
: O código que exercita o circuito na simulação, em Verilog ou Python.

Testbench Top
: O testbench marcado como raiz da simulação; alvo do botão {guilabel}`Analisar Verilog`.

Top Level
: O módulo raiz do circuito sintetizável; ponto de partida da elaboração e do PRISM.

Verilator
: Simulador compilado, muito mais rápido; não expõe os sinais internos dos processadores na onda.

YANC
: A suíte de compiladores que transforma C± em processador: tradutor, pré-montador e montador gerador de hardware.
