# Levar ao FPGA

A AURORA valida, simula e desenha. A síntese física, com mapeamento em células, posicionamento, roteamento e bitstream, acontece na ferramenta do fabricante: Quartus para Intel/Altera, Vivado para AMD/Xilinx. Este capítulo lista o que levar e os cuidados do caminho.

## O que levar

Para um projeto com processador:

1. Os seus fontes Verilog (top-level e módulos próprios).
2. O processador gerado: {file}`Hardware/<proc>.v`.
3. As imagens de memória: {file}`Hardware/<proc>_inst.mif` e {file}`<proc>_data.mif`.
4. A biblioteca de módulos do SAPHO, que o {file}`<proc>.v` instancia. Ela acompanha a instalação da AURORA, na pasta {file}`components/HDL` dentro da pasta de instalação: {file}`processor.v`, {file}`core.v`, {file}`ula.v`, {file}`instr_dec.v`, {file}`addr_dec.v`.

Copie tudo para o projeto da ferramenta de síntese e adicione os arquivos ao projeto dela.

:::{warning}
As memórias são carregadas por `$readmemb` com o caminho dos {file}`.mif`. Ao mover os arquivos, confira se o caminho gravado no {file}`<proc>.v` continua resolvendo, ou ajuste-o para o layout do projeto de síntese. Um caminho quebrado sintetiza memória vazia, e o processador executa nada.
:::

## Passos típicos

1. Crie o projeto na ferramenta, aponte o dispositivo FPGA da sua placa.
2. Adicione os fontes e defina o seu top-level como entidade de topo.
3. Associe os pinos físicos: clock da placa em `clk`, botão em `rst`, e os sinais de dado nos periféricos que o seu top-level expõe.
4. Restrinja o clock (arquivo de constraints com o período) para a análise de tempo valer.
5. Sintetize, grave, teste.

## Conferências que evitam sofrimento

- **Simule antes.** O comportamento visto na onda da AURORA é o contrato; a síntese não conserta algoritmo.
- **Reset**: o processador usa reset síncrono. Um botão da placa costuma precisar de sincronização antes de entrar no circuito.
- **Frequência**: a análise de tempo da ferramenta dirá a frequência máxima do conjunto. Se o relatório reprovar o seu clock, reduza a frequência da placa ou revise o caminho crítico.
- **Tamanho**: o relatório de utilização mostra o custo real de cada escolha do C±. É o fechamento do experimento do PRISM, agora em números de células.

## O que a AURORA não faz

Não gera bitstream, não faz place and route, não escreve constraints. O Yosys embutido serve à visualização e à hierarquia, nunca à síntese física. Essa fronteira é de projeto: a plataforma termina onde a ferramenta do fabricante, que conhece o silício, começa.
