# Diretivas do C±

## De configuração

Vivem no topo do arquivo, uma por linha, e definem o hardware gerado.

| Diretiva | Padrão | Define |
|---|---|---|
| `#PRNAME nome` | obrigatória | nome do processador e do módulo Verilog |
| `#NUBITS n` | 23 | largura da palavra, em bits |
| `#NBMANT n` | 16 | bits de mantissa do ponto flutuante |
| `#NBEXPO n` | 6 | bits de expoente do ponto flutuante |
| `#NDSTAC n` | 10 | profundidade da pilha de dados (expressões) |
| `#SDEPTH n` | 10 | profundidade da pilha de chamadas |
| `#NUIOIN n` | 1 | portas de entrada |
| `#NUIOOU n` | 1 | portas de saída |
| `#NUGAIN n` | 64 | divisor fixo da função `norm()`; potência de dois |
| `#FFTSIZ n` | 8 | quantos bits do índice o acesso bit-reverso `x[i)` inverte |

Regra estrutural, verificada na compilação: `NUBITS = NBMANT + NBEXPO + 1`.

Os padrões acima são os do compilador, aplicados quando a diretiva é omitida. O Hub de Processadores escreve as nove primeiras explicitamente no arquivo que gera.

## De comportamento

Aparecem dentro de `main()`, como comandos, no máximo uma de cada por programa.

| Diretiva | Cria o pino | Faz |
|---|---|---|
| `#PRACA` | `itr` | marca o ponto de atendimento de interrupção; com `itr` em 1, a execução salta para lá |
| `#TOAQUI` | `cheguei` | o pino sobe quando a execução passa pelo ponto marcado |

Detalhes de uso em {doc}`../avancado/interrupcao-multiproc`.

## Constantes

```c
#define NOME valor
```

Substituição textual simples, sem argumentos. Não existem `#include`, `#ifdef` nem macros com parâmetros.
