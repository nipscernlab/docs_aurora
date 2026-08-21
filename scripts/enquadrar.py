# -*- coding: utf-8 -*-
"""Enquadra capturas de tela: corta a sobra e recorta o canto arredondado.

Uma captura de janela quase sempre traz uma faixa do que estava atras dela, e
a janela do Windows tem canto arredondado: recortada no retangulo, ela fica
com quatro quinas de fundo estranho grudadas, que no manual aparecem como
sujeira sobre o papel branco do PDF e sobre o tema claro do HTML.

O contorno nao e adivinhado por um raio. O que sai e o que a imagem mostra:
partindo das quatro bordas, tudo que for da cor do fundo e estiver ligado a
elas e marcado como lado de fora. Isso segue a curva real do canto, qualquer
que seja ela, e preserva areas vazias no meio da janela (um painel de arquivos
sem arquivos, por exemplo), porque essas nao encostam na borda.

O que fica de fora vira transparente; o resto e cortado no retangulo minimo.

Uso:
    python scripts/enquadrar.py --conferir         so relata
    python scripts/enquadrar.py --todas            aplica na pasta padrao
    python scripts/enquadrar.py a.png b.png        aplica nesses arquivos
"""
import argparse
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage

PASTA = Path(__file__).resolve().parent.parent / "source" / "_static" / "assets" / "screenshots"

# Quanto um pixel pode se afastar da cor do fundo e ainda contar como fundo.
# Baixo demais deixa uma franja da cor do fundo no contorno; alto demais come
# a borda escura da propria janela.
TOLERANCIA = 30

# Se o lado de fora ocupar mais que isto, a deteccao provavelmente vazou para
# dentro da janela por uma passagem da mesma cor, e a imagem fica como esta.
FRACAO_MAXIMA = 0.45


def ja_tratada(caminho):
    """Uma imagem com canto transparente ja passou por aqui.

    Sem esta guarda, rodar de novo achataria o alfa sobre preto e mediria
    tudo outra vez em cima do resultado anterior, encolhendo a figura a cada
    passagem. Assim o comando pode ser repetido a vontade.
    """
    im = Image.open(caminho)
    if im.mode != "RGBA":
        return False
    alfa = np.asarray(im)[:, :, 3]
    return bool((alfa == 0).any())


def analisa(caminho):
    im = Image.open(caminho).convert("RGB")
    a = np.asarray(im).astype(np.int16)
    h, w, _ = a.shape

    # O fundo e procurado borda a borda, e nao pelos quatro cantos juntos: um
    # cartao pode encostar no topo da captura e ter sobra so embaixo, e exigir
    # que os quatro cantos concordem descartaria justamente esses casos.
    bordas = {
        "topo": a[0, :, :],
        "base": a[h - 1, :, :],
        "esq": a[:, 0, :],
        "dir": a[:, w - 1, :],
    }

    fora = np.zeros((h, w), dtype=bool)
    usadas = []
    for nome, linha in bordas.items():
        cor = np.median(linha, axis=0)
        # A borda so vale como fundo se for quase toda de uma cor: uma borda
        # que corta conteudo nao diz nada sobre o que esta atras da janela.
        if (np.abs(linha - cor).max(axis=1) <= TOLERANCIA).mean() < 0.8:
            continue
        parecido = np.abs(a - cor).max(axis=2) <= TOLERANCIA
        rot, _ = ndimage.label(parecido)
        if nome == "topo":
            tocam = set(rot[0, :])
        elif nome == "base":
            tocam = set(rot[-1, :])
        elif nome == "esq":
            tocam = set(rot[:, 0])
        else:
            tocam = set(rot[:, -1])
        tocam.discard(0)
        if not tocam:
            continue
        candidato = np.isin(rot, list(tocam))
        # Uma unica borda nao pode reivindicar quase a imagem toda: quando
        # isso acontece, a varredura atravessou a moldura e entrou na janela.
        if candidato.mean() > FRACAO_MAXIMA:
            continue
        fora |= candidato
        usadas.append(nome)

    if not usadas:
        return im, a, None, "sem moldura reconhecivel"
    if fora.mean() > FRACAO_MAXIMA:
        return im, a, None, f"deteccao vazou ({fora.mean():.0%} viraria fora)"

    return im, a, fora, None


def canto_arredondado(a, alfa, x0, y0, dx, dy, lado):
    """Marca como fora a curva de um canto, olhando so dentro de uma caixa.

    A varredura global nao serve aqui: numa janela escura sobre uma area de
    trabalho escura ela atravessa a moldura e come a janela inteira. Presa a
    uma caixa do tamanho do canto, ela no maximo erra o canto, e o teste de
    area logo abaixo pega esse erro.
    """
    h, w, _ = a.shape
    caixa = a[y0:y0 + dy * lado:dy, x0:x0 + dx * lado:dx] if False else None
    ys = range(y0, y0 + lado) if dy > 0 else range(y0, y0 - lado, -1)
    xs = range(x0, x0 + lado) if dx > 0 else range(x0, x0 - lado, -1)
    ys = [y for y in ys if 0 <= y < h]
    xs = [x for x in xs if 0 <= x < w]
    if not ys or not xs:
        return 0

    sub = a[np.ix_(ys, xs)].astype(np.int16)
    cor = sub[0, 0]
    parecido = np.abs(sub - cor).max(axis=2) <= TOLERANCIA

    rot, _ = ndimage.label(parecido)
    if rot[0, 0] == 0:
        return 0
    fora = rot == rot[0, 0]

    # Quanto um canto pode ocupar nao e chute: a area entre o quadrado e o
    # arco de raio r vale r*r*(1 - pi/4), cerca de 21% da caixa mesmo quando
    # o raio e a caixa inteira. Acima disso a caixa tem area lisa, nao canto.
    if fora.mean() > 0.25:
        return 0

    for i, y in enumerate(ys):
        for j, x in enumerate(xs):
            if fora[i, j]:
                alfa[y, x] = 0
    return int(fora.sum())


