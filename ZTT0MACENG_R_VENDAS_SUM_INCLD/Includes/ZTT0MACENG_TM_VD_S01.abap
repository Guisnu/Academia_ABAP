*&---------------------------------------------------------------------*
*& Include          ZTT0MACENG_TM_VD_S01
*&---------------------------------------------------------------------*

TABLES: T001.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
  SELECT-OPTIONS: s_bukrs       FOR ztt0maceng_tm_vd-bukrs      NO INTERVALS.
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

DATA vg_bukrs TYPE bukrs.

AT SELECTION-SCREEN.
 SELECT SINGLE bukrs FROM t001
    INTO vg_bukrs
    WHERE bukrs IN s_bukrs.
 IF sy-subrc <> 0.
   MESSAGE: s006 WITH s_bukrs-low DISPLAY LIKE 'E'.
   STOP.
 ENDIF.