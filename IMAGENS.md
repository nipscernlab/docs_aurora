# Lista de capturas de tela do manual

Situação em 30/08/2026, ao fim do dia: **26 capturas novas ou refeitas entraram**, todas feitas na AURORA rodando do repositório (`npm start`), em português, num monitor 2560x1440. **Nenhuma está pendente**: as três que dependiam de chave de API e de conta conectada foram feitas na segunda rodada, depois que os cinco defeitos da tarde foram corrigidos.

Para trocar qualquer captura, salve o PNG novo por cima, com o mesmo nome, em `source/_static/assets/screenshots/`, e passe o `python scripts/enquadrar.py <arquivo>`, que corta a sobra de fundo e recorta o canto arredondado da janela. O build roda com `-W`, então uma imagem ausente derruba a documentação inteira: nunca apague, sempre substitua.

## Feitas em 30/08/2026

Capturadas com a AURORA rodando do repositório (`npm start`, versão de desenvolvimento 6.10.0), interface em português, no projeto de exemplo `contador` (o modo Simular do PRISM) e no `media-movel` (o processador). Todas em 2560x1368, exceto os recortes de região.

**Do PRISM e da simulação:** `aurora-prism-aba.png` (o PRISM numa aba do editor), `aurora-prism-simulacao.png` (o contador simulando, com a barra de tempo, o painel de E/S e o monitor, `conta` subindo de 95 a 107), `aurora-prism-sim-parada.png` (o "parar em" disparado em 160, com o cursor de tempo e os valores por linha), `aurora-prism-sim-fio.png` (o balão do barramento `conta`, hex a0, dec 160, bin 10100000), `aurora-prism-sim-submodulo.png` (dentro da `ula` com a simulação correndo, trilha `core › ula`), `aurora-prism-onda.png` (o GTKWave aberto pelo "Abrir no WAVE", com os grupos Clock, Outputs e Internal), `aurora-prism-media-movel.png` e `aurora-prism-interno.png` (agora com as skins do SAPHO carregando, que era o item de prioridade máxima).

**Do resto da IDE:** `aurora-historico-compilacoes.png` (uma execução aberta, com o estado do projeto na hora), `aurora-settings-geral.png` (com "Onde o PRISM abre" e "Onde o Surfer abre"), `aurora-componentes.png`, `aurora-settings-atalhos.png` (com "Gravando..."), `aurora-settings-ia.png` (Sonnet 5 como modelo padrão da Anthropic), `aurora-settings-sobre.png` (já sem os links do manual), `aurora-relato.png` (com o diagnóstico expandido), `aurora-wave-config.png` (com o aviso do Verilator), `aurora-surfer.png` (o Surfer numa aba do editor), `aurora-boas-vindas.png` (com "Projetos de exemplo...") e `aurora-barra-status.png` (com o indicador de energia).

## Para refazer

Todas numa AURORA **6.11.0 instalada** (não em modo de desenvolvimento), com a **interface em português**.

1. `aurora-prism-deslocador.png` e `aurora-prism-divisor.png`: o par do experimento do tutorial, e o único item de peso que sobra. Exige compilar o `.cmm` com `soma >> 2`, entrar na `ula` e capturar, depois trocar por `soma / 4`, recompilar e capturar de novo, no mesmo enquadramento. (As outras duas do PRISM, `aurora-prism-media-movel.png` e `aurora-prism-interno.png`, já saíram em 30/08 com as skins.)
2. ~~`aurora-settings-manual.png`~~: consertado e refeito na mesma noite.
3. ~~`aurora-gitd-contas.png`~~: refeita com as duas contas conectadas.
4. ~~`aurora-relato.png`~~: feita em 30/08, em português e com o diagnóstico expandido.
5. ~~`aurora-componentes.png`~~: feita em 30/08, em português e do topo da lista. Nesta máquina todos os componentes estão instalados, então o selo "Necessário para compilar" não aparece; quem tiver uma instalação limpa pode melhorar a captura.
6. ~~`aurora-surfer.png`~~: feita em 30/08, com o Surfer na aba do editor.
7. `aurora-instalador.png`: o instalador agora abre na página de licença com aceite obrigatório.
8. ~~`aurora-splash.png`~~: refeita à noite, gravada quadro a quadro durante a abertura (a splash dura poucos segundos).
9. `aurora-boas-vindas.png`: feita em 30/08 com o item "Projetos de exemplo...", mas **sem nenhum recente riscado**, porque nesta máquina todos os projetos existem. Para mostrar a lupa e o "Localizar ausentes", mova a pasta de um projeto recente para fora e capture de novo.
10. `aurora-primeiro-inicio.png`: idem, o item "Projetos de exemplo..." na coluna Início.
11. `aurora-dagr-alteracoes.png` e `aurora-dagr-historico.png`: o painel se chama Git-D agora (os nomes de arquivo ficam, só a captura muda).
12. `aurora-wave-config.png`: o modal ganhou o aviso do Verilator. A escolha de aba ou janela do Surfer saiu do modal: mora nas Configurações, aba Geral, junto com a do PRISM.
13. ~~`aurora-settings-geral.png`~~: feita em 30/08, com as duas opções novas à vista.
14. ~~`aurora-settings-sobre.png`~~: feita em 30/08.
15. ~~`aurora-barra-status.png`~~: refeita à noite, com as duas fichas de conta e o indicador de energia.
16. ~~`aurora-terminais.png`~~: refeita à noite, com as sete abas e o TASM de uma compilação. Fica a nota de que o painel, uma vez recolhido, foi impossível de reabrir na sessão da tarde.
17. ~~`aurora-settings-ia.png`~~: feita em 30/08, com o Sonnet 5 como modelo padrão da Anthropic. O campo "Esforço e raciocínio" não aparece no cartão sem chave configurada.

