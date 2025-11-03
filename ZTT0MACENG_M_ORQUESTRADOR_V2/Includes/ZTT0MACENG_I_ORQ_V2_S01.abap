*&---------------------------------------------------------------------*
*& Include          ZTT0MACENG_I_ORQ_V2_S01
*&---------------------------------------------------------------------*

TABLES: ztbsicorc_sp_par.

SELECTION-SCREEN BEGIN OF SCREEN 9200 AS SUBSCREEN.

  SELECT-OPTIONS: s_app  FOR ztbsicorc_sp_par-id_app,
                  s_type FOR ztbsicorc_sp_par-app_type.

SELECTION-SCREEN END OF SCREEN 9200.