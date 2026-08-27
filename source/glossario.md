# Glossário

AURORA
: A IDE da plataforma SAPHO: editor, projetos, compilação, simulação e visualização em uma janela.

C±
: A linguagem de descrição de algoritmos, dialeto reduzido de C, em arquivos {file}`.cmm`.

cocotb
: Framework de testbenches em Python: o simulador roda o circuito, o Python dirige os sinais.

Componente
: Uma ferramenta que a AURORA baixa por demanda em vez de trazer no instalador: a cadeia de compilação, os visualizadores de onda, os agentes de IA. Gerenciados em Configurações, aba Componentes.

Fonte sintetizável
: Arquivo Verilog classificado como parte do circuito. A classificação é automática, pelo conteúdo.

Git-D
: O painel de controle de versão da AURORA, com contas GitHub e GitLab. Chamava-se Dagr até a versão 6.4; só o nome mudou.

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
: O visualizador de ondas alternativo ao GTKWave; abre como aba dentro do próprio editor.

Testbench
: O código que exercita o circuito na simulação, em Verilog ou Python.

Testbench Top
: O testbench marcado como raiz da simulação; alvo do botão {guilabel}`Analisar Verilog`.

Top Level
: O módulo raiz do circuito sintetizável; ponto de partida da elaboração e do PRISM.

Verilator
: Simulador compilado, muito mais rápido; grava a onda por escopo, e o miolo mais profundo dos processadores fica de fora (os monitores de pilha e ULA entram por espelhos no testbench).

YANC
: A suíte de compiladores que transforma C± em processador: tradutor, pré-montador e montador gerador de hardware.