def arredonda_cantos(a, alfa):
    """Corta os quatro cantos e devolve quantos pixels saíram.

    Quando so alguns cantos se revelam pela cor, o raio medido neles vale para
    todos: a area entre o quadrado e o arco e r*r*(1 - pi/4), entao o raio sai
    da contagem de pixels de um canto. E o caso comum de um cartao sobre um
    fundo quase da mesma cor, em que a curva existe mas nao tem contraste para
    ser vista de baixo, so de cima.
    """
    h, w, _ = a.shape
    lado = max(8, min(48, min(h, w) // 12))
    cantos = [
        canto_arredondado(a, alfa, 0, 0, 1, 1, lado),
        canto_arredondado(a, alfa, w - 1, 0, -1, 1, lado),
        canto_arredondado(a, alfa, 0, h - 1, 1, -1, lado),
        canto_arredondado(a, alfa, w - 1, h - 1, -1, -1, lado),
    ]
    achados = [c for c in cantos if c > 0]
    if not achados or len(achados) == 4:
        return sum(cantos)

    raio = int(round((sum(achados) / len(achados) / (1 - np.pi / 4)) ** 0.5))
    if raio < 2 or raio > min(h, w) // 4:
        return sum(cantos)

    mascara = Image.new("L", (w * 4, h * 4), 0)
    ImageDraw.Draw(mascara).rounded_rectangle((0, 0, w * 4 - 1, h * 4 - 1),
                                              radius=raio * 4, fill=255)
    uniforme = np.asarray(mascara.resize((w, h), Image.LANCZOS))
    alfa[:] = np.minimum(alfa, uniforme)
    return int((alfa == 0).sum())


def enquadra(caminho, aplicar):
    nome = caminho.name
    if ja_tratada(caminho):
        im = Image.open(caminho)
        return f"  {nome:34s} {im.width}x{im.height}  ja enquadrada"

    im, a, fora, motivo = analisa(caminho)

    if fora is None:
        # Sem moldura para cortar, ainda pode haver canto arredondado dentro
        # da propria captura: uma janela nao maximizada, por exemplo.
        alfa = np.full(a.shape[:2], 255, dtype=np.uint8)
        n = arredonda_cantos(a, alfa)
        if n == 0:
            return f"  {nome:34s} {im.width}x{im.height}  {motivo}, cantos retos"
        if aplicar:
            salva(im, a, alfa, caminho)
        return f"  {nome:34s} {im.width}x{im.height}  {motivo}, cantos {n}px"

    dentro = ~fora
    ys, xs = np.where(dentro)
    if not len(ys):
        return f"  {nome:34s} {im.width}x{im.height}  nada sobrou, nao mexi"
    topo, base, esq, dir_ = int(ys.min()), int(ys.max()) + 1, int(xs.min()), int(xs.max()) + 1

    corte = np.asarray(im)[topo:base, esq:dir_]
    resto = fora[topo:base, esq:dir_]

    # Depois do corte, o que sobra de fundo deveria ser so a curva dos quatro
    # cantos. Se for muito mais que isso, o fundo entra pelo conteudo (uma
    # onda do GTKWave sobre papel da mesma cor da moldura, por exemplo) e
    # apagar aquilo comeria a figura: nesse caso, corta e nao mexe no alfa.
    fino = resto.mean() <= 0.005
    alfa = np.where(resto, 0, 255).astype(np.uint8) if fino else np.full(corte.shape[:2], 255, np.uint8)
    cantos = arredonda_cantos(corte, alfa)

    sobra = (esq, topo, im.width - dir_, im.height - base)
    nota = "" if fino else f"  (fundo invade {resto.mean():.0%}, so cortei)"
    if aplicar:
        salva(im, corte, alfa, caminho)
    return (f"  {nome:34s} {im.width}x{im.height} -> {dir_ - esq}x{base - topo}"
            f"  sobra {sobra}  alfa {int((alfa == 0).sum())}px{nota}")


def salva(im, rgb, alfa, caminho):
    """Grava com o contorno suavizado: o alfa binario deixa a curva serrilhada,
    e meio pixel de desfoque nele limpa a curva sem tocar no conteudo."""
    suave = ndimage.gaussian_filter(alfa.astype(np.float32), sigma=0.6)
    saida = Image.fromarray(np.dstack([np.asarray(rgb, dtype=np.uint8),
                                       suave.astype(np.uint8)]), "RGBA")
    saida.save(caminho)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("arquivos", nargs="*", type=Path)
    ap.add_argument("--todas", action="store_true")
    ap.add_argument("--conferir", action="store_true")
    args = ap.parse_args()

    alvos = list(args.arquivos) or sorted(PASTA.glob("*.png"))
    aplicar = not args.conferir
    print(("aplicando em" if aplicar else "conferindo"), len(alvos), "arquivos")
    for a in alvos:
        try:
            print(enquadra(a, aplicar))
        except Exception as e:
            print(f"  {a.name:34s} ERRO: {e}", file=sys.stderr)


if __name__ == "__main__":
    main()
