# Diretivas do C±

## De configuração

Vivem no topo do arquivo, uma por linha, e definem o hardware gerado.

| Diretiva | Padrão | Define |
|---|---|---|
| `#NUBITS n` | 32 | largura da palavra, em bits |
| `#NBMANT n` | 23 | bits de mantissa do ponto flutuante |
| `#NBEXPO n` | 8 | bits de expoente do ponto flutuante |
| `#NDSTAC n` | calculado | profundidade da pilha de dados (expressões); sem a diretiva, o compilador usa o pico do programa mais 1, no mínimo 2 |
| `#SDEPTH n` | calculado | profundidade da pilha de chamadas, calculada do mesmo jeito |
| `#NUIOIN n` | 1 | portas de entrada |
| `#NUIOOU n` | 1 | portas de saída |
| `#NUGAIN n` | 128 | divisor fixo da função `norm()`; tem de ser potência de dois, e é isso que deixa a divisão virar deslocamento. Outro valor é recusado |
| `#FFTSIZ n` | 3 | quantos bits do índice o acesso bit-reverso `x[i)` inverte |

Não existe `#PRNAME`: o nome do processador é o nome do arquivo fonte ({file}`filtro.cmm` gera o processador e o módulo `filtro`), e a diretiva, se aparecer, é erro de compilação.

Regra estrutural, verificada na compilação: `NUBITS = NBMANT + NBEXPO + 1`.

Os padrões acima são os do compilador, aplicados quando a diretiva é omitida. Faltar uma diretiva não dá erro: o processador nasce com o padrão, que pode não ser o que você quer. Por isso o Hub de Processadores escreve sempre `#NUBITS`, `#NBMANT`, `#NBEXPO`, `#NUIOIN` e `#NUIOOU`; as pilhas e o `#NUGAIN` só quando há outro valor.

## De comportamento

Aparecem no corpo de uma função, como comandos, no máximo uma de cada por programa; o lugar usual é o `main()`.

| Diretiva | Cria o pino | Faz |
|---|---|---|
| `#PRACA` | `itr` | marca o ponto de atendimento de interrupção; com `itr` em 1, a execução salta para lá |
| `#TOAQUI` | `cheguei` | o pino sobe quando a execução passa pelo ponto marcado |

Detalhes de uso em {doc}`../avancado/interrupcao-multiproc`.

## Constantes

```cmm
#define NOME valor
```

Substituição textual simples, sem argumentos. Não existem `#include`, `#ifdef` nem macros com parâmetros.
