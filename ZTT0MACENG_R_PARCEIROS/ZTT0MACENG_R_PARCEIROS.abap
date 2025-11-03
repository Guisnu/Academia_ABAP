*&---------------------------------------------------------------------*
*& Report ZTT0MACENG_R_PARCEIROS
*&---------------------------------------------------------------------*

REPORT ztt0maceng_r_parceiros MESSAGE-ID ZTT0MACENG_CM_REPORT.

INCLUDE ztt0maceng_i_parceiros_top.
INCLUDE ztt0maceng_i_parceiros_s01.
INCLUDE ztt0maceng_i_parceiros_f01.

START-OF-SELECTION.

  PERFORM zf_carrega_tabelas.
  PERFORM zf_case_alv.