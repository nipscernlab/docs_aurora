# Lista de capturas de tela do manual

Situação em 17/08/2026: **45 capturas prontas, 13 faltando.**

As que faltam continuam como imagem cinza de espera em `source/_static/assets/screenshots/`, com os dizeres `CAPTURA PENDENTE` e o nome do arquivo. Para completar, basta salvar o PNG novo por cima, com o mesmo nome, sem tocar em nenhuma página.

Padrão de captura:

- Interface em português, janela maximizada em monitor 1920x1080 ou maior.
- Projeto do tutorial básico: projeto `MeuFiltro`, processador `media_movel` (filtro de média móvel do capítulo Primeiro processador).
- Projeto do tutorial avançado: projeto `LabAvancado`, processadores `proc_fft` e `proc_rls` (copiados de `yanc/Compilers/CMMComp/Tests/`).
- Salvar como PNG em `source/_static/assets/screenshots/`, com os nomes exatos abaixo.
- Para recortes de região (toolbar, barra de status), capturar com folga e cortar reto, sem sombra.

---

## O que falta capturar

### Já usadas no manual, hoje com o cinza aparecendo

Estas sete aparecem nas páginas publicadas: enquanto não forem trocadas, o leitor vê o cinza.

| Arquivo | Onde aparece | O que deve aparecer |
|---|---|---|
| `aurora-instalador.png` | Instalação | Instalador do SAPHO no Windows, tela inicial do assistente. |
| `aurora-prism-divisor.png` | Primeiro processador | PRISM depois de trocar `soma >> 2` por `soma / 4` e recompilar, na visão que mostra o divisor dentro da ULA (desça um nível a partir do topo, entre em `ula`). É o par da `aurora-prism-interno.png`, para comparar lado a lado. |
| `aurora-teste-hardware.png` | Simulação e testes | Terminal THTEST depois do teste do processador sintetizado: etapas, barra de progresso e o aviso do pino cheguei. |
| `aurora-dagr-historico.png` | Ferramentas de apoio | Painel Dagr na aba Histórico, com o diff de um commit aberto. |
| `aurora-hub-ponto-flutuante.png` | Ponto flutuante | Hub de Processadores com uma configuração de ponto flutuante diferente: 32 bits, mantissa 23, expoente 8. |
| `aurora-onda-delta-float.png` | Ponto flutuante | Onda com `delta_float` visível, mostrando o erro de arredondamento por operação. |
| `aurora-rls-dirac.png` | Notação de Dirac | Editor com `proc_rls.cmm` mostrando a notação de Dirac (`⟨w\|x⟩`, `# \|P\|x⟩`) com o realce e o espaçamento dos brackets. |

### Capturadas na lista antiga, ainda sem uso no manual

Estas seis estão previstas aqui desde o começo, mas nenhuma página as referencia hoje. Capture na mesma leva; assim que os arquivos existirem, elas entram nas páginas indicadas.

| Arquivo | Destino | O que deve aparecer |
|---|---|---|
| `aurora-boas-vindas.png` | Tour pela interface | Tela de boas-vindas com projetos recentes preenchidos. |
| `aurora-busca-arquivos.png` | Tour pela interface | Modal Buscar nos arquivos com um termo pesquisado e resultados agrupados por arquivo. |
| `aurora-editor-split.png` | Tour pela interface | Editor dividido: `.cmm` à esquerda, `media_movel.v` gerado à direita. |
| `aurora-arvore-menu-contexto.png` | Organização de um projeto | Menu de contexto de um `.v` sintetizável mostrando Definir como Top Level. |
| `aurora-settings-geral.png` | Ferramentas de apoio | Configurações, aba Geral. |
| `aurora-atualizacao.png` | Ferramentas de apoio | Janela de notificação de atualização com o changelog, se houver atualização disponível na época da captura. |

---

## O que já está pronto

As 45 abaixo já são capturas reais e não precisam de nada.

### Interface geral (Tour pela interface)

