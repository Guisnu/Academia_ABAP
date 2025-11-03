*&---------------------------------------------------------------------*
*& Include          ZTT0MACENG_TM_VD_S02
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
  SELECT-OPTIONS: s_parc  FOR but000-partner NO INTERVALS,
                  s_fornc FOR lfa1-lifnr     NO INTERVALS,
                  s_clt   FOR kna1-kunnr     NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-b02.
  PARAMETERS: p_parc  RADIOBUTTON GROUP grp1,
              p_fornc RADIOBUTTON GROUP grp1,
              p_clt   RADIOBUTTON GROUP grp1.
SELECTION-SCREEN END OF BLOCK b02.

*AT SELECTION-SCREEN.
*  DATA vl_valor TYPE c LENGTH 10.
*
*  SELECT SINGLE partner
*    FROM but000
*     INTO vl_valor
*     WHERE partner IN s_parc.
*
*  IF sy-subrc <> 0.
*    MESSAGE: s000 WITH 'Não a BP com os dados Fornecidos' DISPLAY LIKE 'E'.
*    STOP.
*  ENDIF.
*
*  SELECT SINGLE lifnr
*    FROM lfa1
*     INTO vl_valor
*     WHERE lifnr IN s_fornc.
*
*  IF sy-subrc <> 0.
*    MESSAGE: s000 WITH 'Não a BP com os dados Fornecidos' DISPLAY LIKE 'E'.
*    STOP.
*  ENDIF.
*
*  SELECT SINGLE kunnr
*    FROM kna1
*     INTO vl_valor
*     WHERE kunnr IN s_clt.
*
*  IF sy-subrc <> 0.
*    MESSAGE: s000 WITH 'Não a BP com os dados Fornecidos' DISPLAY LIKE 'E'.
*    STOP.
*  ENDIF.