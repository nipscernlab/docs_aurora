# SAPHO & AURORA, manual de uso

<div class="hero">
<span class="version-pill">Versão documentada: 6.11.0</span>

Este manual ensina a usar o processador SAPHO e a AURORA, a interface onde ele é criado. O caminho segue a ordem de uma disciplina: primeiro projetos Verilog escritos à mão, depois a geração de processadores em C±, depois os dois juntos no mesmo circuito. A parte final reúne os estudos avançados, voltados à pós-graduação.

<div class="hero-actions">

{{ pdf_button }}

</div>
</div>

:::{note}
Versão descrita: SAPHO 6.11.0 para Windows 10 e 11. Detalhes da apuração em {doc}`sobre/escopo`.
:::

## Por onde começar

Nunca usou a plataforma? {doc}`Instale <inicio/instalacao>`, veja o {doc}`mapa da janela <inicio/mapa-da-janela>` e siga direto para o {doc}`tutorial Verilog <verilog/tutorial-contador>`. De lá, o {doc}`tutorial do processador <sapho/tutorial-filtro>` completa a base. São dois tutoriais de vinte a trinta minutos cada.

Já trabalha em um projeto? O menu lateral vai direto à tarefa, e a {doc}`referência <referencia/diretivas>` responde consultas pontuais sem repetir os tutoriais.

```{toctree}
:maxdepth: 2
:caption: Primeiros passos

inicio/o-que-e
inicio/instalacao
inicio/mapa-da-janela
```

```{toctree}
:maxdepth: 2
:caption: Verilog primeiro

verilog/tutorial-contador
verilog/ondas
verilog/fluxo
verilog/testbenches
```

```{toctree}
:maxdepth: 2
:caption: C± e o processador

sapho/tutorial-filtro
sapho/linguagem
sapho/compilacao
sapho/simulacao
sapho/prism
```

```{toctree}
:maxdepth: 2
:caption: Os dois juntos

juntos/processador-no-verilog
juntos/fpga
```

```{toctree}
:maxdepth: 2
:caption: Estudos avançados

avancado/ponto-flutuante
avancado/complexos
avancado/dirac
avancado/fft
avancado/modulos-hdl
avancado/interrupcao-multiproc
```

```{toctree}
:maxdepth: 2
:caption: A AURORA no dia a dia

diaadia/tour-interface
diaadia/organizacao-projeto
diaadia/aurora-intelligence
diaadia/apoio
```

```{toctree}
:maxdepth: 2
:caption: Referência

referencia/folha-rapida
referencia/diretivas
referencia/biblioteca
referencia/instrucoes
referencia/atalhos
referencia/diagnostico
```

```{toctree}
:maxdepth: 1
:caption: Apêndices

glossario
publicacoes
links
sobre/escopo
```
