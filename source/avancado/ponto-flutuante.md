# Ponto flutuante customizado

:::{admonition} Estudos avançados
:class: important
A Parte V pressupõe os tutoriais das Partes II e III. O conteúdo daqui em diante é voltado à pós-graduação.
:::

No SAPHO, o formato de ponto flutuante é um parâmetro de projeto. Em vez de aceitar o IEEE 754 de 32 bits, você escolhe quantos bits de mantissa e de expoente o seu problema pede, e o hardware é gerado exatamente nesse tamanho. Menos bits, menos células, mais frequência; a troca é precisão.

## O formato

Uma palavra `float` de `NUBITS` bits se divide em três campos:

```text
[ sinal: 1 ][ expoente: NBEXPO ][ mantissa: NBMANT ]
```

com o valor dado por $(-1)^{sinal} \times mantissa \times 2^{expoente}$. As diferenças para o IEEE 754, todas deliberadas, todas baratas em hardware:

| | SAPHO | IEEE 754 |
|---|---|---|
| Mantissa | inteiro sem bit implícito | fração com 1 implícito |
| Expoente | complemento de dois, sem viés | com viés |
| Sinal | sinal e magnitude | sinal e magnitude |
| NaN, infinitos, subnormais | não existem | existem |

A regra estrutural que o Hub impõe vem daqui: `NUBITS = NBMANT + NBEXPO + 1`, um bit para cada campo, sem sobra.

## Faixa e precisão

- Maior magnitude: $(2^{NBMANT} - 1) \cdot 2^{2^{NBEXPO-1}-1}$
- Menor magnitude não nula: $2^{-2^{NBEXPO-1}}$
- Precisão relativa: cerca de $NBMANT \cdot \log_{10} 2$ dígitos decimais

Configurações de referência:

| NUBITS | NBMANT | NBEXPO | Comparável a |
|---|---|---|---|
| 16 | 10 | 5 | meia precisão |
| 23 | 16 | 6 | o padrão do Hub |
| 32 | 23 | 8 | precisão simples IEEE em bits |

## Dimensionando para o seu problema

O procedimento honesto é experimental:

1. Estime a faixa dinâmica do sinal (o expoente cuida dela) e a precisão exigida (a mantissa cuida dela).
2. Gere o processador com a configuração candidata.
3. Compile: toda constante que não cabe exatamente no formato gera um aviso com o erro de representação. Leia esses avisos; eles são o primeiro veredito.
4. Simule e compare as saídas com um modelo de referência (um script Python com o mesmo algoritmo em dupla precisão, por exemplo).

## Vendo o erro de arredondamento na onda

Na simulação com Icarus, o processador expõe dois sinais didáticos: `delta_float` e `delta_int`, o erro de arredondamento cometido em cada operação da ULA, calculado contra o valor exato. Adicione-os na configuração de ondas e observe o erro se acumulando ao longo de um laço: é a aula de análise numérica acontecendo no seu próprio circuito.

```{figure} ../_static/assets/screenshots/aurora-onda-delta-float.png
:alt: Forma de onda com o sinal delta_float mostrando o erro por operação.
:width: 100%
:align: center
```

```{figure} ../_static/assets/screenshots/aurora-hub-ponto-flutuante.png
:alt: Hub de Processadores com o formato numérico em destaque.
:width: 80%
:align: center

Os três campos que definem o formato ficam juntos no Hub. Aqui está a configuração padrão, 23 bits com mantissa 16 e expoente 6; para comparar formatos, gere dois processadores iguais mudando apenas mantissa e expoente, rode o mesmo estímulo e compare os `output_N.txt`.
```

## O custo em hardware

As operações de soma, multiplicação e divisão em ponto flutuante têm blocos dedicados na ULA, instanciados apenas se o programa as usa. Algumas funções matemáticas também: `sqrt` usa um bloco de rotação, e `exp` e `log` usam blocos de escala por potência de dois e de extração de expoente, todos condicionados ao mesmo `generate if` das demais operações. As trigonométricas (`sin`, `cos`, `tan`, `atan`) são rotinas de software, avaliadas por polinômios sobre as operações básicas: o custo delas é tempo de execução, não área. O relatório do TASM mostra as duas coisas: os recursos da ULA instanciados e o tamanho do programa.
