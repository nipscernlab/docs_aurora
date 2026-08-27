# Diagnóstico: sintomas e causas

As falhas mais comuns de cada fluxo, com a causa e a correção. Regra geral que resolve metade dos casos: leia a primeira mensagem de erro, não a última, e clique no link de linha.

## Botões desabilitados

| Botão cinza | Falta |
|---|---|
| {guilabel}`Compilar C±` | um arquivo {file}`.cmm` aberto e em foco no editor |
| {guilabel}`Sintetizar Verilog`, {guilabel}`Abrir PRISM` | um Top Level definido |
| {guilabel}`Analisar Verilog`, {guilabel}`Configuração de ondas` | um Testbench Top definido |
| {guilabel}`Execução rápida` | testbench definido, e Verilator selecionado ou testbench em Python |
| {guilabel}`Teste do processador sintetizado` | um processador ativo (o {file}`.cmm` dele em foco) |
| engrenagem de configuração | idem |

Um caso à parte: se o clique abre o diálogo {guilabel}`Componente não instalado`, não falta pré-requisito de projeto — falta a ferramenta. {guilabel}`Baixar agora` resolve na hora, e o painel completo está em {doc}`../diaadia/apoio`.

## Projeto

O nome foi recusado
: Nomes de projeto e de processador aceitam letras, números, hífen e sublinhado. Sem espaços e sem acentos.

Aviso de arquivos ausentes na árvore
: O {file}`.spf` lista arquivos que sumiram do disco (movidos ou apagados por fora). O botão do aviso remove as referências, com confirmação.

## Compilação C±

O compilador aponta uma linha
: O link abre o editor no ponto. Erros em cascata quase sempre derivam do primeiro.

`Constante aproximada`
: A constante não cabe exata no formato de ponto flutuante escolhido. Informativo; se a precisão incomodar, aumente a mantissa ({doc}`../avancado/ponto-flutuante`).

O total de bits foi recusado
: `NUBITS` deve ser igual a `NBMANT + NBEXPO + 1`. Vale no Hub e nas diretivas.

Arquivo em {file}`Hardware/` mas o terminal mostra erro
: O arquivo é de uma compilação anterior. Vale o terminal.

## Validação Verilog

`Unknown module type: X`
: Um módulo instanciado não está em nenhum fonte do projeto. Se `X` é um processador, compile o C± dele antes; o {file}`.v` gerado precisa existir.

Portas incompatíveis
: A instância diverge da definição. O analisador semântico do editor aponta antes do botão.

## Simulação e ondas

A simulação termina antes do resultado
: Poucos ciclos. Engrenagem do processador, aumente o número de clocks.

A onda abre sem os sinais internos do processador
: Com o Verilator, os monitores de pilha e ULA entram por espelhos no testbench, mas o miolo mais profundo fica de fora; e um programa sem funções não tem pilha de instruções para monitorar. Para ver tudo, troque para o Icarus.

A simulação aborta citando o arquivo de onda
: O arquivo da rodada anterior está aberto em outro programa ou ficou somente-leitura, e a AURORA prefere abortar a mostrar uma onda velha como se fosse nova. Feche o visualizador (GTKWave/Surfer) e simule de novo.

`$fopen devolveu 0` ou "invalid file descriptor"
: O testbench abre um arquivo que não existe ou não pode ser escrito. A AURORA avisa antes de rodar quando o caminho de leitura não existe; confira os caminhos dos `$fopen` do testbench.

Sinal selecionado não aparece
: A seleção de ondas referencia um sinal que não existe mais (código mudou). Reabra a {guilabel}`Configuração de ondas` e salve de novo; a AURORA remove as referências mortas.

O testbench não encontra os dados
: {file}`input_N.txt` ausente ou com linha inválida. Um inteiro por linha, sem vazios.

cocotb reprova os testes mas a onda abre
: Comportamento intencional: a onda é a ferramenta de investigação da falha. O veredito de cada teste está no TWAVE.

cocotb não acha o módulo alvo
: Falta a linha `# aurora-toplevel: nome` no {file}`.py`, ou o nome não confere.

## PRISM

Recusa por tamanho no modo interativo
: O diagrama estático não tem limite; a simulação interativa é para designs pequenos.

Diagrama desatualizado
: {guilabel}`Recompile` na própria janela do PRISM.

## Quando nada explica

- Ligue o modo verboso ({guilabel}`Configurações`, {guilabel}`Terminal`) e repita: os comandos completos de cada etapa aparecem no terminal.
- Rode {guilabel}`Verificar e consertar` na aba {guilabel}`Componentes`: ele limpa os caches de compilação, confere os arquivos de cada componente e baixa de novo o que estiver incompleto ou quebrado — o conserto clássico para uma toolchain que o antivírus mordeu.
- Use o {guilabel}`Relatar` da aba {guilabel}`Geral`: o relato já vai com o diagnóstico da instalação e o terminal recortado em volta dos erros, e a tela mostra tudo antes de enviar.
