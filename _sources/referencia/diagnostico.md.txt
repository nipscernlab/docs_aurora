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
: Comportamento esperado com o Verilator. Troque para o Icarus para ver o processador por dentro.

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
- Exporte o log (botão na área de terminais) e anexe ao relato pelo {guilabel}`Relatar um problema` da aba {guilabel}`Sobre`.
