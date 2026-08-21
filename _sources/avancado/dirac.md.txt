# Notação de Dirac: álgebra linear em hardware

O recurso mais singular do C±: vetores e matrizes se operam com a notação bra-ket da física, e cada expressão vira código totalmente desenrolado, sem laços. Um produto interno de 4 elementos gera cerca de dez instruções em linha reta; as dimensões precisam ser constantes conhecidas na compilação, e é exatamente isso que permite o desenrolamento.

## As formas suportadas

Com vetores `a`, `b`, `d`, matrizes `A`, `B`, `M`, `P` e escalares `c`, `g`, `e`:

| Escrita | Calcula |
|---|---|
| `e = d - ⟨w\|x⟩;` | produto interno $\langle w \mid x \rangle$ dentro de expressão |
| `a # \|M\|b⟩;` | $a = M b$ (matriz vezes vetor) |
| `a # c\|b⟩;` | $a = c\,b$ (escalar vezes vetor) |
| `a # \|b⟩ + c\|d⟩;` | $a = b + c\,d$ (soma ponderada) |
| `A # \|a⟩⟨b\|;` | $A = a\,b^{T}$ (produto externo) |
| `A # \|B\| - \|a⟩⟨b\|;` | $A = B - a\,b^{T}$ |
| `A # c\|B\|;` | $A = c\,B$ |
| `A # c\|I\|;` | $A = c\,I$ (identidade escalada) |
| `a # \|0⟩;` | zera o vetor |
| `a # c\|in(p)⟩;` | preenche `a` lendo a porta `p`, cada leitura vezes `c` |
| `a # c -> \|a⟩;` | registrador de deslocamento: desloca `a` e insere `c` |
| `out(p, c\|a⟩);` | escreve o vetor inteiro na porta, cada elemento vezes `c` |

O `#` marca a atribuição vetorial. As declarações também aceitam inicialização por Dirac: `float Px[4] # |P|x⟩;`.

Regras verificadas na compilação: dimensões compatíveis, tipos iguais dos dois lados (`int` com `int`, `float` com `float`), e nada de `comp`. O registrador de deslocamento exige o mesmo vetor dos dois lados.

## Tutorial: um filtro RLS em 66 linhas

O filtro adaptativo RLS (*Recursive Least Squares*) é o caso de uso perfeito: seu miolo é puro produto de matriz e vetor, e em C com laços ele viraria uma página de índices. Em Dirac, cada linha do algoritmo matemático vira uma linha de código.

Crie um processador `proc_rls` (32 bits, mantissa 23, expoente 8, uma porta de entrada e uma de saída, pilha de dados 8) e use o programa:

```{code-block} cmm
:caption: proc_rls.cmm, o nucleo do algoritmo
:linenos:

#PRNAME proc_rls
#NUBITS 32
#NBMANT 23
#NBEXPO 8
#NDSTAC 8
#SDEPTH 2
#NUIOIN 1
#NUIOOU 1

#define N 4          // ordem do filtro

void main()
{
    float x[N];      // entradas recentes
    float w[N];      // coeficientes do filtro
    float P[N][N];   // matriz de covariancia inversa
    float Px[N];
    float K[N];
    float d, y, e, g;

    P # 1000.0|I|;               // P = 1000 * identidade
    w # |0⟩;                     // coeficientes zerados

    while (1)
    {
        x # fin(0) -> |x⟩;       // desloca x e insere a amostra nova
        d = fin(0);              // sinal desejado

        y = ⟨w|x⟩;               // saida do filtro
        e = d - y;               // erro

        Px # |P|x⟩;              // P x
        g = 1.0 / (1.0 + ⟨x|Px⟩);
        K # g|Px⟩;               // ganho de Kalman

        w # |w⟩ + e|K⟩;          // atualiza os coeficientes
        P # |P| - |K⟩⟨Px|;       // atualiza a covariancia
        P # 1.0101|P|;           // fator de esquecimento

        fout(0, y);
    }
}
```

Leia o miolo do `while` ao lado das equações do RLS em qualquer livro de filtragem adaptativa: é uma transcrição. Esse é o argumento do recurso.

```{figure} ../_static/assets/screenshots/aurora-rls-dirac.png
:alt: Editor com o codigo RLS em notacao de Dirac, com os brackets realcados.
:width: 90%
:align: center

O editor entende os brackets: realce e espaçamento próprios para a notação.
```

Para digitar `⟨` e `⟩`, use os caracteres U+27E8 e U+27E9 (o editor os aceita normalmente; vale montar atalhos de teclado do sistema ou copiar do próprio código de exemplo).

## Quando usar

Dirac compensa quando o algoritmo é álgebra linear de dimensão pequena e fixa: filtros adaptativos, projeções, transformações de coordenadas, redes pequenas. Para dimensões grandes, o desenrolamento explode o número de instruções; o compilador avisa o tamanho gerado, e o relatório do TASM mostra o total. A alternativa nesses casos é escrever os laços em C± comum.
