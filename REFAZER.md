# Capturas a refazer na 6.11.1

Levantado em 31/08/2026, comparando as capturas, feitas na 6.10.0, com o código
da AURORA hoje. São 28 arquivos. As outras 53 continuam válidas e não aparecem
aqui.

Padrão: interface em português, AURORA 6.11.1, janela maximizada, projeto
`media-movel` para o processador e `contador` para o Simular do PRISM. Salvar
por cima, com o mesmo nome, em `source/_static/assets/screenshots/`.

## Sobre marcar as imagens

O manual não usa seta, círculo nem retângulo em nenhuma figura. A legenda diz o
que olhar. Marcação desenhada envelhece mal: cada mudança de layout desloca a
marca, e ninguém lembra de refazê-la.

Primeiro tente o recorte. Se o assunto é um botão, capture a região dele, não a
janela inteira. O recorte não desalinha e não precisa de manutenção.

Só marque quando o alvo for pequeno e o contexto em volta for necessário para
entender onde ele fica. Nesse caso:

- traço de 3 px, cantos levemente arredondados, sem preenchimento e sem sombra
- cor `#8b7ff5`, o roxo da própria AURORA, que não compete com o vermelho de erro
- um retângulo por imagem; dois já é sinal de que a figura devia ser duas

Quatro das 28 pedem marca. As outras não.

## 1. Ganharam o botão de ajuda

Dezesseis telas ganharam o `?`. A captura antiga não está feia, está errada:
falta um botão que hoje existe.

| Arquivo | O que deve mostrar | Marca |
|---|---|---|
| `aurora-config-processador.png` | popover da engrenagem, com o `?` ao lado do título e o tempo estimado de simulação | não |
| `aurora-settings-atalhos.png` | seção Atalhos de Teclado com o `?` no cabeçalho e um atalho em "Gravando..." | não |
| `aurora-settings-ia.png` | seção Assistente IA com o `?`, Sonnet 5 escolhido | não |
| `aurora-componentes.png` | seção Componentes com o `?`, do topo da lista | não |
| `aurora-ia-painel.png` | painel da IA com o `?` no cabeçalho e uma conversa curta | não |
| `aurora-ia-tutorial.png` | primeira resposta do tutorial guiado | não |
| `aurora-ia-prism-sim.png` | a assistente lendo a simulação do PRISM, com os valores na resposta | não |
| `aurora-componentes-boot.png` | diálogo de componente ausente, com o `?` e o botão principal em destaque | não |
| `aurora-prism-media-movel.png` | topo do diagrama, barra do PRISM com o `?` | não |
| `aurora-prism-interno.png` | um nível abaixo, com ULA e memórias | não |
| `aurora-prism-aba.png` | PRISM na aba do editor, com o logo grande da ferramenta na aba | não |
| `aurora-prism-deslocador.png` | dentro da `ula`, com `ula_add` e `ula_shr` | não |
| `aurora-prism-divisor.png` | mesma trilha, com `ula_add` e `ula_div` | não |
| `aurora-prism-simulacao.png` | modo Simular do contador, barra de tempo, painel de E/S e monitor | não |
| `aurora-prism-sim-parada.png` | o "parar em" disparado, com o cursor de tempo | não |
| `aurora-prism-sim-submodulo.png` | simulação dentro de um submódulo, com a trilha no topo | não |

O par `deslocador` e `divisor` precisa do mesmo enquadramento nas duas, porque
elas aparecem lado a lado e a comparação é o assunto.

## 2. Mudaram de desenho

| Arquivo | O que deve mostrar | Marca |
|---|---|---|
| `aurora-toolbar-direita.png` | grupo da direita, com o botão do Git trazendo as duas fotos, a de trás em meia-lua | sim, no botão do Git |
| `aurora-barra-status.png` | barra completa, com as fichas de conta e o indicador de energia | não |
| `aurora-interface-completa.png` | janela inteira com projeto aberto, que serve de mapa para o capítulo | não |
| `aurora-toolbar-sintese.png` | Sintetizar Verilog e Abrir PRISM, com o logo do PRISM no tamanho novo | não |
| `aurora-dagr-alteracoes.png` | Git-D em Alterações, arquivos em stage e a caixa de commit preenchida | não |
| `aurora-dagr-historico.png` | Git-D em Histórico, com o diff de um commit aberto | não |
| `aurora-gitd-contas.png` | as duas contas conectadas, cada uma com Clonar e Projetos | não |
| `aurora-dagr-gitlab.png` | pode ser a mesma imagem do arquivo acima | não |
| `aurora-ia-permissao.png` | cartão de confirmação de uma ferramenta, com o botão principal em destaque | não |
| `aurora-ia-selecao.png` | a estrela sobre uma seleção de código, e a dica do compositor numa linha só | sim, na estrela |
| `aurora-surfer.png` | Surfer na aba do editor, com o logo grande na aba | não |

## 3. Mostram a versão antiga

Todas exibem `v6.10.0`, e hoje é `6.11.1`.

| Arquivo | O que deve mostrar | Marca |
|---|---|---|
| `aurora-splash.png` | a splash durante a abertura, gravada quadro a quadro porque dura poucos segundos | não |
| `aurora-boas-vindas.png` | tela inicial com "Projetos de exemplo" e um recente riscado, com a lupa | sim, na linha riscada |
| `aurora-primeiro-inicio.png` | tela inicial sem nenhum recente, o que exige perfil limpo | não |
| `aurora-settings-sobre.png` | seção Sobre, com a versão e a situação do atualizador | não |

## 4. Já estavam na fila

| Arquivo | O que deve mostrar | Marca |
|---|---|---|
| `aurora-instalador.png` | a página de licença do instalador, com o aceite obrigatório | sim, na caixa de aceite |
| `aurora-wave-config.png` | modal de ondas com o Verilator escolhido, para o aviso de escopo aparecer | não |

## Como dividir

Dezenove abrem em dois cliques e podem ser capturadas por quem estiver
dirigindo a IDE. Quatro dependem de estado difícil e ficam para quem tem o
ambiente: a splash, que dura segundos; a `primeiro-inicio`, que pede um perfil
sem projetos recentes; a `boas-vindas`, que pede um projeto apagado do disco
para a linha riscada aparecer; e a do instalador.
