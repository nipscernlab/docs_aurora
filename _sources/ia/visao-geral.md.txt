# Aurora Intelligence

A Aurora Intelligence é a assistente de inteligência artificial integrada à AURORA. Ela conversa sobre o projeto, a linguagem C±, o Verilog, a arquitetura SAPHO e as mensagens do compilador e, com a sua permissão, age sobre a IDE: edita arquivos, compila, dispara simulações, seleciona sinais de onda e opera o Git.

```{figure} ../_static/assets/screenshots/aurora-intelligence-panel-current.png
:alt: Painel da Aurora Intelligence aberto ao lado do editor.
:width: 100%
:align: center
:name: fig-ai-painel

O painel permanece ao lado do editor, de modo que você formula o pedido enquanto o arquivo e o estado do projeto continuam visíveis.
```

## O que a distingue de uma assistente genérica

A diferença não é o modelo: é o conhecimento de domínio. A assistente é especializada na linguagem C± e no fluxo do SAPHO por dois mecanismos complementares.

::::{grid} 1 2 2 2
:gutter: 3

:::{grid-item-card} Conhecimento derivado do compilador

A identidade e as regras da linguagem vêm de um *system prompt* extenso montado a partir da própria gramática do YANC: os tipos, as diretivas obrigatórias, as restrições de projeto, a notação de Dirac e o conjunto de *opcodes* do *assembly*.

Como esse conhecimento é derivado do compilador, e não apenas da memória do modelo, o risco de alucinação sobre a sintaxe e as regras do SAPHO cai substancialmente. Quando o conjunto de instruções cresce, o *prompt* acompanha.
:::

:::{grid-item-card} Ferramentas de domínio

Além do texto, a assistente dispõe de ferramentas específicas: a listagem de diretivas, a análise de arquivos *assembly* e a consulta ao catálogo bilíngue de mensagens do compilador, cujo conteúdo é gerado automaticamente a partir das fontes do YANC.

Perguntar por que um {file}`.cmm` não compila é, portanto, uma pergunta que ela responde consultando a fonte, e não adivinhando.
:::

::::

:::{note}
A assistente funciona no modelo de trazer a própria chave (BYOK, *Bring Your Own Key*): você conecta a sua conta de um provedor. Modelos próprios do NIPS-CERN estão no roteiro do laboratório, mas ainda não foram treinados; até lá, a assistente opera sobre provedores externos. Veja {doc}`provedores`.
:::

## Como ela funciona por dentro

O comportamento é agêntico: em vez de devolver uma única resposta em texto, ela atua em um laço no qual invoca ferramentas, observa os resultados e decide o passo seguinte, até cumprir a tarefa. Esse laço executa no processo principal da IDE e é limitado a um número máximo de passos por turno, o que evita recursões descontroladas.

```{mermaid}
flowchart LR
  U["Você<br>pede algo"] --> L["Laço agêntico<br><small>processo principal</small>"]
  L --> T["Ferramentas da AURORA<br><small>ler, editar, compilar, simular</small>"]
  T --> C["Cadeia YANC<br>e simuladores"]
  C --> T
  T --> L
  L --> R["Resposta com o<br>que foi feito"]
  L -.->|ação de escrita| P["Cartão de<br>permissão"]
  P -.->|permitir ou negar| L
```

Falhas nunca interrompem o laço: são devolvidas como resultado de erro, permitindo que o modelo se recupere e tente outro caminho. Toda chamada de ferramenta e o seu desfecho ficam registrados em um *log* de auditoria.

## Abrir e usar o painel

O botão {guilabel}`Assistente IA`, a estrela da barra superior, abre o painel à direita, empurrando o editor. A largura é ajustável e lembrada entre sessões. O cabeçalho traz o ícone do provedor ativo e os botões de histórico de conversas, nova conversa e fechamento.

Na caixa de mensagem ficam os seletores de provedor e de modelo, o controle de esforço de raciocínio para os modelos que o suportam, o indicador de uso da conversa, o seletor de permissões, o botão de anexar arquivos ou imagens e o de interromper a geração. {kbd}`Enter` envia.

