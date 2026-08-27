# FFT em hardware

A FFT é o algoritmo que junta tudo o que a Parte V apresentou: números complexos, ponto flutuante dimensionado e um recurso que só o SAPHO tem na linguagem: o índice bit-reverso.

## O problema do embaralhamento

A FFT radix-2 com decimação no tempo consome as amostras em ordem bit-reversa: para 8 pontos, a posição binária `001` vira `100`, então `x[1]` é lido como `x[4]`, e assim por diante. Em software comum, isso custa uma rotina de embaralhamento antes da transformada.

No SAPHO, o embaralhamento custa zero: a linguagem tem um modo de indexação que inverte os bits do índice no próprio hardware de endereçamento.

```cmm
data[j]     // acesso normal
data[j)     // acesso com os bits de j invertidos
```

O parêntese no lugar do colchete final é a sintaxe. Quantos bits são invertidos é definido pela diretiva `#FFTSIZ`: para uma FFT de 8 pontos, `#FFTSIZ 3`.

## O programa

Crie um processador `proc_fft` (32 bits, mantissa 23, expoente 8) e escreva a FFT de 8 pontos:

```{code-block} cmm
:caption: proc_fft.cmm, FFT radix-2 de 8 pontos
:linenos:

#PRNAME proc_fft
#NUBITS 32
#NBMANT 23
#NBEXPO 8
#NDSTAC 8
#SDEPTH 2
#NUIOIN 1
#NUIOOU 1
#FFTSIZ 3

#define N  8
#define NL 3            // log2(N)

void main()
{
    comp  data[N];
    comp  tw, t, u;
    int   n, j, k, par, salto;
    float ang;

    while (1)
    {
        // carrega as amostras ja em ordem bit-reversa:
        // data[n) grava na posicao com os bits de n invertidos
        for (n = 0; n < N; n++)
        {
            data[n) = complex(fin(0), 0.0);
        }

        // as tres etapas de borboletas
        salto = 1;
        for (k = 0; k < NL; k++)
        {
            for (par = 0; par < N; par = par + 2 * salto)
            {
                for (j = 0; j < salto; j++)
                {
                    ang = -3.14159265 * j / salto;
                    tw  = exp(complex(0.0, ang));

                    u = data[par + j];
                    t = tw * data[par + j + salto];

                    data[par + j]         = u + t;
                    data[par + j + salto] = u - t;
                }
            }
            salto = salto * 2;
        }

        // publica o espectro: modulo de cada raia
        for (n = 0; n < N; n++)
        {
            fout(0, abs(data[n]));
        }
    }
}
```

Os pontos de atenção:

- A linha 27 é o truque inteiro: `data[n)` grava a amostra `n` já na posição embaralhada. Nenhuma rotina de reordenação, nenhum ciclo gasto.
- O índice de amostra se chama `n`, e não `i`, porque `i` é reservado no C± e usá-lo como variável é erro de compilação ({doc}`../sapho/linguagem`).
- O twiddle `tw` sai de `exp` complexo, que o compilador implementa por rotina. Uma versão otimizada usaria uma tabela pré-calculada em arquivo (`comp tw[4] "twiddles.txt"` não existe para `comp`; use dois vetores `float` com as partes real e imaginária), bom exercício para a turma.
- `abs` de complexo devolve o módulo, direto para a saída.

```{figure} ../_static/assets/screenshots/aurora-fft-editor.png
:alt: Editor com o codigo da FFT mostrando o indice bit-reverso e a diretiva FFTSIZ.
:width: 90%
:align: center
```

## Verificando

Alimente {file}`input_0.txt` com 8 amostras de uma senoide que caiba em um período da janela e simule. No espectro de saída, duas raias simétricas devem se destacar. Compare com o `numpy.fft.fft` das mesmas amostras: os módulos devem bater dentro do erro do formato de ponto flutuante escolhido, o que fecha o laço com o capítulo de {doc}`ponto flutuante <ponto-flutuante>`.

Para tamanhos maiores, ajuste `N`, `NL` e `#FFTSIZ` juntos, e acompanhe no TASM o crescimento do programa.

:::{seealso}
O índice bit-reverso nasceu de um projeto de processador dedicado à FFT: [Projeto de um Processador Embarcado Otimizado para Aplicação com Transformada de Fourier (2016)](https://cdn.nipscern.com/publications/tcc-2016-leandro-silva.pdf).
:::
