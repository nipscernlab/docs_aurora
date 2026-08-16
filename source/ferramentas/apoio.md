# Controle de versão, Python e configurações

As três ferramentas de apoio que completam a IDE.

## Controle de versão (Dagr)

O painel git da AURORA, aberto pelo botão {guilabel}`Controle de Versão` ou pelo item do GitHub na barra de status. O badge do botão mostra quantos arquivos mudaram.

```{figure} ../_static/assets/screenshots/aurora-dagr-alteracoes.png
:alt: Painel Dagr na aba Alteracoes com arquivos em stage e caixa de commit.
:width: 85%
:align: center
```

O essencial:

- **Alterações**: marque os arquivos, escreva o resumo e clique em {guilabel}`Commit`. Cada arquivo tem o diff inline e o botão de descartar.
- **Histórico**: a lista de commits, com o diff de cada arquivo por demanda.
- **Sincronizar**: {guilabel}`Fetch`, {guilabel}`Pull`, {guilabel}`Push`. O menu do branch cria, troca e mescla branches, com stash automático quando a troca esbarra em alterações não commitadas.
- **GitHub**: o login usa o fluxo de dispositivo (um código digitado no navegador, sem senha na IDE) ou um token pessoal. Logado, dá para publicar o projeto direto ({guilabel}`Privado` ou {guilabel}`Público`) e clonar os seus repositórios.
- Um projeto sem repositório oferece {guilabel}`Inicializar` na hora; o menu da árvore cria um {file}`.gitignore` adequado ao SAPHO.

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

## Configurações

{guilabel}`Configurações` abre as preferências, em sete abas:

| Aba | O que tem |
|---|---|
| Geral | tooltips da interface; confiar em links externos do chat da IA |
| Aparência | o fundo animado da tela de boas-vindas (desligado por padrão); trocar o ícone do aplicativo |
| Idioma | Português ou English, para a interface e para as mensagens dos compiladores |
| Terminal | modo verboso: mostra as linhas de comando completas de cada etapa |
| Atalhos de Teclado | regravar os atalhos principais; clique no atalho e pressione a combinação nova |
| Assistente IA | os cartões de provedores do capítulo anterior |
| Sobre | versão, situação do atualizador, equipe, manual online e offline, relatar problema, licenças |

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

A aba {guilabel}`Sobre` traz o {guilabel}`Manual (online)`, que abre este site, e o {guilabel}`Manual (offline)`, uma cópia completa instalada com o aplicativo, para a bancada sem internet. A cópia offline se atualiza sozinha quando uma versão nova do manual é publicada.

## Relatar um problema

Também na aba {guilabel}`Sobre`: o botão monta um e-mail para a equipe já com o diagnóstico da instalação (versão, sistema, o que estava aberto), no seu webmail de preferência. Quanto mais contexto no relato, melhor a resposta.
