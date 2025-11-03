REPORT ztt0maceng_r_vendas_sum NO STANDARD PAGE HEADING.

TABLES: ztt0maceng_tm_vd.

*--------------------------------------------------------------------*
*Interface de Blocos                                                 *
*--------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
  SELECT-OPTIONS: s_bukrs       FOR ztt0maceng_tm_vd-bukrs      NO INTERVALS NO-EXTENSION.
  SELECT-OPTIONS: s_branch      FOR ztt0maceng_tm_vd-branch     NO INTERVALS.
  SELECT-OPTIONS: s_nro         FOR ztt0maceng_tm_vd-nro        NO INTERVALS.
  SELECT-OPTIONS: s_dt_vd       FOR ztt0maceng_tm_vd-data_venda.
  SELECT-OPTIONS: s_kunnr       FOR ztt0maceng_tm_vd-kunnr      NO INTERVALS.
  SELECT-OPTIONS: s_matnr       FOR ztt0maceng_tm_vd-matnr      NO INTERVALS.
  SELECT-OPTIONS: s_maktx       FOR ztt0maceng_tm_vd-maktx      NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-b02.
  PARAMETERS: p_detal RADIOBUTTON GROUP grp1,
              p_flal  RADIOBUTTON GROUP grp1,
              p_mat   RADIOBUTTON GROUP grp1,
              p_clt   RADIOBUTTON GROUP grp1.
SELECTION-SCREEN END OF BLOCK b02.

*--------------------------------------------------------------------*
*Estruturas e categoria de tabelas                                   *
*--------------------------------------------------------------------*

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

DATA: wg_cadastro TYPE zasa0lss_tm_cad.

DATA: tg_fldcat TYPE slis_t_fieldcat_alv.
DATA: wg_fldcat TYPE slis_fieldcat_alv.

START-OF-SELECTION.

  DATA: tg_detalhada TYPE ty_t_detalhada.
  DATA: wg_detalhada TYPE ty_s_detalhada.

  DATA: tg_filial    TYPE ty_t_filial.
  DATA: wg_filial    TYPE ty_s_filial.

  DATA: tg_material  TYPE ty_t_material.
  DATA: wg_material  TYPE ty_s_material.

  DATA: tg_cliente   TYPE ty_t_cliente.
  DATA: wg_cliente   TYPE ty_s_cliente.

  FIELD-SYMBOLS: <alv> TYPE STANDARD TABLE.

  CASE 'X'.
    WHEN p_clt.
      SELECT kunnr SUM( valor ) AS valor
        FROM ztt0maceng_tm_vd INTO TABLE tg_cliente
        WHERE kunnr IN s_kunnr
          GROUP BY kunnr.

      ASSIGN tg_cliente TO <alv>.

      PERFORM zf_fldcat USING 'ZTT0MACENG_S_CLIENTE'.

    WHEN p_detal.
      SELECT nro item matnr maktx data_venda bukrs branch kunnr valor unv qtd
        FROM ztt0maceng_tm_vd INTO TABLE tg_detalhada
        WHERE bukrs       IN s_bukrs
        AND   branch      IN s_branch
        AND   nro         IN s_nro
        AND   data_venda  IN s_dt_vd
        AND   kunnr       IN s_kunnr.

      ASSIGN tg_detalhada TO <alv>.

      PERFORM zf_fldcat USING 'ZTT0MACENG_S_DETALHADA'.

    WHEN p_flal.
      SELECT bukrs branch SUM( valor ) AS valor
        FROM ztt0maceng_tm_vd INTO TABLE tg_filial
        WHERE bukrs       IN s_bukrs
        AND   branch      IN s_branch
        GROUP BY bukrs branch.

      ASSIGN tg_filial TO <alv>.

      PERFORM zf_fldcat USING 'ZTT0MACENG_S_FILIAL_SUM'.

    WHEN p_mat.
      SELECT matnr maktx SUM( valor ) AS valor
        FROM ztt0maceng_tm_vd INTO TABLE tg_material
        WHERE matnr IN s_matnr
        AND   maktx IN s_maktx
        GROUP BY matnr maktx.

        ASSIGN tg_material TO <alv>.

      PERFORM zf_fldcat USING 'ZTT0MACENG_S_MATERIAL'.

  ENDCASE.

  IF <alv> IS ASSIGNED.
    PERFORM zf_alv.
  ENDIF.

*&---------------------------------------------------------------------*
*& Form zf_alv
*&---------------------------------------------------------------------*
FORM zf_fldcat USING p_v_struct TYPE dd02l-tabname.
  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = p_v_struct
    CHANGING
      ct_fieldcat      = tg_fldcat.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_alv
*&---------------------------------------------------------------------*
FORM zf_alv.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      it_fieldcat = tg_fldcat
    TABLES
      t_outtab    = <alv>
    .
ENDFORM.