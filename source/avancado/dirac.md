# Notação de Dirac: álgebra linear em hardware

O recurso mais singular do C±: vetores e matrizes se operam com a notação bra-ket da física, e cada expressão vira código totalmente desenrolado, sem laços. Um produto interno de 4 elementos gera cerca de dez instruções em linha reta; as dimensões precisam ser constantes conhecidas na compilação, e é exatamente isso que permite o desenrolamento.

## Os símbolos, e como digitá-los

Antes das formas, o obstáculo prático: dois dos símbolos não estão no teclado. O compilador reconhece exatamente estes quatro, e nenhuma variação deles.

| Símbolo | Nome | Código Unicode | O que é |
|---|---|---|---|
| `⟩` | *ket*, fecha | U+27E9 | Fecha um vetor coluna, como em `\|b⟩` |
| `⟨` | *bra*, abre | U+27E8 | Abre um vetor linha, como em `⟨b\|` |
| `\|0⟩` | vetor nulo | usa o U+27E9 | Zera o vetor inteiro |
| `\|I\|` | identidade | só ASCII | Matriz identidade, esta se digita normalmente |

O ponto que causa mais perda de tempo: `⟨` e `⟩` **não são** os sinais de menor e maior do teclado. São caracteres diferentes, com códigos diferentes. Escrever `a # |M|b>;` não compila, e a mensagem de erro fala de sintaxe, sem dizer que o problema é o caractere. Os sinais `<` e `>` continuam sendo comparação em C±, e é por isso que o compilador não pode aceitá-los nos dois papéis.

### Na AURORA: o editor completa

Não é preciso caçar o caractere. No editor, dentro de um arquivo `.cmm`, digite o nome da operação e aceite a sugestão:

| Digite | E aceite para escrever |
|---|---|
| `ket` | `\|v⟩` com o cursor sobre o nome do vetor |
| `bra` | `⟨v\|` |
| `braket` | `⟨a\|b⟩`, o produto interno |
| `dirac` | a lista inteira: as quatro operações, a identidade, o vetor nulo e a leitura de porta |
| `>>` ou `<<` | o caractere `⟩` ou `⟨` sozinho, para inserir no meio de algo já escrito |

```{figure} ../_static/assets/screenshots/aurora-dirac-autocompletar.png
:alt: Lista de autocompletar da AURORA num arquivo .cmm, mostrando as sugestoes da notacao de Dirac.
:width: 90%
:align: center

Digitar `ket` num `.cmm` traz as formas da notação; aceitar a sugestão insere o caractere correto.
```

A lista sai da mesma tabela de símbolos que o compilador usa, extraída do yanc, então ela não pode ensinar um símbolo que o compilador não aceite.

### Fora da AURORA

Em qualquer outro editor, três caminhos:

- copiar de um exemplo que já use a notação, que é o mais rápido;
- no Windows, o Mapa de Caracteres (`charmap`), procurando pelo código U+27E8 ou U+27E9;
- em editores que aceitam entrada Unicode, digitar o código e converter (no Word e no LibreOffice, `27E9` seguido de `Alt+X`).

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


## Quando usar

Dirac compensa quando o algoritmo é álgebra linear de dimensão pequena e fixa: filtros adaptativos, projeções, transformações de coordenadas, redes pequenas. Para dimensões grandes, o desenrolamento explode o número de instruções; o compilador avisa o tamanho gerado, e o relatório do TASM mostra o total. A alternativa nesses casos é escrever os laços em C± comum.
