# Aurora Intelligence

A Aurora Intelligence é a assistente de IA integrada. Ela conhece o projeto aberto, a linguagem C± e o fluxo da plataforma, e pode agir sobre a IDE: abrir arquivos, editar código, compilar, ler terminais, marcar o Top Level. Cada ação passa pelo seu controle.

Abra pelo botão {guilabel}`Assistente IA` ou por {kbd}`Ctrl+K`. O painel entra à direita, empurrando o editor.

```{figure} ../_static/assets/screenshots/aurora-ia-painel.png
:alt: Painel da Aurora Intelligence com uma conversa sobre o projeto.
:width: 80%
:align: center
```

## Configurar um provedor

A assistente funciona no modelo BYOK: você traz a sua chave de API ou a sua assinatura. Três caminhos:

Provedores por API
: OpenAI, Anthropic, Google, DeepSeek, Groq. Em {guilabel}`Configurações`, aba {guilabel}`Assistente IA`, cada provedor tem um cartão: cole a chave, teste, salve. As chaves são guardadas cifradas pelo cofre de credenciais do sistema operacional e nunca voltam à interface.

Assinaturas
: Claude Code (Anthropic) e Codex (OpenAI). Sem chave: o login acontece pela conta da assinatura, e a AURORA baixa e gerencia a ferramenta de linha de comando sozinha, com verificação de integridade.

Local, sem nuvem
: Ollama. Rode um modelo na própria máquina e aponte o cartão do Ollama para ele; o botão de detecção lista os modelos instalados. Nenhum dado sai do computador.

```{figure} ../_static/assets/screenshots/aurora-settings-ia.png
:alt: Aba Assistente IA das configurações com os cartões de provedores.
:width: 85%
:align: center
```

O seletor no rodapé do painel troca provedor e modelo a qualquer momento, e mostra o uso da sessão.

## O que ela pode fazer

A assistente enxerga a IDE por um conjunto de ferramentas: ler e editar arquivos, criar processadores, compilar e simular, ler os terminais, gerenciar o git, ajustar a seleção de sinais da onda. Pedidos típicos que funcionam bem:

- "Explique o que este {file}`.cmm` faz e onde está o custo em hardware."
- "Compile e me diga por que o TASM reclamou."
- "Crie um testbench cocotb para o módulo contador."
- "Marque o top_filtro como Top Level e rode a análise."

Selecionar código no editor faz aparecer uma estrela com atalhos diretos: explicar, procurar defeitos, melhorar, comentar.

```{figure} ../_static/assets/screenshots/aurora-ia-selecao.png
:alt: Estrela de acao sobre uma selecao de codigo com o menu aberto.
:width: 70%
:align: center
```

## Permissões

O nível de autonomia é seu, no seletor de permissões do painel:

| Modo | Comportamento |
|---|---|
| Perguntar sempre | toda ação pede confirmação |
| Perguntar antes de alterar | leituras livres; qualquer escrita pede confirmação (padrão) |
| Permitir tudo | autonomia total |

Cada confirmação mostra a ferramenta, os argumentos e os botões {guilabel}`Permitir` e {guilabel}`Negar`. Algumas ações sensíveis pedem confirmação mesmo no modo de autonomia total.

```{figure} ../_static/assets/screenshots/aurora-ia-permissao.png
:alt: Cartao de confirmacao de uma acao da assistente.
:width: 75%
:align: center
```

Limites fixos, independentes do modo: a assistente não tem acesso a shell arbitrário fora das ferramentas listadas, não pode trocar os binários da cadeia de compilação (apenas flags, e com confirmação sempre), e links externos nas respostas só abrem no navegador com o seu aval. Toda ação executada fica registrada em um log de auditoria local.

## Boas práticas em sala

- A assistente é ótima para explicar erro de compilação e para revisar testbench; é má ideia para fazer o exercício pelo aluno. O modo "perguntar antes de alterar" deixa o aluno no comando de cada mudança.
- Sem rede ou sem chave, a plataforma inteira funciona normalmente; só o painel fica indisponível.
