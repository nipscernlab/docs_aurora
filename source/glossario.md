# Glossário

Os termos usados de forma consistente neste manual. Quando a interface mantém um nome em inglês, o termo é preservado para facilitar a localização na AURORA.

```{glossary}
:sorted:

SAPHO
  *Scalable-Architecture Processor for Hardware Optimization*. O processador *soft-core* e, por extensão, a plataforma completa e o canal de distribuição.

AURORA
  *Advanced Utility Running Optimized Resource Architectures*. A IDE de desktop da plataforma, e a única interface gráfica do ecossistema.

YANC
  *Yet Another Compiler*. A suíte de compiladores que traduz C± e C++ em processador Verilog, imagens de memória e *testbench*.

C±
  A linguagem de programação da plataforma, um dialeto de C com complexos nativos e notação de Dirac. Arquivos com extensão {file}`.cmm`. Lê-se "C mais-menos".

PRISM
  *Processor Rendering Interface for Schematic Models*. O visualizador de RTL da AURORA, apoiado no Yosys e no netlistsvg.

Aurora Intelligence
  A assistente de inteligência artificial integrada à AURORA, capaz de conversar sobre o projeto e de agir sobre a IDE por ferramentas com permissão controlada.

Dagr
  O painel de controle de versão da AURORA. Do nórdico antigo, "dia"; o painel usa a runa *dagaz* como marca.

NIPS-CERN
  O Núcleo de Instrumentação e Processamento de Sinais da UFJF, em parceria com o CERN. O laboratório que desenvolve a plataforma.

soft-processor
  Processador descrito em HDL e implementado na malha reconfigurável de um FPGA. Também dito *soft-core*.

FPGA
  *Field-Programmable Gate Array*. Circuito integrado cujas conexões internas podem ser reprogramadas depois da fabricação.

HDL
  *Hardware Description Language*. A classe de linguagens usadas para descrever circuitos, à qual pertencem o Verilog e o VHDL.

Verilog
  A linguagem de descrição de *hardware* usada pela plataforma.

RTL
  *Register-Transfer Level*. O nível de abstração em que o circuito é descrito como transferências entre registradores.

.spf
  *SAPHO Project File*. O arquivo JSON que define um projeto: metadados, processadores, pastas, *top-level* e *testbench*.

.asm
  O *assembly* intermediário do SAPHO, entre o compilador e o montador.

.mif
  *Memory Initialization File*. Imagem de memória, de programa ou de dados, embutida no circuito gerado.

testbench
  O banco de testes da simulação, em Verilog ({file}`_tb.v`) ou em Python com cocotb, que aplica estímulos ao circuito e confere as respostas.

top-level
  O módulo Verilog que integra os processadores e blocos do projeto. É o topo da síntese e o alvo do PRISM.

ULA
  Unidade lógica e aritmética. No SAPHO, apenas os operadores usados pelo programa são instanciados nela.

ACC
  O acumulador, registrador central do processador e destino de toda operação da ULA.

Harvard
  Arquitetura com memórias de programa e de dados fisicamente separadas, cada uma com o seu barramento.

ISA
  *Instruction Set Architecture*. O conjunto de instruções do processador.

pipeline
  O encadeamento de estágios pelos quais uma instrução passa. No SAPHO são três: busca, decodificação e execução.

Icarus Verilog
  O simulador de Verilog padrão da plataforma. Compila com o `iverilog` e executa com o `vvp`.

Verilator
  Simulador de alto desempenho que converte o circuito em executável nativo em C++.

cocotb
  *Coroutine cosimulation testbench*. Arcabouço Python para a escrita de *testbenches*, executado em cossimulação com o Icarus ou o Verilator.

Yosys
  A ferramenta de síntese usada pelo PRISM e pela visão Hierarquia da árvore de arquivos.

GTKWave
  Visualizador de formas de onda padrão, em *fork* próprio do laboratório com tema escuro e ajustes de usabilidade.

Surfer
  Visualizador de formas de onda opcional, escrito em Rust, no *fork* `surfer-aurora`.

VCD
  *Value Change Dump*. Formato textual de arquivo de formas de onda.

FST
  *Fast Signal Trace*. Formato binário compacto de formas de onda, cerca de dez vezes menor que o VCD.

.gtkw
  Arquivo de *layout* do GTKWave: quais sinais mostrar, em que ordem e com que cores. Não contém os dados da simulação.

.surf.ron
  O equivalente do {file}`.gtkw` para o Surfer.

Monaco
  O motor de edição de código da AURORA, o mesmo do Visual Studio Code.

LSP
  *Language Server Protocol*. O mecanismo por trás dos diagnósticos e da navegação de código, servido pelo Verible e pelo slang.

BYOK
  *Bring Your Own Key*. O modelo de chaves da Aurora Intelligence, no qual você conecta a sua própria conta de um provedor de modelos.

MCP
  *Model Context Protocol*. O protocolo aberto pelo qual ferramentas de linha de comando de IA acessam as ferramentas da AURORA.

bit-reverso
  Endereçamento com os bits do índice invertidos, escrito `x[k)`, usado na FFT.

FFT
  *Fast Fourier Transform*. Algoritmo de transformada discreta de Fourier, cuja variante radix-2 produz resultados em ordem bit-reversa.

DLP
  Dispositivos Lógicos Programáveis. A disciplina da UFJF que usa a plataforma no ensino de graduação.

CommandSpec
  Contrato interno da AURORA que representa executável, argumentos, diretório de trabalho e ambiente sem montar um comando de *shell*.
```
