# Lista de capturas de tela do manual

Situação em 30/08/2026 (revisão da base 6.11.0): **69 capturas reais, 9 pendentes da 6.11.0** (retângulos cinza no repositório) **e 17 itens marcados para refazer** (listas abaixo).

Para trocar qualquer captura, salve o PNG novo por cima, com o mesmo nome, em `source/_static/assets/screenshots/`, e passe o `python scripts/enquadrar.py <arquivo>`, que corta a sobra de fundo e recorta o canto arredondado da janela. O build roda com `-W`, então uma imagem ausente derruba a documentação inteira: nunca apague, sempre substitua.

## Para refazer

Todas numa AURORA **6.11.0 instalada** (não em modo de desenvolvimento), com a **interface em português**.

1. `aurora-prism-media-movel.png`, `aurora-prism-interno.png`, `aurora-prism-deslocador.png`, `aurora-prism-divisor.png`: **prioridade máxima**. Na 6.4.2 instalada as skins do SAPHO não carregavam; refazer com skins, a etiqueta de largura `/32/` e, se couber, o menu de contexto com "Destacar conexões".
2. `aurora-settings-manual.png`: a captura atual mostra as chaves cruas `modal.settings.manualInstalled` no cartão de estado (bug da AURORA, a reportar) e está em inglês. Refazer depois da correção, em português.
3. `aurora-gitd-contas.png`: a atual está em inglês e sem nenhuma conta conectada. Refazer em português, com ao menos uma conta logada.
4. `aurora-relato.png`: a atual está em inglês e com o diagnóstico recolhido. Refazer em português, com "Ver o diagnóstico que vai junto" expandido.
5. `aurora-componentes.png`: a atual está em inglês e rolada para o fim da lista. Refazer em português, do topo, com o MSYS ou o YANC visível para o selo "Necessário para compilar" aparecer.
6. `aurora-surfer.png`: o Surfer agora abre como aba do editor; capturar a aba, com os fontes ao lado.
7. `aurora-instalador.png`: o instalador agora abre na página de licença com aceite obrigatório.
8. `aurora-splash.png`: a splash mudou, com o céu real do catálogo HYG e a aurora nova.
9. `aurora-boas-vindas.png`: entram o item "Projetos de exemplo...", o "Localizar ausentes" e a lupa nas linhas riscadas.
10. `aurora-primeiro-inicio.png`: idem, o item "Projetos de exemplo..." na coluna Início.
11. `aurora-dagr-alteracoes.png` e `aurora-dagr-historico.png`: o painel se chama Git-D agora (os nomes de arquivo ficam, só a captura muda).
12. `aurora-wave-config.png`: o modal ganhou o aviso do Verilator. A escolha de aba ou janela do Surfer saiu do modal: mora nas Configurações, aba Geral, junto com a do PRISM.
13. `aurora-settings-geral.png`: a aba Geral ganhou a limpeza de acesso ao Git, o aviso de internet e as opções "Onde o PRISM abre" e "Onde o Surfer abre"; o Relatar mora na barra lateral, que tem 9 abas.
14. `aurora-settings-sobre.png`: o manual e o relatar problema saíram da aba Sobre.
15. `aurora-barra-status.png`: entram as duas fichas de conta (GitHub e GitLab) e o indicador de energia (capturar num laptop).
16. `aurora-terminais.png`: agora são sete abas, com a TPRISM; se possível, capturar durante uma simulação, com a barra de progresso e o marcador de tamanho do dump no TWAVE.
17. `aurora-settings-ia.png`: o cartão da Anthropic ganhou o Sonnet 5 como padrão e o campo "Esforço e raciocínio".

## Recebidas em 27/08 e já no lugar

`aurora-dirac-autocompletar.png` e `aurora-componentes-boot.png` chegaram em português e ficam como estão. As quatro dos itens 2 a 5 acima também entraram (são melhores que o retângulo cinza), mas com as ressalvas anotadas.

## Pendentes da 6.11.0 (retângulos cinza no repositório)

O modo Simular do PRISM se captura melhor no projeto do contador (tutorial Verilog): pequeno, com `clk`, e a contagem faz uma onda legível.

| Arquivo | O que deve mostrar |
|---|---|
| `aurora-prism-simulacao.png` | PRISM no modo Simular com o contador: a barra de tempo (Rodar, Tick, Próximo evento, Rápido, Reiniciar, contador de ticks, meio período, velocidade), o painel Entradas e saídas e o monitor Formas de onda abertos, com `conta` subindo. |
| `aurora-prism-sim-parada.png` | O monitor depois de um "parar em" disparar (por exemplo `conta` = F): o aviso "Parou no tick N" e o cursor de tempo numa onda, com os valores daquele tick em cada linha. |
| `aurora-prism-sim-fio.png` | O balão de um barramento ao passar o mouse sobre o fio, com nome, faixa de bits e as linhas hex, dec e bin. Recorte de região. |
| `aurora-prism-sim-submodulo.png` | Dentro de um submódulo durante a simulação, com a trilha de caminho no topo e o Voltar. A `ula` do `media_movel` é um bom alvo; se não couber no limite, qualquer módulo com submódulo serve. |
| `aurora-prism-aba.png` | O PRISM aberto numa aba do editor, ao lado do `.cmm`, depois de escolher "Aba do editor" em Configurações, Geral. |
| `aurora-prism-onda.png` | O visualizador de ondas aberto pelo "Abrir no WAVE" da simulação, com os sinais do monitor agrupados por papel (relógio, entradas, saídas). |
| `aurora-historico-compilacoes.png` | O modal Histórico de compilações com uma execução aberta: a lista (Pedido, Quando, Duração, Passos, Desfecho), o "Estado do projeto na hora" e "O que rodou". Melhor ainda com uma execução em andamento no topo. |
| `aurora-ia-tutorial.png` | Painel da Aurora Intelligence logo depois de clicar no capelo: a primeira resposta do tutorial guiado. |
| `aurora-ia-prism-sim.png` | Uma conversa em que a assistente opera o Simular do PRISM: o cartão de permissão de uma ferramenta `prism_sim` ou a resposta com os valores lidos. |

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
