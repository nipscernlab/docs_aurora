# Controle de versão, Python, componentes e configurações

As ferramentas de apoio que completam a IDE.

## Controle de versão (Git-D)

O painel git da AURORA, aberto pelo botão {guilabel}`Controle de Versão` ou pelas fichas de conta na barra de status. O badge do botão mostra quantos arquivos mudaram.

:::{note}
Quem usa a AURORA há mais tempo conheceu este painel como **Dagr**. É a mesma ferramenta: apenas abreviamos o nome para **Git-D**, que diz na hora do que se trata.
:::

```{figure} ../_static/assets/screenshots/aurora-dagr-alteracoes.png
:alt: Painel Git-D na aba Alteracoes com arquivos em stage e caixa de commit.
:width: 85%
:align: center
```

O essencial:

- **Alterações**: marque os arquivos, escreva o resumo e clique em {guilabel}`Commit`. Cada arquivo tem o diff inline e o botão de descartar.
- **Histórico**: a lista de commits, com o diff de cada arquivo por demanda.
- **Sincronizar**: {guilabel}`Fetch`, {guilabel}`Pull`, {guilabel}`Push`. O menu do branch cria, troca e mescla branches, com stash automático quando a troca esbarra em alterações não commitadas.
- **Contas**: GitHub e GitLab dividem a mesma fileira do painel, cada um com o seu cartão, sem hierarquia entre as forjas. O login de qualquer um usa o fluxo de dispositivo (o botão {guilabel}`Entrar` abre o navegador e mostra um código para digitar, sem senha na IDE) ou um token pessoal; no GitLab, o token precisa do escopo `api`, e um campo de instância aceita servidores próprios além do `gitlab.com`.
- **Repositórios**: logado, dá para publicar o projeto direto ({guilabel}`Privado` ou {guilabel}`Público`) e clonar os seus repositórios. A lista mistura as duas origens, ordenada por atividade, com um selo dizendo de onde vem cada uma; ao publicar com as duas contas conectadas, um seletor pergunta a forja.
- Um projeto sem repositório oferece {guilabel}`Inicializar` na hora; o menu da árvore cria um {file}`.gitignore` adequado ao SAPHO.
- A barra de status mostra as duas fichas o tempo todo: apagada quando a conta está desconectada, com a foto e o `@usuario` quando conectada.

```{figure} ../_static/assets/screenshots/aurora-gitd-contas.png
:alt: Painel Git-D com as contas do GitHub e do GitLab lado a lado.
:width: 85%
:align: center

As duas forjas no mesmo painel. O cartão muda de forma conforme a largura, mas o conteúdo é o mesmo.
```

:::{tip}
Em computador compartilhado, repare na opção {guilabel}`Limpar o acesso ao GitHub e ao GitLab ao fechar a AURORA`, na aba {guilabel}`Geral` das Configurações. Ela vem **ligada de fábrica**: ao fechar a AURORA, as duas contas saem do cofre da IDE, do arquivo de credenciais do git e do Gerenciador de Credenciais do Windows, sem depender de alguém lembrar. O botão {guilabel}`Limpar agora`, logo abaixo, faz o mesmo sem esperar o fechamento.
:::

```{figure} ../_static/assets/screenshots/aurora-dagr-historico.png
:alt: Aba Historico com o diff de um commit aberto.
:width: 85%
:align: center
```

A árvore de arquivos mostra o estado git de cada arquivo (modificado, novo, excluído) por letras e cores, nas duas visões.

## Bibliotecas Python (PyLibs)

O painel {guilabel}`Bibliotecas Python` instala pacotes para os testbenches cocotb e para scripts de análise, no Python embarcado da AURORA, sem tocar no Python da sua máquina.

```{figure} ../_static/assets/screenshots/aurora-pylibs.png
:alt: Painel de bibliotecas Python com o catalogo por categorias.
:width: 85%
:align: center
```

- O catálogo é curado: verificação de UVM e barramentos, leitura de ondas por script, gráficos, matemática, formatos de memória e comunicação serial. Cada item instala com um clique, com o download conferido por hash.
- Fora do catálogo, a seção {guilabel}`Outra biblioteca da PyPI` aceita qualquer pacote puro Python: a AURORA verifica a compatibilidade antes de baixar. Pacotes com código compilado (numpy, scipy, pandas) não rodam no Python embarcado; para esses, use o seu próprio Python pelo terminal.
- O isolamento é a regra: as bibliotecas do painel valem para o Python embarcado e para mais ninguém. No terminal TCMD, `apython script.py` roda com elas; `python` continua sendo o do sistema, com os seus pacotes do pip, a menos que você troque com `Use-Python aurora` (a troca vale só naquela sessão).
- Um vigia confere a integridade das bibliotecas de tempos em tempos; uma biblioteca quebrada (antivírus é a causa clássica) acende o badge do botão e ganha a ação {guilabel}`Reparar`.

## Componentes

O instalador da AURORA traz só o que é o SAPHO em si: a IDE e os compiladores do YANC. O resto — simuladores, visualizadores, formatadores, os agentes de IA — são **componentes**: ferramentas que você baixa quando for usar e pode remover para recuperar espaço. O painel mora em {guilabel}`Configurações`, aba {guilabel}`Componentes`, a segunda da lista.

```{figure} ../_static/assets/screenshots/aurora-componentes.png
:alt: Aba Componentes das Configuracoes, com os cartoes de cada ferramenta.
:width: 90%
:align: center

Cada componente é um cartão com a marca, um selo de estado, o tamanho e a ação. O rodapé resume o que falta baixar.
```

