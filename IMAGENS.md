# Lista de capturas de tela do manual

Situação em 20/08/2026: **57 capturas prontas, 2 faltando.**

As que faltam continuam como imagem cinza de espera em `source/_static/assets/screenshots/`, com os dizeres `CAPTURA PENDENTE` e o nome do arquivo. Para completar, basta salvar o PNG novo por cima, com o mesmo nome, sem tocar em nenhuma página.

Padrão de captura:

- Interface em português, janela maximizada em monitor 1920x1080 ou maior.
- Projeto do tutorial básico: projeto `MeuFiltro`, processador `media_movel` (filtro de média móvel do capítulo Primeiro processador).
- Projeto do tutorial avançado: projeto `LabAvancado`, processadores `proc_fft` e `proc_rls` (copiados de `yanc/Compilers/CMMComp/Tests/`).
- Salvar como PNG em `source/_static/assets/screenshots/`, com os nomes exatos abaixo.
- Para recortes de região (toolbar, barra de status), capturar com folga e cortar reto, sem sombra.

---

## O que falta capturar

As duas aparecem em páginas publicadas, então enquanto não forem trocadas o leitor vê o cinza.

### `aurora-onda-delta-float.png`, no capítulo Ponto flutuante

`delta_float` é um sinal de simulação que vive dentro da ULA (`ula.v`): a cada operação de ponto flutuante ele guarda a diferença entre o resultado exato, calculado em precisão dupla pelo simulador, e o que o hardware produziu. É o erro de arredondamento daquela operação, e vale zero fora das operações de float.

Para capturar:

1. Use um processador de ponto flutuante (o `proc_rls` serve) e simule com **Icarus**, não com Verilator: o arnês é só de simulação e o sinal é do tipo `real`.
2. Na {guilabel}`Configuração de ondas`, o caminho do sinal é `<testbench> → proc → p_<processador> → core → ula → delta_float`. No RLS, `proc_rsl_tb.proc.p_proc_rls.core.ula.delta_float`.
3. No GTKWave, o sinal precisa virar curva para dizer alguma coisa: botão direito nele, {guilabel}`Data Format` › {guilabel}`Analog` › {guilabel}`Interpolated`, e depois {guilabel}`Insert Analog Height Extension` duas ou três vezes para dar altura à trilha.
4. Enquadre alguns ciclos do laço, com a trilha de assembly junto, para o erro aparecer saltando a cada operação e voltando a zero entre elas.

### `aurora-prism-divisor.png`, no capítulo Primeiro processador

O PRISM mostra um módulo por vez, e o divisor não está no diagrama de cima: ele é um bloco de dentro da ULA. O caminho é `<processador>` → `p_<processador>` → `core` → `ula`.

Dentro de `ula`, cada operação é um bloco condicionado por `generate if`. Com `soma / 4` o compilador liga `.DIV(1)` e aparece o bloco `my_div`, do tipo `ula_div`; com `soma >> 2` esse bloco não existe e no lugar está `my_shr`, do tipo `ula_shr`.

Para não caçar às cegas: depois de recompilar com `/ 4`, abra o `Hardware/<processador>.v` e confirme que a lista de parâmetros traz `.DIV(1)`. Aí é só descer até `ula` no PRISM e enquadrar a região onde `my_div` aparece. A captura companheira, `aurora-prism-interno.png`, já mostra essa mesma visão sem o divisor, e é com ela que a nova vai ser comparada.

## O que já está pronto

As 57 abaixo já são capturas reais e não precisam de nada.

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
