# PRISM: o visualizador de RTL

O PRISM é o visualizador de RTL da plataforma: ele lê o Verilog do projeto e o desenha como um diagrama de circuito navegável. Responde à pergunta que a forma de onda não responde: em que estrutura o meu código virou hardware?

O desenho é sempre um retrato do Verilog atual. Quem produz a estrutura é o Yosys, elaborando os mesmos arquivos que iriam para a síntese, então qualquer mudança no código muda o diagrama: acrescente um módulo e ele aparece, troque um operador e o bloco correspondente entra ou some, renomeie um sinal e o rótulo acompanha. Nada ali é decorativo ou desenhado à mão.

## Abrir

O botão {guilabel}`Abrir PRISM` exige um Top Level definido. Ele valida o projeto como o botão Verilog faria, sintetiza a estrutura com o Yosys e abre a janela do diagrama.

```{figure} ../_static/assets/screenshots/aurora-prism-media-movel.png
:alt: Janela do PRISM com o diagrama do projeto no nível do topo.
:width: 100%
:align: center

O nível do topo. Processadores SAPHO aparecem com símbolo próprio; os demais módulos, como caixas com suas portas.
```

## Navegar

- **Clique** em um módulo entra nele: o diagrama desce um nível na hierarquia, e a trilha no topo da janela mostra o caminho. {guilabel}`Back` sobe.
- **Duplo clique** em uma célula abre o código-fonte correspondente no editor da janela principal, na linha exata.
- Zoom com a roda do mouse, arraste para mover, {guilabel}`Fit` reenquadra.
- {guilabel}`Download` salva o diagrama atual como SVG, pronto para relatório ou slide.
- {guilabel}`Recompile` refaz tudo após uma mudança no código, sem fechar a janela.

```{figure} ../_static/assets/screenshots/aurora-prism-interno.png
:alt: PRISM um nível abaixo, mostrando ULA e memórias do processador.
:width: 100%
:align: center

Dentro de um processador SAPHO: a ULA, as memórias e as pilhas têm desenho dedicado.
```

## O uso didático

O PRISM fecha o ciclo pedagógico da plataforma: cada construção do C± tem um custo em blocos, e aqui os blocos aparecem. O experimento do tutorial (trocar um deslocamento por uma divisão e ver o divisor surgir no diagrama) vale para qualquer recurso: chame `sqrt()` e observe o que muda, acrescente uma variável `float` e compare.

:::{tip}
**Em que nível olhar.** O divisor, o multiplicador e os demais blocos de operação moram dentro da ULA, e não no topo. Depois do {guilabel}`Recompile`, clique no processador para descer um nível, e então em {guilabel}`ula`: é ali que o bloco novo aparece, ao lado dos que já existiam. No nível do topo você só veria o mesmo retângulo de antes, porque as portas externas do processador não mudam quando a aritmética interna muda.
:::

## Simulação interativa

O botão {guilabel}`Simular` abre o modo interativo, que anima o circuito com estímulos clicáveis. Ele funciona bem para designs pequenos e médios; acima de alguns milhares de células, o PRISM recusa o modo interativo e sugere o diagrama estático, que não tem limite prático. A simulação séria continua sendo a dos capítulos anteriores; o modo interativo é uma lupa para entender trechos.

## Limitações

- O diagrama parte sempre do Top Level do projeto. Sem ele, o PRISM não abre.
- Módulos sem desenho dedicado aparecem como caixas genéricas, o que é cosmético, não funcional.
- O PRISM mostra estrutura, não tempo: quem mostra o comportamento ao longo dos ciclos é a forma de onda.
