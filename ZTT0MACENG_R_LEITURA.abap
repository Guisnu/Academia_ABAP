*&---------------------------------------------------------------------*
*& Report ZTT0MACENG_R_LEITURA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0maceng_r_leitura.

TABLES: zasa0lss_tm_vend.

TYPES:
  BEGIN OF ty_s_vend,
    nro        TYPE zasa0lss_tm_vend-nro, "Número do Pedido de Venda
    item       TYPE zasa0lss_tm_vend-item, "Número do Item
    matnr      TYPE zasa0lss_tm_vend-matnr, "Material Number
    maktx      TYPE maktx,
    data_venda TYPE zasa0lss_tm_vend-data_venda, "Data da Venda
    bukrs      TYPE zasa0lss_tm_vend-bukrs, "Company Code
    butxt      TYPE butxt,
    branch     TYPE zasa0lss_tm_vend-branch, "Business Place
    name       TYPE j_1bbranch-name,
    kunnr      TYPE zasa0lss_tm_vend-kunnr, "Customer Number
    name1      TYPE kna1-name1,
    valor      TYPE zasa0lss_tm_vend-valor, "Valor da Venda
    unv        TYPE zasa0lss_tm_vend-unv, "Unidade de Venda
    qtd        TYPE zasa0lss_tm_vend-qtd, "Quantidade de Venda
  END OF ty_s_vend.

TYPES:
  BEGIN OF ty_s_makt,
    matnr TYPE matnr,
    maktx TYPE maktx,
  END OF ty_s_makt.

TYPES:
  BEGIN OF ty_s_kna1,
    kunrr TYPE kna1-kunnr,
    name1 TYPE kna1-name1,
  END OF ty_s_kna1.

TYPES:
  BEGIN OF ty_s_t001,
    bukrs TYPE t001-bukrs,
    butxt TYPE t001-butxt,
  END OF ty_s_t001.

TYPES:
  BEGIN OF ty_s_j_1bbranch,
    bukrs  TYPE j_1bbranch-bukrs,
    branch TYPE j_1bbranch-branch,
    name   TYPE j_1bbranch-name,
  END OF ty_s_j_1bbranch.

TYPES: ty_t_vend        TYPE SORTED TABLE OF ty_s_vend        WITH NON-UNIQUE KEY matnr.
TYPES: ty_t_makt        TYPE SORTED TABLE OF ty_s_makt        WITH UNIQUE KEY matnr.
TYPES: ty_t_kna1        TYPE SORTED TABLE OF ty_s_kna1        WITH UNIQUE KEY kunrr.
TYPES: ty_t_t001        TYPE SORTED TABLE OF ty_s_t001        WITH UNIQUE KEY bukrs.
TYPES: ty_t_j_1bbranch  TYPE SORTED TABLE OF ty_s_j_1bbranch  WITH UNIQUE KEY bukrs branch.

SELECT-OPTIONS: s_matnr   FOR zasa0lss_tm_vend-matnr,
                s_kunnr   FOR zasa0lss_tm_vend-kunnr,
                s_bukrs   FOR zasa0lss_tm_vend-bukrs,
                s_branch  FOR zasa0lss_tm_vend-branch.

START-OF-SELECTION.

  DATA: tl_vend       TYPE ty_t_vend,
        tl_makt       TYPE ty_t_makt,
        tl_kna1       TYPE ty_t_kna1,
        tl_t001       TYPE ty_t_t001,
        tl_j_1bbranch TYPE ty_t_j_1bbranch.

  DATA: wl_makt         TYPE ty_s_makt.
  DATA: wl_kna1         TYPE ty_s_kna1.
  DATA: wl_t001         TYPE ty_s_t001.
  DATA: wl_j_1bbranch   TYPE ty_s_j_1bbranch.

  FIELD-SYMBOLS: <vend> TYPE ty_s_vend.

* SELECT DE TABELA VENDAS SEM OS CAMPOS QUE SERÃO BUSCADOS
  SELECT nro item matnr data_venda bukrs branch kunnr valor unv qtd
      FROM zasa0lss_tm_vend
      INTO CORRESPONDING FIELDS OF TABLE tl_vend
        WHERE matnr   IN s_matnr
          AND kunnr   IN s_kunnr
          AND bukrs   IN s_bukrs
  AND branch  IN s_branch.

*--------------------------------------------------------------------*
*SELECT DAS TABELAS                                                  *
*--------------------------------------------------------------------*
  IF tl_vend[] IS NOT INITIAL.
* BUSCANDO TABELAS DE MATERIAIS
    SELECT matnr maktx
      FROM makt
      INTO TABLE tl_makt
      FOR ALL ENTRIES IN tl_vend
    WHERE matnr EQ tl_vend-matnr.

* BUSCANDO NOMES
    SELECT kunnr name1
      FROM kna1
      INTO TABLE tl_kna1
      FOR ALL ENTRIES IN tl_vend
    WHERE kunnr EQ tl_vend-kunnr.

* BUSCANDO EMPRESAS
    SELECT bukrs butxt
      FROM t001
      INTO TABLE tl_t001
      FOR ALL ENTRIES IN tl_vend
    WHERE bukrs EQ tl_vend-bukrs.

* BUSCANDO FILIAIS
    SELECT bukrs branch name
      FROM j_1bbranch
      INTO TABLE tl_j_1bbranch
      FOR ALL ENTRIES IN tl_vend
         WHERE bukrs  EQ tl_vend-bukrs
          AND   branch EQ tl_vend-branch.
  ENDIF.

    BREAK MACENG.

  LOOP AT tl_vend ASSIGNING <vend>.
    READ TABLE tl_makt INTO wl_makt WITH TABLE KEY matnr = <vend>-matnr.
    IF sy-subrc EQ 0.
      <vend>-maktx = wl_makt-maktx.
    ENDIF.
    READ TABLE tl_kna1 INTO wl_kna1 WITH TABLE KEY kunrr = <vend>-kunnr.
    IF sy-subrc EQ 0.
      <vend>-name1 = wl_kna1-name1.
    ENDIF.
    READ TABLE tl_t001 INTO wl_t001 WITH TABLE KEY bukrs = <vend>-bukrs.
    IF sy-subrc EQ 0.
      <vend>-butxt = wl_t001-butxt.
    ENDIF.
    READ TABLE tl_j_1bbranch INTO wl_j_1bbranch WITH TABLE KEY bukrs  = <vend>-bukrs
                                                               branch = <vend>-branch.
    IF sy-subrc EQ 0.
      <vend>-name = wl_j_1bbranch-name.
    ENDIF.
  ENDLOOP.

  BREAK MACENG.