| Arquivo | O que mostra |
|---|---|
| `aurora-interface-completa.png` | Janela inteira com o projeto `MeuFiltro` aberto. |
| `aurora-toolbar-projeto.png` | Zona esquerda da barra: barra lateral, Novo Projeto, Abrir Projeto. |
| `aurora-toolbar-processador.png` | Grupo processador: Hub, botão C±, engrenagem. |
| `aurora-toolbar-sintese.png` | Grupo síntese: Sintetizar Verilog e PRISM. |
| `aurora-toolbar-ondas.png` | Grupo ondas: chaves de simulador e visualizador, análise, execução rápida, cancelar, configuração, seletor de `.gtkw`. |
| `aurora-toolbar-direita.png` | Zona direita: Controle de Versão, Bibliotecas Python, Configurações, Assistente IA. |
| `aurora-arvore-arquivos.png` | Árvore na visão Arquivos. |
| `aurora-arvore-pastas.png` | Árvore na visão Pastas. |
| `aurora-arvore-hierarquia.png` | Árvore na visão Hierarquia. |
| `aurora-top-level.png` | Arquivo marcado como Top Level na árvore. |
| `aurora-top-testbench.png` | Arquivo marcado como Testbench Top na árvore. |
| `aurora-editor-cmm.png` | Editor com `media_movel.cmm` e o realce de C±. |
| `aurora-terminais.png` | Área de terminais com as seis abas. |
| `aurora-terminal-tcmd.png` | Aba TCMD com o prompt da AURORA e a saída de `Use-Python`. |
| `aurora-barra-status.png` | Barra de status completa. |
| `aurora-paleta-comandos.png` | Paleta de comandos aberta. |

### Primeiro processador (graduação)

| Arquivo | O que mostra |
|---|---|
| `aurora-novo-projeto.png` | Modal Novo Projeto preenchido. |
| `aurora-hub-processadores.png` | Hub preenchido com os valores do tutorial. |
| `aurora-hub-validacao.png` | Hub com campo inválido e botão desabilitado. |
| `aurora-config-processador.png` | Popover da engrenagem com o tempo estimado de simulação. |
| `aurora-compilacao-sucesso.png` | TCMM e TASM após compilar sem erros. |
| `aurora-compilacao-erro.png` | TCMM com erro e link de linha clicável. |
| `aurora-simulacao-input.png` | `Simulation/input_0.txt` aberto no editor. |
| `aurora-gtkwave-media-movel.png` | GTKWave com a onda do filtro e as trilhas Assembly e C±. |
| `aurora-wave-config.png` | Modal Configuração de ondas. |
| `aurora-gtkw-picker.png` | Dropdown do seletor de `.gtkw`. |
| `aurora-prism-media-movel.png` | PRISM na visão do topo. |
| `aurora-prism-interno.png` | PRISM um nível abaixo, com ULA e memórias. |

### Fluxo Verilog (graduação)

| Arquivo | O que mostra |
|---|---|
| `aurora-verilog-editor.png` | Editor com o contador do capítulo. |
| `aurora-gtkwave-contador.png` | GTKWave com a contagem subindo de 0 a 15. |
| `aurora-verilog-validacao.png` | TVERI após sintetizar, com a Hierarquia habilitada. |
| `aurora-testbench-cocotb.png` | Testbench cocotb com a linha `# aurora-toplevel:`. |
| `aurora-surfer.png` | Surfer com uma forma de onda do projeto. |
| `aurora-fast-sim.png` | TWAVE após execução rápida, com o resultado dos testes. |

### Estudos avançados (pós-graduação)

| Arquivo | O que mostra |
|---|---|
| `aurora-fft-editor.png` | `proc_fft.cmm` com `comp`, `#FFTSIZ` e o índice bit-reverso. |
| `aurora-gtkwave-complexos.png` | Sinal `comp_` decodificado como `a + bi`. |

### Ferramentas auxiliares e instalação

| Arquivo | O que mostra |
|---|---|
| `aurora-ia-painel.png` | Aurora Intelligence com uma conversa curta. |
| `aurora-ia-permissao.png` | Cartão de confirmação de ferramenta da IA. |
| `aurora-ia-selecao.png` | Estrela flutuante sobre uma seleção de código. |
| `aurora-settings-ia.png` | Configurações, aba Assistente IA. |
| `aurora-dagr-alteracoes.png` | Painel Dagr na aba Alterações. |
| `aurora-pylibs.png` | Modal Bibliotecas Python. |
| `aurora-settings-atalhos.png` | Configurações, aba Atalhos de Teclado. |
| `aurora-settings-sobre.png` | Configurações, aba Sobre. |
| `aurora-primeiro-inicio.png` | AURORA aberta pela primeira vez, sem projeto. |

---

## Diagramas, que não são capturas

A organização de um projeto e a cadeia de compilação são desenhadas em Mermaid dentro das próprias páginas, então não entram nesta lista e não precisam de captura: mudam junto com o texto e ficam legíveis no HTML, no PDF e na cópia offline.
