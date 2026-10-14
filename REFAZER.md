# Capturas a refazer na 6.11.1

| Arquivo | O que deve mostrar | Marca | Motivo |
|---|---|---|---|
| `aurora-config-processador.png` | popover da engrenagem, com o `?` ao lado do título e o tempo estimado de simulação | não | botão de ajuda novo |
| `aurora-settings-atalhos.png` | seção Atalhos de Teclado com o `?` no cabeçalho e um atalho em "Gravando..." | não | botão de ajuda novo |
| `aurora-settings-ia.png` | seção Assistente IA com o `?`, Sonnet 5 escolhido | não | botão de ajuda novo |
| `aurora-componentes.png` | seção Componentes com o `?`, do topo da lista | não | botão de ajuda novo |
| `aurora-ia-painel.png` | painel da IA com o `?` no cabeçalho e uma conversa curta | não | botão de ajuda novo |
| `aurora-ia-tutorial.png` | primeira resposta do tutorial guiado | não | botão de ajuda novo |
| `aurora-ia-prism-sim.png` | a assistente lendo a simulação do PRISM, com os valores na resposta | não | botão de ajuda novo |
| `aurora-componentes-boot.png` | diálogo de componente ausente, com o `?` e o botão principal em destaque | não | botão de ajuda novo |
| `aurora-prism-media-movel.png` | topo do diagrama, barra do PRISM com o `?` | não | botão de ajuda novo |
| `aurora-prism-interno.png` | um nível abaixo, com ULA e memórias | não | botão de ajuda novo |
| `aurora-prism-aba.png` | PRISM na aba do editor, com o logo grande da ferramenta na aba | não | botão de ajuda novo |
| `aurora-prism-deslocador.png` | dentro da `ula`, com `ula_add` e `ula_shr`, mesmo enquadramento do divisor | não | botão de ajuda novo |
| `aurora-prism-divisor.png` | mesma trilha, com `ula_add` e `ula_div`, mesmo enquadramento do deslocador | não | botão de ajuda novo |
| `aurora-prism-simulacao.png` | modo Simular do contador, barra de tempo, painel de E/S e monitor | não | botão de ajuda novo |
| `aurora-prism-sim-parada.png` | o "parar em" disparado, com o cursor de tempo | não | botão de ajuda novo |
| `aurora-prism-sim-submodulo.png` | simulação dentro de um submódulo, com a trilha no topo | não | botão de ajuda novo |
| `aurora-toolbar-direita.png` | grupo da direita, com o botão do Git trazendo as duas fotos, a de trás em meia-lua | sim, no botão do Git | desenho mudou |
| `aurora-barra-status.png` | barra completa, com as fichas de conta e o indicador de energia | não | desenho mudou |
| `aurora-interface-completa.png` | janela inteira com projeto aberto, que serve de mapa para o capítulo | não | desenho mudou |
| `aurora-toolbar-sintese.png` | Sintetizar Verilog e Abrir PRISM, com o logo do PRISM no tamanho novo | não | desenho mudou |
| `aurora-dagr-alteracoes.png` | Git-D em Alterações, arquivos em stage e a caixa de commit preenchida | não | desenho mudou |
| `aurora-dagr-historico.png` | Git-D em Histórico, com o diff de um commit aberto | não | desenho mudou |
| `aurora-gitd-contas.png` | as duas contas conectadas, cada uma com Clonar e Projetos | não | desenho mudou |
| `aurora-dagr-gitlab.png` | pode ser a mesma imagem do arquivo acima | não | desenho mudou |
| `aurora-ia-permissao.png` | cartão de confirmação de uma ferramenta, com o botão principal em destaque | não | desenho mudou |
| `aurora-ia-selecao.png` | a estrela sobre uma seleção de código, e a dica do compositor numa linha só | sim, na estrela | desenho mudou |
| `aurora-surfer.png` | Surfer na aba do editor, com o logo grande na aba | não | desenho mudou |
| `aurora-splash.png` | a splash durante a abertura, gravada quadro a quadro porque dura poucos segundos | não | versão antiga no rodapé |
| `aurora-boas-vindas.png` | tela inicial com "Projetos de exemplo" e um recente riscado, com a lupa | sim, na linha riscada | versão antiga no rodapé |
| `aurora-primeiro-inicio.png` | tela inicial sem nenhum recente, o que exige perfil limpo | não | versão antiga no rodapé |
| `aurora-settings-sobre.png` | seção Sobre, com a versão e a situação do atualizador | não | versão antiga no rodapé |
| `aurora-instalador.png` | a página de licença do instalador, com o aceite obrigatório | sim, na caixa de aceite | já estava na fila |
| `aurora-wave-config.png` | modal de ondas com o Verilator escolhido, para o aviso de escopo aparecer | não | já estava na fila |

Padrão: português, AURORA 6.11.1, janela maximizada, projeto `media-movel` para
o processador e `contador` para o Simular. Salvar por cima, mesmo nome, em
`source/_static/assets/screenshots/`.

Marca, quando houver: retângulo de 3 px, sem preenchimento, cor `#8b7ff5`, um
por imagem.

## Capturas que o YANC 7.1 tornou velhas

A AURORA com o YANC 7.1 guarda o fonte de cada processador em `<proc>/` e o que o
YANC gera em `<proc>/<proc>/`; as pastas Software, Hardware e Simulation, o
`#PRNAME` no fonte e as pilhas no Hub deixaram de existir. Estas capturas ainda
mostram o formato antigo:

| Arquivo | O que deve mostrar | Marca | Motivo |
|---|---|---|---|
| `aurora-hub-processadores.png` | Hub preenchido com os valores do tutorial, sem os campos de pilha | não | pilhas saíram do Hub |
| `aurora-hub-validacao.png` | o mesmo Hub com um campo em vermelho e o botão travado | não | pilhas saíram do Hub |
| `aurora-compilacao-sucesso.png` | árvore com `media_movel/` e a pasta de saída `media_movel/media_movel/` aberta; o fonte sem `#PRNAME`; TASM terminando em sucesso | sim, na árvore e no terminal | estrutura de pastas nova |
| `aurora-compilacao-erro.png` | TCMM com um erro e o link de linha clicável, com a árvore no formato novo | não | estrutura de pastas nova |
| `aurora-simulacao-input.png` | `input_0.txt` aberto, ao lado do fonte em `media_movel/`, na visão Pastas | não | estrutura de pastas nova |
| `aurora-top-level.png` | `media_movel/media_movel/media_movel.v` marcado como Top Level | não | estrutura de pastas nova |
| `aurora-top-testbench.png` | um testbench marcado como Testbench Top, árvore no formato novo | não | estrutura de pastas nova |
| `aurora-arvore-menu-contexto.png` | menu do botão direito de um `.v`, com a escolha de papel | não | papel escolhido pela pessoa |

Captura nova, se couber: o diálogo de conversão de um projeto antigo, aberto
com um projeto que ainda tenha `Software/`, e o relatório depois dele.
