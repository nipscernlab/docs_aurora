# Tutorial: um contador em Verilog

Este é o primeiro tutorial do manual. Ao final, você terá criado um projeto, escrito um módulo Verilog e um testbench, validado o design, simulado e lido o resultado na forma de onda. Reserve uns vinte minutos.

:::{admonition} O que vamos construir
:class: tip

Um contador de 4 bits com habilitação: conta a cada borda de clock enquanto `habilita` estiver em 1, e zera no reset. É o circuito sequencial mais simples que exercita o fluxo inteiro: clock, reset, registrador e testbench.
:::

## Passo 1: criar o projeto

1. Clique em {guilabel}`Novo Projeto`, na barra superior ou na tela de boas-vindas.
2. Nomeie `LabContador`. O nome aceita letras, números, sublinhado e hífen; sem espaços nem acentos.
3. Clique em {guilabel}`Procurar`, escolha uma pasta com permissão de escrita e clique em {guilabel}`Gerar Projeto`.

```{figure} ../_static/assets/screenshots/aurora-novo-projeto.png
:alt: Modal Novo Projeto preenchido.
:width: 80%
:align: center
:name: fig-novo-projeto

O formulário pede só nome e local. O campo de local é preenchido pelo botão Procurar.
```

**Confira:** a árvore mostra `LabContador`, vazio, e a barra de status passou a {guilabel}`Pronto`.

## Passo 2: escrever o módulo

1. Na árvore, clique com o botão direito na área vazia e escolha {guilabel}`Novo arquivo`.
2. Nomeie {file}`contador.v` e salve dentro da pasta do projeto.
3. Digite o módulo:

```{code-block} verilog
:caption: contador.v
:linenos:

module contador (
    input  wire       clk,
    input  wire       rst,
    input  wire       habilita,
    output reg  [3:0] conta
);

    always @(posedge clk) begin
        if (rst)
            conta <= 4'd0;
        else if (habilita)
            conta <= conta + 4'd1;
    end

endmodule
```

Salve com {kbd}`Ctrl+S`.

```{figure} ../_static/assets/screenshots/aurora-verilog-editor.png
:alt: Editor com o contador em Verilog e diagnósticos ao vivo.
:width: 90%
:align: center

Enquanto você digita, dois analisadores conferem o código: erros de sintaxe aparecem sublinhados na hora, e a análise semântica aponta sinais não declarados e portas incompatíveis.
```

**Confira:** na visão Arquivos, {file}`contador.v` apareceu com o ícone de fonte sintetizável. A AURORA o classificou sozinha, lendo o conteúdo: sem `initial`, sem `$finish`, é circuito.

## Passo 3: escrever o testbench

Crie um segundo arquivo, {file}`tb_contador.v`:

```{code-block} verilog
:caption: tb_contador.v
:linenos:

`timescale 1ns/1ps

module tb_contador;

    reg        clk = 0;
    reg        rst = 1;
    reg        habilita = 0;
    wire [3:0] conta;

    contador dut (
        .clk      (clk),
        .rst      (rst),
        .habilita (habilita),
        .conta    (conta)
    );

    always #5 clk = ~clk;      // clock de 100 MHz

    initial begin
        $dumpfile("tb_contador.fst");
        $dumpvars(0, tb_contador);

        #12 rst = 0;           // solta o reset fora da borda
        #8  habilita = 1;      // conta por 20 ciclos
        #200 habilita = 0;     // congela
        #40 $finish;
    end

endmodule
```

Repare nos ingredientes que todo testbench tem: o clock gerado por `always #5`, o reset solto depois de alguns nanossegundos, o `$dumpvars` que grava os sinais para a forma de onda e o `$finish` que encerra a simulação.

**Confira:** o arquivo entrou na árvore com o ícone de testbench. `initial`, `$finish` e o nome começando com `tb_` denunciaram a categoria.

## Passo 4: definir os papéis

Um projeto pode ter dezenas de arquivos, e a AURORA precisa saber dois deles pelo nome: qual é o circuito e qual é o teste.

Top Level
: O módulo que está no alto da hierarquia, a raiz do seu projeto. É dele que a elaboração parte, e tudo o que ele instancia, direta ou indiretamente, faz parte do design. O que não for alcançável a partir do Top Level não participa: fica no projeto, mas fora do circuito. É também o módulo que você levaria à ferramenta do fabricante para gravar no FPGA, e o que o PRISM desenha quando abre. Aqui é o {file}`contador.v`, porque o contador é o circuito.

Testbench Top
: O módulo que comanda a simulação, o que gera clock, reset e estímulos. Ele instancia o Top Level como um componente e o observa de fora. Não vai para o FPGA: existe só para exercitar o circuito na bancada. Aqui é o {file}`tb_contador.v`.

Marque cada um:

1. Botão direito em {file}`contador.v`, escolha {guilabel}`Definir como Top Level`.
2. Botão direito em {file}`tb_contador.v`, escolha {guilabel}`Marcar como Testbench`.

Os dois papéis são exclusivos: marcar um arquivo novo desmarca o anterior. Se um dia a compilação reclamar de módulo não encontrado, ou a onda vier vazia, o primeiro lugar a conferir é este par.

**Confira:** a barra de status agora mostra os dois nomes, e os botões {guilabel}`Sintetizar Verilog` e {guilabel}`Analisar Verilog` acenderam.

