# Aurora Intelligence

A assistente de IA integrada. Ela conhece o projeto aberto, a linguagem C± e o fluxo da plataforma, e pode agir sobre a IDE: abrir arquivos, editar código, compilar, ler terminais. Cada ação passa pelo seu controle. Abra por {kbd}`Ctrl+K` ou pelo botão {guilabel}`Assistente IA`.

```{figure} ../_static/assets/screenshots/aurora-ia-painel.png
:alt: Painel da Aurora Intelligence com uma conversa sobre o projeto.
:width: 80%
:align: center
```

## Configurar

Funciona no modelo BYOK: você traz a chave ou a assinatura. Em {guilabel}`Configurações`, aba {guilabel}`Assistente IA`, três caminhos:

- **Chave de API**: OpenAI, Anthropic, Google, DeepSeek ou Groq. Cole a chave no cartão do provedor, teste, salve. As chaves ficam cifradas no cofre do sistema.
- **Assinatura**: Claude Code ou Codex, com login pela conta, sem chave.
- **Local**: Ollama, rodando um modelo na própria máquina, sem nada sair do computador.

```{figure} ../_static/assets/screenshots/aurora-settings-ia.png
:alt: Aba Assistente IA das configurações.
:width: 85%
:align: center
```

## Usar

Pedidos que funcionam bem: "explique o que este {file}`.cmm` faz e onde está o custo em hardware", "compile e me diga por que o TASM reclamou", "crie um testbench cocotb para o módulo contador". Selecionar código no editor faz aparecer uma estrela com atalhos: explicar, procurar defeitos, melhorar, comentar.

```{figure} ../_static/assets/screenshots/aurora-ia-selecao.png
:alt: Estrela de acao sobre uma selecao de codigo.
:width: 70%
:align: center
```

## Permissões e limites

O seletor de permissões do painel controla a autonomia. O padrão, {guilabel}`Perguntar antes de alterar`, deixa as leituras livres e pede confirmação para qualquer escrita, com o cartão {guilabel}`Permitir` ou {guilabel}`Negar` mostrando exatamente o que será feito.

```{figure} ../_static/assets/screenshots/aurora-ia-permissao.png
:alt: Cartao de confirmacao de uma acao da assistente.
:width: 75%
:align: center
```

Limites fixos, em qualquer modo: sem shell arbitrário, sem trocar os binários da cadeia de compilação, links externos só abrem com o seu aval, e toda ação fica registrada em um log local.

Em sala: a assistente é ótima para explicar erros e revisar testbench, e má ideia para fazer o exercício pelo aluno. O modo padrão deixa o aluno no comando de cada mudança. Sem rede ou sem chave, a plataforma funciona normalmente; só o painel fica indisponível.
