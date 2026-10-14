# Instalação

O SAPHO roda em Windows 10 e 11, 64 bits. O instalador traz a AURORA e os compiladores do YANC, que são o SAPHO em si; o resto — simuladores, visualizadores de onda e o Python embarcado — são componentes que a própria AURORA baixa quando você for usar, sem instalar nada por fora. O primeiro download é guiado, como mostra a seção {ref}`cadeia-de-compilacao` abaixo.

## Baixar

Baixe o instalador no site do NIPS-CERN:

<https://www.nipscern.com/projects/sapho>

O botão {guilabel}`Download Latest Release` baixa diretamente o instalador da versão mais recente, um arquivo com nome no formato {file}`sapho-aurora-Setup-vX.Y.Z.exe`, com cerca de 140 MB. Se preferir, as versões anteriores ficam na página de releases do GitHub, no mesmo lugar.

## Instalar

1. Execute o instalador baixado.
2. Se o Windows exibir o aviso do SmartScreen dizendo que o aplicativo não é reconhecido, clique em {guilabel}`Mais informações` e depois em {guilabel}`Executar assim mesmo`. O aviso aparece porque o executável ainda não carrega assinatura digital; a assinatura pela SignPath Foundation está em andamento e o aviso deixará de existir.
```{figure} ../_static/assets/screenshots/aurora-smartscreen.png
:alt: Aviso do SmartScreen dizendo que o aplicativo nao e reconhecido.
:width: 55%
:align: center

O aviso do SmartScreen. {guilabel}`Mais informações` revela o botão {guilabel}`Executar assim mesmo`.
```

3. Leia e aceite a licença. Com o aceite, a instalação segue sozinha até o fim: instala para o usuário atual, sem pedir pasta nem senha de administrador.

```{figure} ../_static/assets/screenshots/aurora-instalador.png
:alt: Página de licença do instalador do SAPHO no Windows.
:width: 75%
:align: center

A página de licença do instalador; o aceite é obrigatório. O padrão instala para o usuário atual, sem exigir privilégios de administrador.
```

:::{warning}
Não execute o instalador como administrador. Rodado com "Executar como administrador", o SAPHO se instala no perfil do administrador, e o aluno que fizer login depois não encontra nada; além disso, a atualização automática deixa de funcionar. Se a máquina do laboratório pede senha para instalar, a senha serve para liberar a política de execução, não para elevar o instalador.
:::

O instalador também registra as extensões {file}`.spf`, {file}`.cmm` e {file}`.v`: um duplo clique num {file}`.spf` abre o projeto, e num {file}`.cmm` ou {file}`.v` abre o arquivo solto no editor.

(cadeia-de-compilacao)=
## A cadeia de compilação

Na primeira abertura, a AURORA avisa que a máquina ainda não compila: a cadeia de compilação — Icarus Verilog, Verilator, Yosys e o Python embarcado — não vem no instalador, para que ele caiba em 140 MB. Um diálogo oferece o download (cerca de 272 MB), e aceitar já abre a aba {guilabel}`Componentes` das Configurações com o download andando.

```{figure} ../_static/assets/screenshots/aurora-componentes-boot.png
:alt: Diálogo avisando que a cadeia de compilação ainda não foi baixada.
:width: 65%
:align: center

O aviso do primeiro início. {guilabel}`Baixar agora` resolve; {guilabel}`Agora não` deixa para depois, e o aviso volta na próxima abertura.
```

Até esse download terminar, os botões de compilar e simular não funcionam, e a engrenagem de {guilabel}`Configurações` na barra superior fica com um ponto de aviso aceso. Tudo o que se baixa, se conserta e se remove por ali está descrito em {doc}`../diaadia/apoio`.

## Primeiro início

```{figure} ../_static/assets/screenshots/aurora-splash.png
:alt: Tela de abertura da AURORA, com o logotipo e a barra de carregamento.
:width: 70%
:align: center

A tela de abertura enquanto os componentes são conferidos. O rodapé mostra o progresso e a versão.
```

```{figure} ../_static/assets/screenshots/aurora-boas-vindas.png
:alt: Tela de boas-vindas da AURORA com a lista de projetos recentes.
:width: 100%
:align: center

A tela de boas-vindas. Os projetos abertos recentemente ficam à direita; os que sumiram do disco aparecem riscados, com uma lupa que os procura no computador e o botão de esquecê-los.
```

Abra o SAPHO pelo menu Iniciar. Após a tela de abertura, você chega à tela de boas-vindas:

```{figure} ../_static/assets/screenshots/aurora-primeiro-inicio.png
:alt: Tela de boas-vindas da AURORA no primeiro início, sem projetos recentes.
:width: 90%
:align: center

A tela de boas-vindas. À esquerda, criar ou abrir projeto e o botão {guilabel}`Projetos de exemplo...`, que instala cinco projetos prontos; à direita, a lista de projetos recentes, vazia no primeiro uso.
```

Confirme que está tudo pronto:

- A barra de status, no rodapé, mostra {guilabel}`Não Pronto`. É o esperado sem projeto aberto; clicar nela abre o diálogo de projeto.
- Em {guilabel}`Configurações` (ícone de controles deslizantes na barra superior), a aba {guilabel}`Sobre` mostra a versão instalada e a situação do atualizador.

## Idioma

A interface nasce em inglês ou português conforme o sistema. Para trocar: {guilabel}`Configurações`, aba {guilabel}`Idioma`. A escolha vale também para as mensagens dos compiladores, que falam português ou inglês conforme essa opção.

## Atualizações

A AURORA verifica atualizações sozinha, alguns segundos após abrir e depois a cada três horas. Quando há versão nova, uma janela mostra as novidades e pergunta se você quer baixar; nada é baixado sem a sua confirmação.

```{figure} ../_static/assets/screenshots/aurora-atualizacao.png
:alt: Janela de atualizacao com a versao nova e a lista de novidades.
:width: 65%
:align: center

O aviso traz a versão atual, a nova, o tamanho do pacote e o changelog da release.
```

O download acontece em segundo plano, com progresso à vista, e ao terminar a AURORA pergunta se pode reiniciar. Quem responder {guilabel}`Instalar depois` não perde nada: a atualização baixada fica guardada e se instala sozinha na próxima vez que a AURORA abrir, antes de a janela aparecer.

```{list-table}
:widths: 50 50
:align: center

* - ```{image} ../_static/assets/screenshots/aurora-atualizacao-baixando.png
    :alt: Janela mostrando o progresso do download da atualizacao.
    :width: 100%
    ```
  - ```{image} ../_static/assets/screenshots/aurora-atualizacao-pronta.png
    :alt: Janela avisando que a atualizacao esta pronta para instalar.
    :width: 100%
    ```
```

Próximo passo: {doc}`mapa-da-janela`.
