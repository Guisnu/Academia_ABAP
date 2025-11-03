*&---------------------------------------------------------------------*
*& Report ZTT0MACENG_R_ARQUIVOS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0maceng_r_arquivos_v2.

INCLUDE ztt0maceng_tm_arquivos_v2_top.
INCLUDE ztt0maceng_tm_arquivos_v2_s01.
INCLUDE ztt0maceng_tm_arquivos_v2_f01.
INCLUDE ztt0maceng_tm_arq_v2_out01.
INCLUDE ztt0maceng_tm_arq_v2_inp01.

*--------------------------------------------------------------------*
* Eventos de Execução                                                *
*--------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM zf_processa_arquivo.
  PERFORM zf_select_makt_kna1.
  PERFORM zf_alv.
*  BREAK-POINT.