## Passo 5: validar

Clique em {guilabel}`Sintetizar Verilog`.

A AURORA elabora o projeto inteiro a partir do Top Level: resolve os módulos, confere portas e conexões, e monta a hierarquia de instâncias. Não é a síntese física do FPGA; é a prova de que o design fecha.

```{figure} ../_static/assets/screenshots/aurora-verilog-validacao.png
:alt: Terminal TVERI com a validação bem-sucedida e a visão Hierarquia habilitada.
:width: 90%
:align: center

O terminal TVERI relata a validação. Depois dela, o botão de visões da árvore ganha a opção Hierarquia.
```

**Confira:** alterne a árvore para a visão {guilabel}`Hierarquia`. Deve aparecer a instância do contador. Clicar nela abre o fonte na linha da definição.

## Passo 6: simular e ler a onda

1. Confirme na barra de ferramentas: simulador **Icarus Verilog**, visualizador **GTKWave**.
2. Clique em {guilabel}`Analisar Verilog`.

A AURORA compila os fontes com o testbench, roda a simulação e abre o GTKWave com os sinais já organizados. Acompanhe o terminal TWAVE.

```{figure} ../_static/assets/screenshots/aurora-gtkwave-contador.png
:alt: GTKWave com clock, reset, habilita e a contagem subindo.
:width: 100%
:align: center
:name: fig-onda-contador

A forma de onda do contador: o reset solta, habilita sobe e `conta` incrementa a cada borda de clock, de 0 a 15 e de volta a 0.
```

Procure na onda:

- `rst` alto no início e a contagem presa em 0;
- `conta` subindo um a um a cada borda de subida do clock enquanto `habilita` está em 1;
- o estouro: depois de 15, o contador de 4 bits volta a 0;
- a contagem congelada quando `habilita` cai.

## O que você aprendeu

- [x] Um projeto é uma pasta com um {file}`.spf`; os fontes entram por criação ou arraste.
- [x] A AURORA separa circuito de testbench sozinha, pelo conteúdo do arquivo.
- [x] Top Level e Testbench Top são os dois papéis que você marca, e a barra de status os exibe sempre.
- [x] Sintetizar valida a elaboração e constrói a hierarquia; Analisar simula e abre a onda.
- [x] O testbench manda na simulação: clock, reset, estímulos, `$dumpvars` e `$finish` são seus.

## Um segundo padrão: máquina de estados

O contador é o primeiro padrão sequencial; o segundo é a máquina de estados finitos, e vale construí-la já. Um semáforo simples: verde, amarelo, vermelho, cada um com sua duração.

Crie {file}`semaforo.v` no mesmo projeto:

```{code-block} verilog
:caption: semaforo.v
:linenos:

module semaforo (
    input  wire       clk,
    input  wire       rst,
    output reg  [2:0] luz        // {verde, amarelo, vermelho}
);

    localparam VERDE    = 2'd0;
    localparam AMARELO  = 2'd1;
    localparam VERMELHO = 2'd2;

    localparam T_VERDE    = 4'd8;
    localparam T_AMARELO  = 4'd2;
    localparam T_VERMELHO = 4'd6;

    reg [1:0] estado;
    reg [3:0] tempo;

    always @(posedge clk) begin
        if (rst) begin
            estado <= VERDE;
            tempo  <= 4'd0;
        end else begin
            tempo <= tempo + 4'd1;
            case (estado)
                VERDE:    if (tempo == T_VERDE    - 1) begin estado <= AMARELO;  tempo <= 0; end
                AMARELO:  if (tempo == T_AMARELO  - 1) begin estado <= VERMELHO; tempo <= 0; end
                VERMELHO: if (tempo == T_VERMELHO - 1) begin estado <= VERDE;    tempo <= 0; end
                default:  estado <= VERDE;
            endcase
        end
    end

    always @(*) begin
        case (estado)
            VERDE:    luz = 3'b100;
            AMARELO:  luz = 3'b010;
            default:  luz = 3'b001;
        endcase
    end

endmodule
```

O padrão em três blocos: os estados nomeados com `localparam`, um `always` sequencial com o registrador de estado e o temporizador, e um `always` combinacional com a saída em função do estado. Escreva um testbench nos moldes do anterior (solte o reset e deixe rodar uns 200 ciclos), marque os papéis e observe na onda o ciclo verde, amarelo, vermelho se repetindo. A visão {guilabel}`Hierarquia` agora mostra dois módulos de topo possíveis; o Top Level marca qual vale.

## Exercícios

1. Faça o contador contar de 0 a 9 e reiniciar, virando um contador de década.
2. Acrescente um pino `sobe_desce` ao contador: 1 conta para cima, 0 para baixo. Confirme na onda os dois sentidos.
3. Dê ao contador uma saída `estouro`, em 1 apenas no ciclo em que a contagem volta a zero. Grave-a na onda.
4. No semáforo, acrescente um pino de pedestre que, pressionado durante o verde, encurta o tempo restante para no máximo 2 ciclos. Cuidado com o caso do tempo já estar abaixo disso.

## Para onde ir

As formas de onda em detalhe estão em {doc}`ondas`, o fluxo em {doc}`fluxo` e os testbenches, incluindo cocotb, em {doc}`testbenches`. Quando quiser gerar um processador em vez de escrever o circuito à mão, siga para a Parte III: {doc}`../sapho/tutorial-filtro`.