| Componente | O que é | Download |
|---|---|---|
| **MSYS Toolchain** | a cadeia de compilação: Icarus Verilog, Verilator, Yosys e o Python embarcado | 272 MB |
| **YANC** | os compiladores do SAPHO; vem no instalador e não pode ser removido | — |
| **GTKWave** | o visualizador de ondas clássico, em janela própria | 30 MB |
| **Surfer** | o visualizador de ondas embutido, dentro da AURORA | 16 MB |
| **Verible** | diagnósticos, formatação e navegação em Verilog, dentro do editor | 2 MB |
| **slang** | análise semântica de SystemVerilog | 3 MB |
| **clang-format** | formatação de C, C++ e C± com {kbd}`Shift+Alt+F` | 2 MB |
| **Claude Code** | o agente da Anthropic, usado pela Aurora Intelligence no modo Claude Code | 90 MB |
| **Codex** | o agente da OpenAI, usado pela Aurora Intelligence no modo Codex | 132 MB |

Como o painel se comporta:

- Cada cartão carrega **um selo**: {guilabel}`Instalado`, {guilabel}`Não instalado`, {guilabel}`Atualização disponível`, {guilabel}`Vem no instalador` (o YANC) ou {guilabel}`Necessário para compilar`, o selo urgente do MSYS e do YANC.
- As ações são {guilabel}`Baixar`, {guilabel}`Atualizar` e {guilabel}`Remover`. Remover mostra o preço antes: o que depende do componente para de funcionar, e tê-lo de volta custa o download de novo. Os seus projetos nunca são tocados.
- Tentar usar uma ferramenta cujo componente falta não dá erro seco: um diálogo explica o que falta e oferece {guilabel}`Baixar agora`, e as linhas de terminal que citam um componente ausente ganham um botão {guilabel}`Abrir Componentes`.
- O botão {guilabel}`Verificar e consertar` do rodapé — a maleta de primeiros socorros — limpa os caches, confere os arquivos de cada componente e baixa de novo o que estiver incompleto ou quebrado. Componente saudável não é tocado.
- {guilabel}`Abrir a pasta` leva ao lar dos componentes, {file}`%LOCALAPPDATA%\SAPHO\components`. A atualização da AURORA preserva essa pasta; desinstalar o SAPHO a apaga.

## Configurações

{guilabel}`Configurações` abre as preferências, em nove abas:

| Aba | O que tem |
|---|---|
| Geral | tooltips da interface; confiar em links externos do chat da IA; {guilabel}`Relatar um problema`; limpar o acesso ao GitHub e ao GitLab ao fechar (ligado por padrão) e {guilabel}`Limpar agora`; avisar quando a internet cair |
| Componentes | baixar, atualizar, consertar e remover as ferramentas; a seção acima |
| Aparência | o fundo animado da tela de boas-vindas (desligado por padrão); trocar o ícone do aplicativo |
| Idioma | Português ou English, para a interface e para as mensagens dos compiladores |
| Terminal | modo verboso: mostra as linhas de comando completas de cada etapa |
| Atalhos de Teclado | regravar os atalhos principais; clique no atalho e pressione a combinação nova |
| Assistente IA | os cartões de provedores do capítulo anterior |
| Manual | o manual do SAPHO neste computador; a seção abaixo |
| Sobre | versão, situação do atualizador, equipe, licenças |

```{figure} ../_static/assets/screenshots/aurora-settings-geral.png
:alt: Configuracoes da AURORA na aba Geral.
:width: 90%
:align: center

A aba Geral. As opções de conta do GitHub e do GitLab são as primeiras, porque são as que mais importam em computador compartilhado.
```

```{figure} ../_static/assets/screenshots/aurora-settings-atalhos.png
:alt: Aba de atalhos com um atalho em modo de gravacao.
:width: 85%
:align: center
```

Detalhe que evita surpresa: fechar o painel sem {guilabel}`Salvar Alterações` descarta o que foi mudado.

```{figure} ../_static/assets/screenshots/aurora-settings-sobre.png
:alt: Aba Sobre com versao, atualizacoes e links do manual.
:width: 85%
:align: center
```

## Este manual, dentro da AURORA

O manual tem aba própria nas Configurações: {guilabel}`Manual`. Um cartão de estado diz se a cópia offline está {guilabel}`Neste computador`, com a versão dela, e três botões fazem o resto: {guilabel}`Abrir na AURORA` abre a cópia local, sem internet; {guilabel}`Abrir no navegador` abre este site; {guilabel}`Procurar atualização` busca uma versão nova na hora. A cópia offline também se atualiza sozinha quando saem correções, sem esperar uma versão nova do aplicativo.

```{figure} ../_static/assets/screenshots/aurora-settings-manual.png
:alt: Aba Manual das Configuracoes, com o estado da copia offline e os botoes de abrir.
:width: 90%
:align: center
```

## Relatar um problema

O botão {guilabel}`Relatar`, na aba {guilabel}`Geral`, abre o formulário de relato: o que aconteceu, o que você esperava e como reproduzir, mais um e-mail opcional para receber a resposta. Antes de enviar, a seção {guilabel}`Ver o diagnóstico que vai junto` mostra exatamente o que acompanha o relato: versão, sistema, quais componentes a máquina tem e o terminal recortado em volta dos erros, com a vizinhança de cada um. Conteúdo de arquivos, senhas e conversas com a Aurora Intelligence nunca vão junto, e o nome de usuário é removido dos caminhos.

{guilabel}`Enviar relato` manda direto para a equipe; {guilabel}`Enviar por e-mail` monta a mensagem no seu webmail, para quem preferir. Quanto mais contexto no relato, melhor a resposta.

```{figure} ../_static/assets/screenshots/aurora-relato.png
:alt: Formulario de relato de problema com o diagnostico expandido.
:width: 80%
:align: center
```
