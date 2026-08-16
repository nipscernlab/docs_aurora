# O processador dentro do seu Verilog

Até aqui os dois mundos andaram separados: Verilog escrito à mão na Parte II, processador gerado na Parte III. Este capítulo os junta: o processador vira um componente dentro de um circuito seu.

É o arranjo típico de um projeto real: o processador cuida do algoritmo, e a lógica em volta cuida do resto, como interfaces, sincronização e pré-processamento.

## As portas do processador gerado

Abra {file}`Hardware/media_movel.v` e olhe o cabeçalho do módulo. As portas que ele expõe:

| Porta | Direção | Largura | Papel |
|---|---|---|---|
| `clk` | entrada | 1 | clock |
| `rst` | entrada | 1 | reset síncrono |
| `in` | entrada | `NUBITS` | dado de entrada |
| `out` | saída | `NUBITS` | dado de saída |
| `req_in` | saída | depende das portas | qual porta de entrada o programa está lendo agora |
| `out_en` | saída | depende das portas | qual porta de saída o programa está escrevendo agora |

O aperto de mão é simples: quando o programa executa `in(k)`, o processador expõe `k` em `req_in` e espera o dado presente em `in`; quando executa `out(k, v)`, expõe `k` em `out_en` e `v` em `out` por um ciclo. Com uma porta só, `req_in` e `out_en` funcionam como sinais de "lendo agora" e "válido agora".

:::{tip}
O melhor guia de fiação é o testbench gerado, {file}`Simulation/media_movel_tb.v`: ele mostra exatamente como alimentar `in` em função de `req_in` e quando capturar `out`. Copiar a fiação dele para o seu top-level é o caminho seguro.
:::

## Um top-level de exemplo

Um gerador de estímulo em Verilog alimentando o filtro do tutorial: um contador produz uma rampa, e o processador devolve a média móvel dela.

```{code-block} verilog
:caption: top_filtro.v
:linenos:

module top_filtro (
    input  wire        clk,
    input  wire        rst,
    output wire [15:0] media,
    output wire        media_valida
);

    // gerador de estimulo: uma rampa que sobe de 8 em 8
    reg [15:0] rampa;
    wire       lendo;

    always @(posedge clk) begin
        if (rst)
            rampa <= 16'd0;
        else if (lendo)
            rampa <= rampa + 16'd8;
    end

    // o processador gerado pela Parte III
    media_movel u_filtro (
        .clk    (clk),
        .rst    (rst),
        .in     (rampa),
        .out    (media),
        .req_in (lendo),
        .out_en (media_valida)
    );

endmodule
```

Passos na AURORA:

1. Crie {file}`top_filtro.v` no projeto `MeuFiltro` (a classificação o marcará como sintetizável).
2. Botão direito, {guilabel}`Definir como Top Level`. O processador deixa de ser o topo e vira um componente.
3. Clique em {guilabel}`Sintetizar Verilog`. A elaboração resolve o módulo `media_movel` sozinha, porque o {file}`.v` gerado está no projeto.
4. Escreva um testbench para o `top_filtro` (clock, reset, `$dumpvars`, `$finish`), marque como Testbench Top e clique em {guilabel}`Analisar Verilog`.

Na onda, você verá a rampa entrando, o aperto de mão pulsando e a média saindo suavizada: dois mundos no mesmo diagrama de tempo.

:::{warning}
O processador carrega as memórias por `$readmemb` com os arquivos {file}`.mif`. Recompile o C± antes de simular o conjunto, para as imagens de memória estarem atualizadas com o programa.
:::

## Hierarquia e PRISM

Com o top-level seu, a visão {guilabel}`Hierarquia` mostra o processador como uma instância entre as outras, e o PRISM desenha o conjunto: sua lógica e o processador no mesmo diagrama, cada um navegável.

Vários processadores no mesmo projeto seguem a mesma receita: crie cada um no Hub, compile cada um, e instancie todos no seu top-level. Um estudo de caso completo com dois processadores sincronizados está em {doc}`../avancado/interrupcao-multiproc`.

Falta só um passo para o hardware de verdade: {doc}`fpga`.
