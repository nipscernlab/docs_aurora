# Instalação

O SAPHO roda em Windows 10 e 11, 64 bits. A instalação traz tudo: a AURORA, os compiladores do YANC, os simuladores, os visualizadores de onda e um Python embarcado. Não é preciso instalar nada além do pacote.

## Baixar

Baixe o instalador no site do NIPS-CERN:

<https://www.nipscern.com/projects/sapho>

O botão {guilabel}`Download Latest Release` baixa diretamente o instalador da versão mais recente, um arquivo com nome no formato {file}`sapho-aurora-Setup-vX.Y.Z.exe`, com cerca de 500 MB. Se preferir, as versões anteriores ficam na página de releases do GitHub, no mesmo lugar.

## Instalar

1. Execute o instalador baixado.
2. Se o Windows exibir o aviso do SmartScreen dizendo que o aplicativo não é reconhecido, clique em {guilabel}`Mais informações` e depois em {guilabel}`Executar assim mesmo`. O aviso aparece porque o executável ainda não carrega assinatura digital; a assinatura pela SignPath Foundation está em andamento e o aviso deixará de existir.
3. Siga o assistente: aceite a licença, escolha a pasta de destino e conclua.

```{figure} ../_static/assets/screenshots/aurora-instalador.png
:alt: Assistente de instalação do SAPHO no Windows.
:width: 75%
:align: center

O assistente de instalação. O padrão instala para o usuário atual, sem exigir privilégios de administrador.
```

:::{warning}
Não execute o instalador como administrador. A atualização automática usa o mesmo caminho da instalação, e uma instalação feita como administrador impede o atualizador de trabalhar depois.
:::

## Primeiro início

Abra o SAPHO pelo menu Iniciar. Após a tela de abertura, você chega à tela de boas-vindas:

```{figure} ../_static/assets/screenshots/aurora-primeiro-inicio.png
:alt: Tela de boas-vindas da AURORA no primeiro início, sem projetos recentes.
:width: 90%
:align: center

A tela de boas-vindas. À esquerda, criar ou abrir projeto; à direita, a lista de projetos recentes, vazia no primeiro uso.
```

Confirme que está tudo pronto:

- A barra de status, no rodapé, mostra {guilabel}`Não Pronto`. É o esperado sem projeto aberto; clicar nela abre o diálogo de projeto.
- Em {guilabel}`Configurações` (ícone de controles deslizantes na barra superior), a aba {guilabel}`Sobre` mostra a versão instalada e a situação do atualizador.

## Idioma

A interface nasce em inglês ou português conforme o sistema. Para trocar: {guilabel}`Configurações`, aba {guilabel}`Idioma`. A escolha vale também para as mensagens dos compiladores, que falam português ou inglês conforme essa opção.

## Atualizações

A AURORA verifica atualizações sozinha, alguns segundos após abrir e depois a cada três horas. Quando há versão nova, uma janela mostra as novidades e pergunta se você quer baixar; nada é baixado sem a sua confirmação. Depois de baixada, a atualização se aplica ao fechar o aplicativo.

Próximo passo: {doc}`mapa-da-janela`.
