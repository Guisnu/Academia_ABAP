*&---------------------------------------------------------------------*
*& Report ZTT0MACENG_R_GIANNI
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0maceng_r_gianni.

TABLES: kna1.

TYPES: ty_t_kna1 TYPE STANDARD TABLE OF ztt0maceng_s_kna1_gianni WITH NON-UNIQUE KEY kunnr.

START-OF-SELECTION.

  DATA: tg_kna1 TYPE ty_t_kna1,
        wg_kna1 TYPE ztt0maceng_s_kna1_gianni.

  PERFORM zf_carrega_tabela.
  PERFORM zf_alv.



*&---------------------------------------------------------------------*
*& Form zf_carrega_tabela
*&---------------------------------------------------------------------*
FORM zf_carrega_tabela.
  SELECT kunnr land1 name1 ort01 stras adrnr
    FROM kna1 INTO TABLE tg_kna1.

  SORT tg_kna1 BY kunnr.

  READ TABLE tg_kna1 ASSIGNING FIELD-SYMBOL(<fs_kna1>) WITH KEY kunnr = '0000000023'
                                                                      BINARY SEARCH.
  IF sy-subrc EQ 0.
    <fs_kna1>-ort01 = 'Deu certo'.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_alv
*&---------------------------------------------------------------------*
FORM zf_alv.

  DATA: tl_fldcat TYPE slis_t_fieldcat_alv.
  DATA: wl_fldcat TYPE slis_fieldcat_alv.

  DATA: tl_sort   TYPE slis_t_sortinfo_alv.
  DATA: wl_sort   TYPE slis_sortinfo_alv.

  wl_sort-fieldname = 'ORT01'.
*  wl_sort-down      = 'X'.
*  wl_sort-subtot    = 'X'.
  APPEND wl_sort TO tl_sort.
  CLEAR  wl_sort.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name     = sy-repid
      i_structure_name   = 'ZTT0MACENG_S_KNA1_GIANNI'
      i_internal_tabname = 'TG_KNA1'
      i_inclname         = sy-repid
    CHANGING
      ct_fieldcat        = tl_fldcat.
  .

  READ TABLE tl_fldcat ASSIGNING FIELD-SYMBOL(<kunnr>) WITH KEY fieldname = 'KUNNR'.
  IF sy-subrc = 0.
    <kunnr>-hotspot = 'X'.
*    <kunnr>-no_convext = 'X'.
*    <KUNNR>-no_zero = 'X'.
  ENDIF.

  READ TABLE tl_fldcat ASSIGNING FIELD-SYMBOL(<adrnr>) WITH KEY fieldname = 'ADRNR'.
  IF sy-subrc = 0.
    <adrnr>-hotspot = 'X'.
*    <ADRNR>-no_convext = 'X'.
*    <adrnr>-no_zero = 'X'.
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = 'ZTT0MACENG_R_GIANNI'
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'ZHOTSPOT'
*     I_CALLBACK_TOP_OF_PAGE  = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
      i_grid_title            = 'Relatório de endereço'
*     I_GRID_SETTINGS         =
*     IS_LAYOUT               =
      it_fieldcat             = tl_fldcat
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
      it_sort                 = tl_sort
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
*     I_SAVE                  = ' '
*     IS_VARIANT              =
*     IT_EVENTS               =
*     IT_EVENT_EXIT           =
*     IS_PRINT                =
*     IS_REPREP_ID            =
*     I_SCREEN_START_COLUMN   = 0
*     I_SCREEN_START_LINE     = 0
*     I_SCREEN_END_COLUMN     = 0
*     I_SCREEN_END_LINE       = 0
*     I_HTML_HEIGHT_TOP       = 0
*     I_HTML_HEIGHT_END       = 0
*     IT_ALV_GRAPHICS         =
*     IT_HYPERLINK            =
*     IT_ADD_FIELDCAT         =
*     IT_EXCEPT_QINFO         =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*     O_PREVIOUS_SRAL_HANDLER =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    TABLES
      t_outtab                = tg_kna1.
*   EXCEPTIONS
*     PROGRAM_ERROR                     = 1
*     OTHERS                            = 2

ENDFORM.
FORM zhotspot USING ucomm LIKE sy-ucomm selfield TYPE kkblo_selfield.

  DATA: tl_ADRC TYPE TABLE OF adrc.
  DATA: tl_KNA1 TYPE TABLE OF adrc.

*  BREAK-POINT.

  CASE selfield-fieldname.

    WHEN 'ADRNR'.

      DATA: valor_adrnr TYPE adrnr.

      valor_adrnr = selfield-value.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = valor_adrnr
        IMPORTING
          output = valor_adrnr.

      READ TABLE tg_kna1 INTO DATA(wl_ADRNR) WITH KEY adrnr = valor_adrnr.

      IF sy-subrc = 0.
        SELECT *
          FROM adrc INTO CORRESPONDING FIELDS OF TABLE tl_adrc
          WHERE addrnumber = valor_adrnr.
      ENDIF.
    WHEN 'KUNNR'.

      DATA: valor_kunnr TYPE kunnr.

      valor_kunnr = selfield-value.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = valor_kunnr
        IMPORTING
          output = valor_kunnr.

      READ TABLE tg_kna1 INTO DATA(wl_KUNNR) WITH KEY kunnr = valor_kunnr.

      IF sy-subrc = 0.
        SELECT *
          FROM kna1 INTO CORRESPONDING FIELDS OF TABLE tg_kna1
          WHERE kunnr = valor_kunnr.
      ENDIF.

  ENDCASE.
selfield-refresh = 'X'.
ENDFORM.