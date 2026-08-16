# Lista de capturas de tela do manual

Todas as imagens serão refeitas. Enquanto isso, cada nome abaixo existe como uma imagem cinza de espera em `source/_static/assets/screenshots/`; basta substituir o arquivo pelo de mesmo nome, sem tocar nas páginas.

Padrão de captura:

- Interface em português, janela maximizada em monitor 1920x1080 ou maior.
- Projeto do tutorial básico: projeto `MeuFiltro`, processador `media_movel` (filtro de média móvel do capítulo Primeiro processador).
- Projeto do tutorial avançado: projeto `LabAvancado`, processadores `proc_fft` e `proc_rls` (copiados de `yanc/Compilers/CMMComp/Tests/`).
- Salvar como PNG em `source/_static/assets/screenshots/`, com os nomes exatos abaixo.
- Para recortes de região (toolbar, barra de status), capturar com folga e cortar reto, sem sombra.

## Interface geral (capítulo Tour pela interface)

| Arquivo | O que deve aparecer |
|---|---|
| `aurora-boas-vindas.png` | Tela de boas-vindas com projetos recentes preenchidos. |
| `aurora-interface-completa.png` | Janela inteira: projeto `MeuFiltro` aberto, `media_movel.cmm` no editor, árvore na visão Arquivos, terminal TCMM com uma compilação bem-sucedida, barra de status completa. |
| `aurora-toolbar-projeto.png` | Recorte da zona esquerda da barra: alternar barra lateral, Novo Projeto, Abrir Projeto. |
| `aurora-toolbar-processador.png` | Recorte do grupo processador: Hub de Processadores, botão C±, engrenagem de configuração. |
| `aurora-toolbar-sintese.png` | Recorte do grupo síntese: Sintetizar Verilog e PRISM. |
| `aurora-toolbar-ondas.png` | Recorte do grupo ondas: chaves Icarus/Verilator e GTKWave/Surfer, Analisar Verilog, execução rápida, cancelar, configuração de ondas, seletor de .gtkw. |
| `aurora-toolbar-direita.png` | Recorte da zona direita: Controle de Versão (com badge de alterações), Bibliotecas Python, Configurações, Assistente IA. |
| `aurora-arvore-arquivos.png` | Árvore na visão Arquivos com os separadores do processador `media_movel` e a seção Importados. |
| `aurora-arvore-pastas.png` | Árvore na visão Pastas com as pastas Software, Hardware e Simulation expandidas. |
| `aurora-arvore-hierarquia.png` | Árvore na visão Hierarquia após uma sintetização Verilog. |
| `aurora-arvore-menu-contexto.png` | Menu de contexto de um `.v` sintetizável mostrando Definir como Top Level. |
| `aurora-editor-cmm.png` | Editor com `media_movel.cmm` aberto, realce da linguagem C± visível (diretivas coloridas). |
| `aurora-editor-split.png` | Editor dividido: `.cmm` à esquerda, `media_movel.v` gerado à direita. |
| `aurora-terminais.png` | Área de terminais com as seis abas visíveis e cards de mensagem no TCMM (sucesso e aviso). |
| `aurora-terminal-tcmd.png` | Aba TCMD com o prompt da AURORA (segmento do processador ativo, diretório, branch git) e a saída do comando `Use-Python`. |
| `aurora-barra-status.png` | Recorte da barra de status: Pronto, processador ativo, compilação, top level, testbench, motor de simulação, linha e coluna, GitHub. |
| `aurora-paleta-comandos.png` | Paleta de comandos aberta (Ctrl+Shift+K) com a lista de comandos visível. |
| `aurora-busca-arquivos.png` | Modal Buscar nos arquivos com um termo pesquisado e resultados agrupados por arquivo. |

## Tutorial: primeiro processador (graduação)

| Arquivo | O que deve aparecer |
|---|---|
| `aurora-novo-projeto.png` | Modal Novo Projeto preenchido com `MeuFiltro` e um local válido. |
| `aurora-hub-processadores.png` | Hub de Processadores preenchido com os valores do tutorial (nome `media_movel`, 16 bits, mantissa 10, expoente 5, ganho 128, pilhas 2 e 4, uma porta de cada). Botão Gerar Processador habilitado. |
| `aurora-hub-validacao.png` | Hub com um campo inválido (total de bits diferente da soma), borda vermelha e botão desabilitado. |
| `aurora-config-processador.png` | Popover da engrenagem: frequência de clock, número de clocks e o tempo estimado de simulação calculado. |
| `aurora-compilacao-sucesso.png` | Terminais TCMM e TASM após compilar o `media_movel.cmm` sem erros, com os avisos de recurso instanciado visíveis no TASM. |
| `aurora-compilacao-erro.png` | TCMM com um erro de compilação e o link de linha clicável destacado. |
| `aurora-simulacao-input.png` | Visão Pastas com `Simulation/input_0.txt` aberto no editor mostrando o degrau de valores. |
| `aurora-gtkwave-media-movel.png` | GTKWave com a onda do tutorial: x[0] a x[3], soma, porta de saída suavizando o degrau, e as trilhas Assembly e C± visíveis. |
| `aurora-wave-config.png` | Modal Configuração de ondas com a árvore de sinais e alguns selecionados. |
| `aurora-gtkw-picker.png` | Dropdown do seletor de `.gtkw` aberto, com o item padrão e um arquivo do usuário. |
| `aurora-prism-media-movel.png` | PRISM mostrando o processador `media_movel` (visão do topo). |
| `aurora-prism-interno.png` | PRISM depois de descer um nível na hierarquia, mostrando os blocos internos (ULA, memórias). |
| `aurora-prism-divisor.png` | PRISM após trocar `soma >> 2` por `soma / 4` e recompilar, com o divisor visível no diagrama. |
| `aurora-teste-hardware.png` | Terminal THTEST após o teste do processador sintetizado: etapas, barra de progresso e o aviso do pino cheguei. |