:::{tip} O caminho mais curto
Selecione um trecho de código no editor e clique na estrela que aparece junto à seleção. O trecho vai para a assistente já contextualizado, com caminho e linguagem do arquivo.
:::

## Para que ela é boa no fluxo SAPHO

Alguns usos que rendem particularmente bem:

- perguntar por que um C± não compila, já que ela lê o terminal, conhece as mensagens do YANC e propõe a correção;
- estimar quanto *hardware* custa uma função, consultando a referência de *opcodes* e o *assembly* gerado;
- pedir um *testbench* em cocotb que compare o processador com um modelo de referência em NumPy;
- pedir que selecione os sinais das portas e abra as formas de onda;
- explicar um trecho de Verilog gerado que você não reconhece.

:::{admonition} Um exemplo real do que ela consegue fazer sozinha
:class: seealso

Em um estudo de caso publicado pelo laboratório, o pedido foi deliberadamente aberto: olhar o *assembly* gerado de um processador de FFT e reduzir o número de instruções sem alterar o comportamento, recompilando e simulando para confirmar.

A assistente identificou uma redundância semântica no bloco de saída, aplicou a transformação, recompilou e verificou a equivalência sobre as formas de onda, reduzindo o código de 325 para 269 instruções, 17,2% a menos, sem alterar a saída da simulação. Todo o percurso foi conduzido por ela, decidindo a cada passo qual ferramenta invocar.
:::

## Como pedir bem

A assistente trabalha melhor quando o pedido informa o objetivo, o arquivo e a etapa atual. Em vez de pedir apenas "corrija o projeto", indique o erro observado e peça que a primeira causa seja explicada antes de qualquer modificação.

```text
Explique o arquivo ativo e diga qual é o módulo principal.
```

```text
Leia o terminal Verilog e identifique o primeiro erro que preciso corrigir.
```

```text
Liste os sinais do testbench e sugira apenas clock, reset, entradas e saídas.
```

```text
Antes de editar, mostre exatamente quais linhas pretende alterar.
```

## Um fluxo de trabalho seguro

1. peça uma análise;
2. solicite um plano curto;
3. aprove uma alteração pequena;
4. revise o resultado;
5. compile ou simule;
6. só então continue.

Esse ciclo evita acumular várias mudanças antes de descobrir qual delas introduziu o problema. Para tarefas maiores, peça que a assistente divida o trabalho em etapas independentes.

Uma confirmação autoriza a ação mostrada naquele momento; ela não substitui a revisão do resultado. Depois de qualquer escrita, abra o arquivo alterado, confira o conteúdo e execute a validação adequada.

:::{important}
Versione o projeto em Git antes de trabalhar com a assistente. Cada passo dela vira um *diff* revisável no painel Dagr, o que torna qualquer alteração reversível. Veja {doc}`../uso/source-control`.
:::

## Conversas e disponibilidade

Cada conversa é salva localmente, e o histórico reabre conversas antigas com o contexto completo. Sem conexão com o provedor, o painel indica que a assistente está *offline*.

## Privacidade

O conteúdo enviado depende do provedor configurado:

- provedores em nuvem recebem as mensagens e o contexto necessário;
- o Ollama processa o modelo localmente, na sua máquina;
- Claude Code e Codex usam as suas próprias contas e ferramentas de linha de comando.

As chaves de API são cifradas em repouso pelo cofre do sistema operacional e nunca atravessam a fronteira de processos, não havendo canal para a sua leitura. A interface exibe apenas se existe uma chave configurada, jamais o valor.

:::{warning}
Não envie projetos confidenciais sem verificar as regras do provedor. Remova segredos dos arquivos antes de usá-los como contexto, e ao relatar um erro de autenticação descreva apenas a mensagem recebida e o nome do provedor.
:::

## Leitura relacionada

- {doc}`provedores` cobre a configuração de cada provedor e das assinaturas.
- {doc}`ferramentas` lista o que ela pode ler e o que exige confirmação.
- {doc}`mcp-cli` explica o servidor local que expõe as ferramentas da AURORA a agentes externos.
