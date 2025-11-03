*&---------------------------------------------------------------------*
*& Report ZTT0MACENG_ESTRUTURAS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTT0MACENG_ESTRUTURAS.

DATA: vl_marca          TYPE c LENGTH 20,
      vl_modelo         TYPE c LENGTH 20,
      vl_cor            TYPE c LENGTH 20,
      vl_ano            TYPE d,
      vl_kilometragem   TYPE i,
      vl_moeda          TYPE c LENGTH 5,
      vl_valor          TYPE p LENGTH 5 DECIMALS 2.

vl_marca = 'Chevrolet'.
vl_modelo = 'Chevette'.
vl_cor = 'Preto'.
vl_ano = '20250910'.
vl_kilometragem = 200.
vl_moeda = 'BRL'.
vl_valor = 10000.

DATA: wl_carros TYPE ZTT0MACENG_TM_CR.

*wl_carros-marca = 'Ford'.
*wl_carros-modelo = 'KA'.
*wl_carros-cor = 'AZUL'.
*wl_carros-ano = '20040608'.
*wl_carros-kilometragem = 123.
*wl_carros-moeda = 'BRL'.
*wl_carros-valor = 10000.

wl_carros-marca = vl_marca.
wl_carros-modelo = vl_modelo.
wl_carros-cor = vl_cor.
wl_carros-ano = vl_ano.
wl_carros-kilometragem = vl_kilometragem.
wl_carros-moeda = vl_moeda.
wl_carros-valor = vl_valor.

*MODIFY ZTT0MACENG_TM_CR FROM wl_carros.

DATA: tl_carros TYPE ztt0maceng_ct_car.

BREAK-POINT.