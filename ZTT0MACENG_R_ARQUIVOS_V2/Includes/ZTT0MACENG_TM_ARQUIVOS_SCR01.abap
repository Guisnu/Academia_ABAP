*&---------------------------------------------------------------------*
*& Include          ZTT0MACENG_TM_ARQUIVOS_TOP
*&---------------------------------------------------------------------*
*--------------------------------------------------------------------*
* Declaralção globais                                                *
*--------------------------------------------------------------------*
TYPES:
  BEGIN OF ty_s_alv,
    vbeln    TYPE vbeln_va, "ARQUIVO
    posnr    TYPE posnr_va, "ARQUIVO
    matnr    TYPE matnr, "ARQUIVO
    maktx    TYPE maktx, "TABELA TRANSPARENTE MAKT
    menge    TYPE vbap-zmeng, "ARQUIVO
    meins    TYPE meins, "ARQUIVO
    vlr_tot  TYPE p LENGTH 8  DECIMALS 2, "TABELA TRANSPARENTE
    vlr_unit TYPE p LENGTH 8  DECIMALS 2, "TABELA TRANSPARENTE
    kunnr    TYPE kunnr, "ARQUIVO
    name1    TYPE name1_gp, "TABELA TRANSPARENTE KNA1
  END OF ty_s_alv.

TYPES:
  BEGIN OF ty_s_kna1,
    kunnr TYPE kna1-kunnr,
    name  TYPE kna1-name1,
  END OF ty_s_kna1.

TYPES:
  BEGIN OF ty_s_makt,
    matnr TYPE makt-matnr,
    maktx TYPE makt-maktx,
  END OF ty_s_makt.

TYPES:
  BEGIN OF ty_scr_0101,
    arquivo  TYPE string,
    servidor TYPE c LENGTH 1,
    usuario  TYPE c LENGTH 1,
  END OF ty_scr_0101.

TYPES: ty_t_alv  TYPE STANDARD TABLE OF ty_s_alv  WITH NON-UNIQUE KEY vbeln posnr.
TYPES: ty_t_kna1 TYPE SORTED TABLE OF ty_s_kna1 WITH NON-UNIQUE KEY kunnr.
TYPES: ty_t_makt TYPE SORTED TABLE OF ty_s_makt WITH NON-UNIQUE KEY matnr.

DATA: tg_alv     TYPE ty_t_alv,
      vg_ok_code TYPE sy-ucomm.

DATA: scr_0101 TYPE ty_scr_0101.
DATA: wg_variant TYPE disvariant.