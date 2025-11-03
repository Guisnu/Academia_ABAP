*&---------------------------------------------------------------------*
*& Include          ZTT0MACENG_TM_VD_TOP
*&---------------------------------------------------------------------*
*--------------------------------------------------------------------*
*Tipos Globais                                                       *
*--------------------------------------------------------------------*
TABLES: ztt0maceng_tm_vd.

TYPES:
  BEGIN OF ty_s_detalhada,
    nro        TYPE ztt0maceng_tm_vd-nro,
    item       TYPE ztt0maceng_tm_vd-item,
    matnr      TYPE ztt0maceng_tm_vd-matnr,
    maktx      TYPE ztt0maceng_tm_vd-maktx,
    data_venda TYPE ztt0maceng_tm_vd-data_venda,
    bukrs      TYPE ztt0maceng_tm_vd-bukrs,
    branch     TYPE ztt0maceng_tm_vd-branch,
    kunnr      TYPE ztt0maceng_tm_vd-kunnr,
    valor      TYPE ztt0maceng_tm_vd-valor,
    unv        TYPE ztt0maceng_tm_vd-unv,
    qtd        TYPE ztt0maceng_tm_vd-qtd,
  END OF ty_s_detalhada,

  BEGIN OF ty_s_filial,
    bukrs  TYPE ztt0maceng_tm_vd-bukrs,
    branch TYPE ztt0maceng_tm_vd-branch,
    valor  TYPE ztt0maceng_tm_vd-valor,
  END OF ty_s_filial,

  BEGIN OF ty_s_material,
    matnr TYPE ztt0maceng_tm_vd-matnr,
    maktx TYPE ztt0maceng_tm_vd-maktx,
    valor TYPE ztt0maceng_tm_vd-valor,
  END OF ty_s_material,

  BEGIN OF ty_s_cliente,
    kunnr TYPE ztt0maceng_tm_vd-kunnr,
    valor TYPE ztt0maceng_tm_vd-valor,
  END OF ty_s_cliente.

TYPES: ty_t_detalhada   TYPE STANDARD TABLE OF ty_s_detalhada    WITH NON-UNIQUE KEY nro item.
TYPES: ty_t_filial      TYPE STANDARD TABLE OF ty_s_filial       WITH NON-UNIQUE KEY bukrs branch.
TYPES: ty_t_material    TYPE STANDARD TABLE OF ty_s_material     WITH NON-UNIQUE KEY matnr maktx.
TYPES: ty_t_cliente     TYPE STANDARD TABLE OF ty_s_cliente      WITH NON-UNIQUE KEY kunnr.


*--------------------------------------------------------------------*
* Tabelas Globais                                                    *
*--------------------------------------------------------------------*
DATA: tg_fldcat     TYPE slis_t_fieldcat_alv,
      tg_detalhada  TYPE ty_t_detalhada,
      tg_filial     TYPE ty_t_filial,
      tg_material   TYPE ty_t_material,
      tg_cliente    TYPE ty_t_cliente.


*--------------------------------------------------------------------*
* Work Area                                                          *
*--------------------------------------------------------------------*

DATA: wg_cadastro   TYPE zasa0lss_tm_cad,
      wg_fldcat     TYPE slis_fieldcat_alv,
      wg_detalhada  TYPE ty_s_detalhada,
      wg_filial     TYPE ty_s_filial,
      wg_material   TYPE ty_s_material,
      wg_cliente    TYPE ty_s_cliente.


FIELD-SYMBOLS: <alv> TYPE STANDARD TABLE.