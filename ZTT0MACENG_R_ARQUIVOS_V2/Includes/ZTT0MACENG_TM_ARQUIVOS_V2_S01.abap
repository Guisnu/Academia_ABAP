*&---------------------------------------------------------------------*
*& Include          ZTT0MACENG_TM_ARQUIVOS_SCR01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
  PARAMETERS: p_vari TYPE slis_vari.
  PARAMETERS: p_arq     TYPE string LOWER CASE OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b01.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_arq.
  PERFORM zf_f4_arq CHANGING p_arq.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_vari.
  PERFORM zf_f4_vari CHANGING p_vari.