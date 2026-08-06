# Instalação e primeiro início

A AURORA é hoje um aplicativo exclusivamente Windows, para sistemas de 64 bits. A instalação é de um clique e traz embutida toda a cadeia de compilação e simulação, de modo que nenhum outro programa precisa ser instalado antes ou depois.

## Antes de instalar

:::{list-table}
:header-rows: 1
:widths: 30 70

* - Requisito
  - Detalhe
* - Sistema operacional
  - Windows 10 ou Windows 11, 64 bits
* - Espaço em disco
  - Cerca de 2 GB para o aplicativo e a cadeia de ferramentas, mais o espaço dos seus projetos
* - Permissões
  - Permissão de escrita na pasta escolhida para os projetos
* - Conexão
  - Necessária apenas para baixar o instalador e, depois, para as atualizações e a assistente de IA
:::

Não é preciso instalar Python, compiladores C, simuladores Verilog nem GTKWave por fora. Tudo isso acompanha o instalador em versões validadas em conjunto.

## Baixar e instalar

1. Acesse o canal oficial de distribuição em [nipscern.com/sapho](https://nipscern.com/sapho) e baixe o instalador, um arquivo chamado {file}`sapho-aurora-Setup-vX.Y.Z.exe`, no qual `X.Y.Z` é a versão.
2. Dê dois cliques no executável.
3. Aguarde. O instalador é do tipo *one-click*: não há telas de opções nem escolha de pasta. Ele instala, cria os atalhos na área de trabalho e no menu Iniciar e abre o aplicativo.
4. Na primeira abertura, confira a versão instalada em {menuselection}`Configurações do Aurora --> Sobre`.

:::{note}
O instalador ainda não é assinado digitalmente, e o Windows SmartScreen pode exibir um aviso de editor desconhecido na primeira execução. Nesse caso, clique em {guilabel}`Mais informações` e depois em {guilabel}`Executar assim mesmo`.
:::

Durante a instalação, dois vínculos são registrados no sistema. A extensão {file}`.spf`, dos arquivos de projeto do SAPHO, passa a abrir com a AURORA e ganha ícone próprio, de modo que dois cliques em um projeto no Explorador de Arquivos o abrem diretamente. Também é registrado o protocolo `sapho://`, reservado a integrações via navegador.

## O que é instalado, e onde

Saber onde as coisas ficam ajuda tanto no diagnóstico quanto no *backup*.

::::{tab-set}

:::{tab-item} Pasta do aplicativo

Recebe o executável da AURORA e a pasta {file}`components`, que reúne a cadeia de ferramentas completa: os compiladores do YANC, os simuladores Icarus Verilog e Verilator, o Yosys, o GTKWave, o Python com cocotb e os moldes de HDL do processador.

Se essa pasta for movida ou tiver conteúdo removido, os botões de compilação passam a falhar com a mensagem de binário não encontrado. A correção é reinstalar pelo instalador oficial.
:::

:::{tab-item} Dados do usuário

Ficam em {file}`%APPDATA%\Aurora-IDE`:

- {file}`logs/main.log`, o registro principal de execução, e {file}`logs/main.old.log`, o anterior;
- a lista de projetos recentes;
- o registro de versão usado na confirmação após uma atualização;
- as conversas da Aurora Intelligence.

É o {file}`main.log` que se anexa ao relatar um problema.
:::

:::{tab-item} Credenciais

As chaves de API da Aurora Intelligence e o *token* do GitHub não vão para arquivo algum. São cifradas pelo cofre de credenciais do próprio Windows, a DPAPI, e usadas somente pelo processo principal da AURORA. A interface exibe apenas se existe uma chave configurada, nunca o valor.
:::

:::{tab-item} Seus projetos

Ficam onde você quiser. A AURORA pergunta a pasta ao criar cada projeto e não impõe um diretório de trabalho. Para fazer *backup* do seu trabalho, copie a pasta completa que contém o {file}`.spf`; veja {doc}`../uso/projetos`.
:::

::::

## Primeira execução

Ao abrir, a AURORA exibe uma tela de abertura com o progresso real da inicialização e, em seguida, a tela de boas-vindas: o fundo animado de aurora boreal, os botões {guilabel}`Novo Projeto` e {guilabel}`Abrir Projeto` e a lista de projetos recentes, vazia na primeira vez.

Confirme que a instalação está saudável verificando estes cinco pontos:

- [ ] a janela principal abriu e não ficou presa na tela de carregamento;
- [ ] {guilabel}`Novo Projeto` e {guilabel}`Abrir Projeto` respondem ao clique;
- [ ] a área central do editor aparece;
- [ ] {guilabel}`Configurações do Aurora` abre e mostra a versão em {guilabel}`Sobre`;
- [ ] a barra inferior indica que a aplicação está pronta.

Cerca de seis segundos após abrir, a AURORA consulta silenciosamente se há uma versão mais nova. Se você já está na última, nada acontece. Havendo versão nova, a janela de atualização aparece, com o registro de mudanças e o tamanho do download; nada é baixado sem o seu aval.

## Atualizações

Manter o SAPHO em dia não exige nada além de aceitar as atualizações quando oferecidas. Ao aceitar, a barra de progresso mostra percentual, velocidade e tempo restante, e é possível continuar trabalhando durante o download. Com o pacote pronto, o botão vira {guilabel}`Reiniciar e instalar`: a AURORA fecha, o instalador roda e a IDE reabre na versão nova.

A integridade do pacote é verificada por resumo criptográfico antes de instalar, e cada instalador carrega a versão da cadeia de ferramentas testada com aquela versão da IDE. Atualizar a AURORA atualiza o conjunto inteiro, em versões validadas juntas, sem nada para gerenciar manualmente.

:::{admonition} Dois repositórios, por desenho
:class: dropdown

O desenvolvimento acontece no repositório `nipscernlab/aurora`, e as versões estáveis são publicadas em `nipscernlab/sapho`, que é o canal consumido pelo instalador e pelo atualizador. Você sempre recebe versões estáveis, nunca o estado intermediário do desenvolvimento.
:::

## Se a AURORA não iniciar

1. Aguarde alguns segundos e confirme que a preparação inicial não está apenas em andamento.
2. Verifique se outra janela da AURORA já está aberta.
3. Reinicie o aplicativo pelo menu Iniciar.
4. Se o problema persistir, anote a versão do Windows e a etapa em que a abertura parou e anexe o {file}`%APPDATA%\Aurora-IDE\logs\main.log` ao relato.

Consulte {doc}`../referencia/diagnostico` para uma investigação orientada por sintomas.

## Desinstalação

Use as Configurações do Windows, em Aplicativos, e desinstale o item Aurora-IDE. Os projetos criados por você não são apagados: eles pertencem às pastas que você escolheu.

## O próximo passo

Com o aplicativo aberto, siga para {doc}`tour-interface` e conheça as regiões da janela, ou vá direto ao {doc}`primeiro-projeto` se preferir aprender construindo.
