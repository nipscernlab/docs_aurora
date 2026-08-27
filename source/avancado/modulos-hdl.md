# Os módulos HDL do SAPHO por dentro

Este capítulo abre a caixa: o que exatamente é o processador que o YANC gera, e por que ele merece o rótulo de soft-core otimizado. É leitura para quem vai estudar ou estender a arquitetura; o uso normal da plataforma não exige nada daqui.

## A biblioteca de módulos

O processador é montado a partir de uma biblioteca fixa de módulos Verilog, instalada com a AURORA em {file}`components/HDL`:

| Arquivo | Contém |
|---|---|
| {file}`processor.v` | as memórias de instrução e de dados, e o módulo `processor` que amarra tudo |
| {file}`core.v` | o contador de programa, o prefetch, as duas pilhas, o controle de memória e de I/O, e o núcleo |
| {file}`instr_dec.v` | o decodificador de instruções |
| {file}`ula.v` | a unidade lógica e aritmética, um submódulo por operação |
| {file}`addr_dec.v` | o decodificador one-hot das portas de I/O |
| {file}`myFIFO.v` | uma FIFO de uso geral, útil como amortecedor entre processadores no padrão produtor–consumidor de {doc}`interrupcao-multiproc` |

O arquivo gerado por projeto, {file}`Hardware/<proc>.v`, é um invólucro fino: instancia `processor` com os parâmetros do seu programa e liga as portas externas.

## A arquitetura

Um processador de **acumulador único**, **Harvard**, com **três estágios de pipeline** efetivos e uma instrução por ciclo:

- Memórias separadas de programa e de dados, com larguras independentes. As duas são inicializadas pelos {file}`.mif` via `$readmemb`.
- Não há banco de registradores: toda operação passa pelo acumulador. Expressões aninhadas usam a pilha de dados (profundidade `#NDSTAC`); chamadas de função usam a pilha de retorno (profundidade `#SDEPTH`).
- Os desvios resolvem no estágio de busca, sem penalidade. Não há forwarding nem stall porque a arquitetura não cria hazards: o caminho de dados e o de controle são casados por construção.
- Reset síncrono em todos os registradores de estado, uma escolha amigável a FPGA. A exceção deliberada são as memórias: para não impedir a inferência de block-RAM, as memórias de instrução e de dados não são resetadas. Depois de um `rst`, o contador de programa volta a zero e o programa recomeça, mas as variáveis guardam o valor da rodada anterior; um programa que dependa de estado inicial deve atribuí-lo explicitamente no começo do `main()`.
- O conjunto completo de instruções, com os 108 opcodes, está em {doc}`../referencia/instrucoes`.

## A otimização que dá nome à plataforma

Aqui está o mecanismo central. Abra um {file}`<proc>.v` gerado e olhe a instância do `processor`: além dos parâmetros numéricos, há uma lista de parâmetros com nomes de instruções, cada um ligado em 1:

```verilog
processor #(
    .NUBITS(16), .NBMANT(10), .NBEXPO(5),
    // ...
    .ADD(1), .S_ADD(1), .SHR(1), .INN(1), .OUT(1)
    // as demais instrucoes ficam em 0
) u_proc ( /* ... */ );
```

Cada instrução que o seu programa usa vira um parâmetro em 1. Dentro dos módulos da biblioteca, cada bloco está embrulhado em um `generate if` condicionado a esse parâmetro: **instrução não usada, bloco não sintetizado**. O somador de ponto flutuante, o divisor, o deslocador, cada um só existe no circuito se alguma linha do seu C± o exigir.

É por isso que o TASM imprime o relatório de recursos instanciados e a estimativa de uso do conjunto de instruções: aquilo é a lista dos `generate` que ligaram. E é por isso que trocar `/ 4` por `>> 2` no tutorial muda o diagrama do PRISM: o parâmetro `DIV` foi de 1 a 0, e o divisor evaporou.

O resultado prático: dois programas diferentes geram dois processadores de tamanhos diferentes sobre a mesma biblioteca. O processador é do tamanho do algoritmo, e o custo de área em FPGA acompanha o que o código pede, não o pior caso da arquitetura.

## A visibilidade de simulação

Os módulos carregam um arnês de simulação, ativado apenas nos simuladores, que expõe as suas variáveis pelo nome, as trilhas de assembly e de linha C±, e os sinais `delta_float` e `delta_int` de erro de arredondamento. Nada disso existe na síntese física: o `<proc>.v` sintetizado é só o circuito.

## Parâmetros derivados

Dois parâmetros são calculados pelo compilador, não escolhidos por você: a largura do campo de operando (que cresce com o tamanho do programa e dos dados) e os tamanhos das memórias (o número exato de instruções e de células de dados do programa). O processador não carrega memória sobrando.

Quem quiser ir além, o código-fonte da biblioteca e dos compiladores é aberto, no repositório do YANC na organização nipscernlab.
