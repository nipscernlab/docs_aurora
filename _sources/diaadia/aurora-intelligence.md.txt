# Aurora Intelligence

A assistente de IA integrada. Ela conhece o projeto aberto, a linguagem C± e o fluxo da plataforma, e pode agir sobre a IDE: abrir arquivos, editar código, compilar, ler terminais. Cada ação passa pelo seu controle. Abra por {kbd}`Ctrl+K` ou pelo botão {guilabel}`Assistente IA`.

## Como ela age na IDE

O que separa a Aurora Intelligence de um chat comum é o acesso: ela conversa com as mesmas funções internas que os seus botões chamam. A AURORA expõe à assistente um conjunto de ferramentas, e o modelo escolhe qual usar a cada passo.

São as operações do dia a dia da IDE: listar e ler os arquivos do projeto, escrever ou alterar um arquivo, abrir um arquivo no editor, disparar a compilação C± ou a análise Verilog, ler o que saiu em cada terminal, consultar a configuração do processador ativo, rodar um comando no TCMD, abrir o PRISM ou um visualizador de ondas, e pesquisar o próprio manual.

O ciclo é sempre o mesmo: você descreve o objetivo, o modelo pede uma ferramenta, a AURORA executa e devolve o resultado, e o modelo decide o passo seguinte com esse resultado em mãos. Por isso um pedido como "compile e me diga por que o TASM reclamou" funciona: ela compila de verdade, lê o terminal de verdade e responde sobre o seu erro, não sobre um erro genérico.

Nada disso acontece pelas suas costas. Toda ferramenta que modifica o projeto ou executa algo aparece antes como um cartão de confirmação, com {guilabel}`Permitir` ou {guilabel}`Negar`, e as de leitura podem ser liberadas de vez nas configurações. O modelo nunca alcança nada fora do projeto aberto: os caminhos são validados no processo principal da AURORA antes de qualquer operação de disco.

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
