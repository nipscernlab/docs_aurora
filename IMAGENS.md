# Lista de capturas de tela do manual

Situação em 27/08/2026 (revisão da base 6.10.0): **63 capturas reais, 6 pendentes e 12 marcadas para refazer** (listas abaixo).

As pendentes estão no repositório como retângulos cinza, e não faltando: o build roda com `-W`, então uma imagem ausente derruba a documentação inteira. Salvar o PNG novo por cima resolve, sem tocar em mais nada. Para trocar qualquer captura, salve o PNG novo por cima, com o mesmo nome, em `source/_static/assets/screenshots/`, e passe o `python scripts/enquadrar.py <arquivo>`, que corta a sobra de fundo e recorta o canto arredondado da janela.

## Pendentes (retângulo cinza no lugar)

Todas devem ser capturadas numa AURORA **6.10.0 instalada** (não em modo de desenvolvimento).

| Arquivo | O que capturar |
|---|---|
| `aurora-dirac-autocompletar.png` | Lista de sugestões de Dirac aberta num `.cmm` (digite `dirac` e `Ctrl+Espaço`). |
| `aurora-componentes.png` | Configurações → aba Componentes, com pelo menos um cartão não instalado (para o selo urgente aparecer) e o rodapé com `Verificar e consertar`. |
| `aurora-componentes-boot.png` | Diálogo "Cadeia de compilação ausente" do primeiro início (aparece numa instalação limpa sem o MSYS baixado). |
| `aurora-settings-manual.png` | Configurações → aba Manual, com o cartão "Neste computador" e os três botões. |
| `aurora-gitd-contas.png` | Painel Git-D com os cartões do GitHub e do GitLab lado a lado (ao menos uma conta conectada). |
| `aurora-relato.png` | Modal Relatar um problema com a seção "Ver o diagnóstico que vai junto" expandida. |

## Para refazer (a interface mudou desde a 6.4.2)

| Arquivo | Por quê |
|---|---|
| `aurora-prism-media-movel.png`, `aurora-prism-interno.png`, `aurora-prism-deslocador.png`, `aurora-prism-divisor.png` | **Prioridade máxima.** Na 6.4.2 instalada as skins do SAPHO não carregavam; refazer com skins, etiqueta de largura `/32/` e, se couber, o menu de contexto com "Destacar conexões". |
| `aurora-surfer.png` | O Surfer agora abre como aba do editor; capturar a aba, com os fontes ao lado. |
| `aurora-instalador.png` | O instalador agora abre na página de licença com aceite obrigatório. |
| `aurora-splash.png` | A splash mudou: céu real do catálogo HYG e a aurora nova. |
| `aurora-boas-vindas.png` | Entram o item "Projetos de exemplo...", o "Localizar ausentes" e a lupa nas linhas riscadas. |
| `aurora-primeiro-inicio.png` | Idem: o item "Projetos de exemplo..." na coluna Início. |
| `aurora-dagr-alteracoes.png`, `aurora-dagr-historico.png` | O painel se chama Git-D agora (os nomes de arquivo ficam, só a captura muda). |
| `aurora-wave-config.png` | O modal ganhou o aviso do Verilator e a caixa "Surfer: abrir a onda como aba do editor". |
| `aurora-settings-geral.png` | A aba Geral ganhou Relatar, a limpeza de acesso ao Git e o aviso de internet; e a barra lateral agora tem 9 abas. |
| `aurora-settings-sobre.png` | O manual e o relatar problema saíram da aba Sobre. |
| `aurora-barra-status.png` | Entram as duas fichas de conta (GitHub e GitLab) e o indicador de energia (capturar num laptop). |
| `aurora-terminais.png` | Se possível, capturar durante uma simulação, com a barra de progresso e o marcador de tamanho do dump no TWAVE. |

Padrão de captura:

- Interface em português, janela maximizada em monitor 1920x1080 ou maior.
- Projeto do tutorial básico: projeto `MeuFiltro`, processador `media_movel` (filtro de média móvel do capítulo Primeiro processador).
- Projeto do tutorial avançado: projeto `LabAvancado`, processadores `proc_fft` e `proc_rls` (copiados de `yanc/Compilers/CMMComp/Tests/`).
- Salvar como PNG em `source/_static/assets/screenshots/`, com os nomes exatos abaixo.
- Para recortes de região (toolbar, barra de status), capturar com folga e cortar reto, sem sombra.

---

## O que já está pronto

Todas são capturas reais da AURORA em português.

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
