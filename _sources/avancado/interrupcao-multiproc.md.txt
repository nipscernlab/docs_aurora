# Interrupção, marcador de fim e multiprocessador

Três recursos que aparecem quando o processador deixa de ser um exercício e vira parte de um sistema.

## Interrupção: `#PRACA`

A diretiva `#PRACA`, colocada como um comando dentro de `main()`, marca o endereço de atendimento de interrupção e cria o pino `itr` no processador. Enquanto `itr` estiver em 1, o contador de programa salta para o ponto marcado; quando volta a 0, o programa retoma de onde estava.

```{code-block} cmm
:caption: esqueleto com atendimento de interrupcao

void main()
{
    int amostra;

    while (1)
    {
        // laco principal
        amostra = in(0);
        out(0, amostra);

        #PRACA               // daqui em diante, o atendimento
        out(1, 1);           // sinaliza o evento na porta 1
    }
}
```

Só pode haver um `#PRACA` por programa. O uso típico: um periférico externo (o seu Verilog da Parte IV) levanta `itr` quando precisa de atenção, e o processador responde sem varrer a porta o tempo todo.

## Marcador de fim: `#TOAQUI`

A diretiva `#TOAQUI` marca um endereço e cria o pino `cheguei`, que sobe quando o contador de programa passa por ali. É o mecanismo que o botão {guilabel}`Teste do processador sintetizado` usa para saber que o programa terminou: a AURORA injeta um `#TOAQUI` no final do `main()` automaticamente nesse fluxo.

Em um sistema seu, o pino serve de sincronização barata: "o processador chegou na fase tal". Também só pode haver um por programa.

## Multiprocessador

Vários processadores SAPHO convivem no mesmo projeto e no mesmo circuito. A receita é a da Parte IV, repetida:

1. Crie cada processador no Hub, cada um com seu nome e seus parâmetros. Cada um vive na sua pasta, com seu {file}`.cmm`.
2. Compile cada um com {guilabel}`Compilar C±`. Ao usar os botões de síntese e simulação, a AURORA recompila todos os processadores do projeto antes, sozinha.
3. Escreva um top-level Verilog que instancia todos e a lógica de interconexão: quem alimenta quem, quem sincroniza quem.
4. O testbench do conjunto é seu. O testbench gerado automaticamente dirige um processador isolado; um sistema com dois ou mais pede um testbench que conheça a interconexão.

O padrão de interconexão mais comum é o produtor e consumidor: a porta de saída de um processador alimenta a porta de entrada do outro, com o aperto de mão `out_en` e `req_in` fazendo a sincronização, possivelmente com uma FIFO entre eles quando os ritmos diferem.

### O top level como sistema

Vale insistir num ponto que muda a forma de pensar o projeto: o Top Level não precisa ser um processador. Ele é o módulo raiz do circuito, e um processador SAPHO gerado pelo YANC é apenas mais um módulo Verilog, com portas de entrada e de saída como qualquer outro. Nada impede que o seu top level instancie três, cinco, dez deles.

A partir daí o encadeamento é livre, e é o que abre a porta para arquiteturas de verdade:

- **Cascata**: a saída de um alimenta a entrada do seguinte, cada estágio fazendo uma parte do processamento. Um filtra, o próximo transforma, o último decide.
- **Paralelo com divisão de dados**: o mesmo programa replicado em vários processadores, cada um cuidando de um canal, com um módulo Verilog distribuindo as amostras e outro juntando os resultados.
- **Realimentação**: a saída de um estágio posterior volta como entrada de um anterior, que é como se escreve um controle em malha fechada ou um algoritmo iterativo, com o próprio circuito repetindo o ciclo até convergir.
- **Hierarquia**: um processador coordenador lê resultados dos outros e decide o que fazer, funcionando como supervisor de um conjunto de processadores especializados.

Cada processador continua sendo do tamanho do seu próprio programa, então um sistema de cinco processadores pequenos pode custar menos área que um único processador genérico que fizesse tudo. Como o circuito inteiro nasce do mesmo projeto, a simulação também é uma só: você vê todos eles na mesma onda, cada um com suas trilhas.

```{mermaid}
flowchart LR
  IN["entrada<br>do sistema"] --> A
  subgraph TOP["top level, em Verilog"]
    direction LR
    A["proc_filtro<br><i>SAPHO</i>"] --> B["proc_fft<br><i>SAPHO</i>"]
    B --> C["proc_decisao<br><i>SAPHO</i>"]
    C -->|realimentação| A
    FSM["máquina de estados<br>coordena e sincroniza"] -.-> A
    FSM -.-> B
    FSM -.-> C
  end
  C --> OUT["saída<br>do sistema"]
```

:::{admonition} Estudo de caso: DTW com dois processadores
:class: note

O repositório do YANC traz um sistema completo de detecção de novidade em sinais de 60 Hz usando dois processadores: um `ZeroCross`, que detecta cruzamentos de zero e segmenta o sinal, e um `ProcDTW`, que calcula a distância DTW contra um padrão. Uma máquina de estados em Verilog puro coordena os dois, e o conjunto foi validado em FPGA real.

Os fontes estão em {file}`Compilers/CMMComp/Tests/DTW` do repositório do YANC: os dois {file}`.cmm`, o top-level, a máquina de estados e o testbench do sistema. É o melhor material de estudo para o padrão multiprocessador.
:::

O padrão multiprocessador tem literatura própria do laboratório: a [arquitetura multi-core para reconstrução online de energia (CBA, 2020)](https://cdn.nipscern.com/publications/cba-2020-arquitetura-multi-core.pdf) e o [simulador de pulsos do TileCal com SAPHO (SBAI, 2025)](https://cdn.nipscern.com/publications/sbai-2025-simulador-de-pulsos-do-tilecal.pdf), este rodando na eletrônica do experimento ATLAS.

Na onda, cada processador aparece com seu grupo de sinais e suas próprias trilhas de assembly e de linha C±, então dá para acompanhar os dois programas executando em paralelo, ciclo a ciclo.