## Recebidas em 27/08 e já no lugar

`aurora-dirac-autocompletar.png` e `aurora-componentes-boot.png` chegaram em português e ficam como estão.

## O que a sessão de capturas ensinou

Anotado para quem for repetir o trabalho:

- O cursor do mouse **não** entra nas capturas: o `CopyFromScreen` do GDI não desenha o ponteiro. Para o balão de um fio aparecer, porém, o ponteiro precisa estar sobre ele, e o balão sai na foto.
- O balão de célula do PRISM ("Clique para abrir · Shift+clique destaca conexões") **fica preso na tela** depois que o ponteiro sai da célula. É por isso que ele aparece na `aurora-prism-sim-submodulo.png`. Some ao recompilar o diagrama.
- O `.gtkw` que o "Abrir no WAVE" gera abre com os três grupos **colapsados** (`@c00200`), então a onda parece vazia; basta clicar em cada grupo. Vale considerar gerar com `@800200`.
- O Surfer em aba demora bastante para o WebAssembly carregar o VCD: na primeira olhada parece que não abriu, e um minuto depois a onda está lá.
- Para capturar a splash, que dura poucos segundos, o jeito é gravar quadro a quadro durante a abertura, filtrando as janelas pelo executável do repositório: o VS Code também roda em Electron e entra na peneira se o filtro for só o nome do processo.
- Quando a assistente precisa de um módulo específico na tela do PRISM, ela pergunta em vez de chutar: a síntese do topo `mediamovel` estoura o limite de 45 s do Yosys, e ela pediu que o `core` fosse aberto antes de entrar no Simular.

## Segunda rodada, 30/08 à noite

Depois que os cinco defeitos da tarde foram corrigidos (commit `0f29097a` da AURORA), entraram as últimas sete:

- `aurora-ia-tutorial.png` e `aurora-gitd-contas.png` / `aurora-dagr-gitlab.png`: capturadas pelo Chrysthofer. A do Git-D mostra as duas contas conectadas, `@Chrysthofer` no GitHub e `@chrysthofer` no GitLab, cada uma com Clonar e Projetos.
- `aurora-ia-prism-sim.png`: a assistente operando a simulação de verdade. O pedido foi entrar no Simular do `core` do `mediamovel`, avançar 60 ticks e trazer `instr_addr` e `mem_data_wr` para o monitor. Ela executou treze ferramentas `prism_sim_*`, e a captura mostra o PRISM simulando à esquerda e, à direita, a tabela de valores lidos com a explicação de por que os barramentos de entrada estão flutuando. De passagem ela também percebeu que falta a diretiva `#NUGAIN` no `mediamovel.cmm` do projeto de exemplo.
- `aurora-settings-manual.png`: o cartão agora diz "Neste computador" e "versão 6.10.0.1", sem chaves cruas. O conserto do i18n funcionou.
- `aurora-terminais.png`: as sete abas com o painel aberto, o TASM depois de uma compilação. O painel abre normalmente; na sessão da tarde ele estava recolhido e nenhum gesto o trazia de volta.
- `aurora-barra-status.png`: refeita com as duas fichas de conta ao lado do indicador de energia.
- `aurora-splash.png`: a splash nova, com a aurora boreal sobre o céu do catálogo HYG, capturada quadro a quadro durante a abertura.

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