## Fluxo Verilog (graduação)

| Arquivo | O que deve aparecer |
|---|---|
| `aurora-verilog-editor.png` | Editor com um módulo Verilog simples (o contador do capítulo) com realce e diagnósticos do LSP visíveis, se houver. |
| `aurora-gtkwave-contador.png` | GTKWave com a onda do tutorial do contador: clock, reset, habilita e a contagem subindo de 0 a 15. |
| `aurora-verilog-validacao.png` | Terminal TVERI após Sintetizar Verilog com sucesso, e a visão Hierarquia habilitada na árvore. |
| `aurora-testbench-cocotb.png` | Editor com um testbench cocotb em Python, incluindo a linha `# aurora-toplevel:`. |
| `aurora-surfer.png` | Surfer aberto com uma forma de onda do projeto. |
| `aurora-fast-sim.png` | Terminal TWAVE após uma execução rápida (sem onda), mostrando o resultado dos testes cocotb. |

## Estudos avançados (pós-graduação)

| Arquivo | O que deve aparecer |
|---|---|
| `aurora-fft-editor.png` | Editor com `proc_fft.cmm`: tipo `comp`, diretiva `#FFTSIZ` e o índice bit-reverso `data[j)` visíveis. |
| `aurora-rls-dirac.png` | Editor com `proc_rls.cmm` mostrando a notação de Dirac (`⟨w|x⟩`, `# |P|x⟩`) com o realce e o espaçamento dos brackets. |
| `aurora-gtkwave-complexos.png` | GTKWave com um sinal `comp_` decodificado no formato `a + bi` pelo filtro comp2gtkw. |
| `aurora-onda-delta-float.png` | Onda com `delta_float` visível, mostrando o erro de arredondamento por operação. |
| `aurora-hub-ponto-flutuante.png` | Hub de Processadores com uma configuração de ponto flutuante diferente (32 bits, mantissa 23, expoente 8) para o capítulo de ponto flutuante. |

## Ferramentas auxiliares

| Arquivo | O que deve aparecer |
|---|---|
| `aurora-ia-painel.png` | Painel Aurora Intelligence aberto com uma conversa curta sobre o projeto (pergunta e resposta). |
| `aurora-ia-permissao.png` | Cartão de confirmação de ferramenta da IA (Permitir / Negar) visível no chat. |
| `aurora-ia-selecao.png` | Estrela flutuante sobre uma seleção de código no editor, com o menu Explicar / Corrigir / Melhorar aberto. |
| `aurora-settings-ia.png` | Configurações, aba Assistente IA, com os cartões de provedores. |
| `aurora-dagr-alteracoes.png` | Painel Dagr na aba Alterações: arquivos em stage, caixa de commit preenchida. |
| `aurora-dagr-historico.png` | Painel Dagr na aba Histórico com o diff de um commit aberto. |
| `aurora-pylibs.png` | Modal Bibliotecas Python com o catálogo, uma biblioteca instalada e as categorias visíveis. |
| `aurora-settings-geral.png` | Configurações, aba Geral. |
| `aurora-settings-atalhos.png` | Configurações, aba Atalhos de Teclado, com um atalho em modo de gravação. |
| `aurora-settings-sobre.png` | Configurações, aba Sobre: versão, atualizações, equipe e os botões do manual. |
| `aurora-atualizacao.png` | Janela de notificação de atualização com o changelog (se houver atualização disponível na época da captura). |

## Instalação

| Arquivo | O que deve aparecer |
|---|---|
| `aurora-instalador.png` | Instalador do SAPHO no Windows (tela inicial do assistente). |
| `aurora-primeiro-inicio.png` | AURORA aberta pela primeira vez, sem projeto, na tela de boas-vindas vazia. |

Total: 45 capturas. As 38 antigas serão removidas quando as novas entrarem.
