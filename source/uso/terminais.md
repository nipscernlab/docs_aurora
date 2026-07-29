# Os terminais

A área inferior da janela reúne seis terminais em abas. Cinco são consoles de saída, cada etapa da cadeia escrevendo no seu, o que torna previsível onde procurar cada mensagem. O sexto é um *shell* interativo de verdade.

Quando você dispara uma ação na barra superior, a AURORA troca automaticamente para a aba certa conforme as etapas avançam. Saber quem escreve onde é o que transforma uma falha opaca em um diagnóstico de trinta segundos.

```{figure} ../_static/assets/screenshots/aurora-terminals-tcmd.png
:alt: Painel de terminais com as seis abas e a saída de uma compilação.
:width: 100%
:align: center
:name: fig-terminais-detalhe

Os seis terminais. Cada etapa escreve no seu, e a AURORA seleciona a aba correspondente sozinha durante a execução.
```

## Quem escreve onde

:::{list-table}
:header-rows: 1
:widths: 14 86
:name: tab-terminais

* - Aba
  - Recebe
* - **TCMM**
  - A saída do compilador C±: erros, avisos e o progresso da tradução para *assembly*
* - **TASM**
  - A saída do montador, a geração do Verilog e das memórias e os avisos de recurso instanciado
* - **TVERI**
  - O Icarus Verilog e a síntese do Yosys, com os diagnósticos de Verilog
* - **TWAVE**
  - A execução da simulação, seja pelo `vvp`, pelo Verilator ou pelo cocotb, e a abertura dos visualizadores
* - **THTEST**
  - O teste do processador sintetizado, com barra de progresso própria
* - **TCMD**
  - Um terminal PowerShell interativo completo
:::

A ordem acima é também a ordem temporal de uma execução completa. Se algo falhou, procure o primeiro terminal da sequência que registrou erro: os seguintes costumam mostrar apenas consequências.

## Cartões, filtros e o modo verboso

As mensagens chegam como cartões classificados em erros, avisos, sucessos e dicas, no mesmo código de cores da IDE. No topo da área ficam os filtros por tipo, com contadores, além dos botões de limpar o terminal atual, exportar o conteúdo para arquivo e recarregar a interface.

Os filtros atuam quando o Modo Verboso está desligado nas configurações. Com o modo ligado, que é o padrão, tudo aparece. Cada terminal retém até cinco mil entradas.

:::{tip} Linhas clicáveis
Erros que citam arquivo e linha, como `arquivo.v:42:` do Icarus ou "linha 17" do compilador C±, viram *links*. O clique abre o arquivo no editor, na linha exata. É o caminho mais rápido do erro à correção.
:::

## Ler os avisos de recurso instanciado

O terminal TASM tem uma função que nenhum outro ambiente oferece: ele anuncia, durante a montagem, cada bloco de *hardware* que o seu programa acabou de ligar no circuito.

À medida que os *opcodes* aparecem pela primeira vez, o TASM informa a instância correspondente: o divisor inteiro, o bloco de módulo, os blocos de ponto flutuante, o circuito de endereçamento indexado. Ao final, resume o percentual do conjunto de instruções e da unidade lógica e aritmética efetivamente usados.

:::{important}
Leia esse resumo com atenção depois de cada mudança relevante no algoritmo. Ele é a medida mais direta do custo em área do seu programa, e a diferença entre duas compilações mostra exatamente o que uma alteração de uma linha custou.
:::

O assunto está desenvolvido em {doc}`../linguagem/avancado`.

## O TCMD, o shell integrado

A aba TCMD é um terminal PowerShell real, com um *prompt* próprio da AURORA. Digite qualquer comando, como `git`, `python` ou `cd`, e tecle {kbd}`Enter`. O diretório atual e as variáveis de ambiente persistem entre comandos, como em um terminal comum.

Ele abre no diretório do projeto e acompanha o contexto do projeto ou processador ativo. O menu de contexto da árvore de arquivos oferece {guilabel}`Abrir no Terminal Integrado`, que muda a sessão para a pasta escolhida.

É também esse *shell* que a Aurora Intelligence usa quando você autoriza a ferramenta de execução de comandos, conforme {doc}`../ia/ferramentas`.

:::{note}
Use o TCMD para tarefas auxiliares, como Git avançado ou *scripts* Python que analisem os {file}`output_*.txt`. Para compilar e simular, prefira os botões da barra superior, que cuidam de argumentos, caminhos e ordem das etapas por você.
:::

:::{warning}
Os comandos são executados com as suas permissões de usuário. Confira o diretório exibido no *prompt* antes de alterar ou remover arquivos.
:::

## Uma decisão de segurança que explica um limite

A AURORA só executa binários da própria cadeia de ferramentas, validados contra uma lista fechada, e os botões não passam por um *shell*. É por isso que a IDE não oferece a execução de comandos arbitrários fora do TCMD.

Se você esperava um campo de opções de linha de comando em algum botão e não o encontrou, esta é a razão.

## Exportar para relatar um problema

O botão de exportação salva o conteúdo do terminal atual em arquivo. Junto com o registro principal em {file}`%APPDATA%\Aurora-IDE\logs\main.log`, é o que se anexa ao relatar um problema nos repositórios da organização `nipscernlab`.

## Leitura relacionada

- {doc}`../fluxos/compilacao` explica o que cada etapa da cadeia produz.
- {doc}`../referencia/diagnostico` reúne sintomas e soluções por sintoma.
- {doc}`../configuracao/preferencias` mostra onde ligar e desligar o Modo Verboso.
