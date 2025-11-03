*&---------------------------------------------------------------------*
*& Report ZTT0MACENG_R_LFA1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0maceng_r_lfa1 MESSAGE-ID ztt0maceng_cm_report LINE-SIZE 50 NO STANDARD PAGE HEADING.

TABLES: lfa1.

TOP-OF-PAGE.
  WRITE: / sy-uline,
           sy-vline,
           2(10) 'Cont.Fornec' COLOR COL_KEY,
           sy-vline,
           14(10) 'País',
           sy-vline,
           27(10) 'Nome',
           sy-vline,
           39(10) 'Cidade',
           sy-vline,
           sy-uline.

*--------------------------------------------------------------------*
*Interface de Blocos
*--------------------------------------------------------------------*

  SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
    SELECT-OPTIONS s_lifnr FOR lfa1-lifnr.
    SELECT-OPTIONS s_regio FOR lfa1-regio NO-EXTENSION NO INTERVALS.
  SELECTION-SCREEN END OF BLOCK b01.

START-OF-SELECTION.

*--------------------------------------------------------------------*
*Select para buscar campos da tabela.
*--------------------------------------------------------------------*
  DATA: wl_fornec TYPE lfa1. "Posso usar uma estrutura para criar wl"

  DATA: tl_fornec TYPE TABLE OF lfa1. "Posso usar uma categoria de tabelas para criar a tl"

  SELECT lifnr land1 name1 ort01
    FROM lfa1
    INTO CORRESPONDING FIELDS OF TABLE tl_fornec "Para procurar as tabelas correspondentes"
      WHERE lifnr IN s_lifnr
        AND regio IN s_regio.

*--------------------------------------------------------------------*
*LOOP para mostrar campos organizados
*--------------------------------------------------------------------*

  LOOP AT tl_fornec INTO wl_fornec.
    WRITE: / sy-vline,
           2(10) wl_fornec-lifnr COLOR COL_KEY,
           sy-vline,
           14(10) wl_fornec-land1,
           sy-vline,
           27(10) wl_fornec-name1,
           sy-vline,
           39(10) wl_fornec-ort01,
           sy-vline,
           sy-uline.
  ENDLOOP.