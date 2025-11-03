*&---------------------------------------------------------------------*
*& Report ZTT0MACENG_R_ARQUIVOS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0maceng_r_arquivos.

*--------------------------------------------------------------------*
* Declaralção globais                                                *
*--------------------------------------------------------------------*
TYPES:
  BEGIN OF ty_s_alv,
    vbeln    TYPE vbeln_va, "ARQUIVO
    posnr    TYPE posnr_va, "ARQUIVO
    matnr    TYPE matnr, "ARQUIVO
    maktx    TYPE maktx, "TABELA TRANSPARENTE MAKT
    menge    TYPE dzmeng, "ARQUIVO
    meins    TYPE meins, "ARQUIVO
    vlr_tot  TYPE p LENGTH 8  DECIMALS 2, "TABELA TRANSPARENTE
    vlr_unit TYPE p LENGTH 8  DECIMALS 2, "TABELA TRANSPARENTE
    kunnr    TYPE kunnr, "ARQUIVO
    name1    TYPE name1_gp, "TABELA TRANSPARENTE KNA1
  END OF ty_s_alv.

TYPES:
  BEGIN OF ty_s_kna1,
    kunnr TYPE kna1-kunnr,
    name  TYPE kna1-name1,
  END OF ty_s_kna1.

TYPES:
  BEGIN OF ty_s_makt,
    matnr TYPE makt-matnr,
    maktx TYPE makt-maktx,
  END OF ty_s_makt.

TYPES: ty_t_alv  TYPE STANDARD TABLE OF ty_s_alv  WITH NON-UNIQUE KEY vbeln posnr.
TYPES: ty_t_kna1 TYPE SORTED TABLE OF ty_s_kna1 WITH NON-UNIQUE KEY kunnr.
TYPES: ty_t_makt TYPE SORTED TABLE OF ty_s_makt WITH NON-UNIQUE KEY matnr.

DATA: tg_alv TYPE ty_t_alv.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
  PARAMETERS: p_vari TYPE slis_vari.
  PARAMETERS: p_arq     TYPE string LOWER CASE OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b01.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_arq.
  PERFORM zf_f4_arq CHANGING p_arq.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_vari.
  PERFORM zf_f4_vari CHANGING p_vari.

*--------------------------------------------------------------------*
* Eventos de Execução                                                *
*--------------------------------------------------------------------*
START-OF-SELECTION.

  DATA: wg_variant TYPE disvariant.

  PERFORM zf_processa_arquivo.
  PERFORM zf_select_makt_kna1.
  PERFORM zf_alv.
*  BREAK-POINT.

*&---------------------------------------------------------------------*
*& Form zf_f4_arq
*&---------------------------------------------------------------------*
FORM zf_f4_arq CHANGING p_v_arq TYPE string.

  DATA tl_file_table TYPE filetable.
  DATA vl_rc TYPE i.

  cl_gui_frontend_services=>file_open_dialog(
*    EXPORTING
*      window_title            =                  " Title Of File Open Dialog
*      default_extension       =                  " Default Extension
*      default_filename        =                  " Default File Name
*      file_filter             =                  " File Extension Filter String
*      with_encoding           =                  " File Encoding
*      initial_directory       =                  " Initial Directory
*      multiselection          =                  " Multiple selections poss.
    CHANGING
      file_table              = tl_file_table                 " Table Holding Selected Files
      rc                      = vl_rc                 " Return Code, Number of Files or -1 If Error Occurred
*      user_action             =                  " User Action (See Class Constants ACTION_OK, ACTION_CANCEL)
*      file_encoding           =
*    EXCEPTIONS
*      file_open_dialog_failed = 1                " "Open File" dialog failed
*      cntl_error              = 2                " Control error
*      error_no_gui            = 3                " No GUI available
*      not_supported_by_gui    = 4                " GUI does not support this
*      others                  = 5
  ).
  IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ELSE.
    READ TABLE tl_file_table INTO p_arq INDEX 1.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_processa_arquivo
*&---------------------------------------------------------------------*
FORM zf_processa_arquivo.

  DATA: tl_arquivo TYPE TABLE OF string.
  DATA: tl_split   TYPE TABLE OF string.

  DATA wl_alv TYPE ty_s_alv.

  DATA: vl_linha    TYPE string,
        vl_split    TYPE string,
        vl_cv_matnr TYPE c LENGTH 18,
        vl_cv_kunnr TYPE c LENGTH 10.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = p_arq
    TABLES
      data_tab                = tl_arquivo
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.

  DELETE tl_arquivo INDEX 1.

  LOOP AT tl_arquivo INTO vl_linha.

    SPLIT vl_linha AT ';' INTO TABLE tl_split.

    wl_alv-vbeln = tl_split[ 1 ].
    wl_alv-posnr = tl_split[ 2 ].
*    vl_convert   = .

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = tl_split[ 3 ]
      IMPORTING
        output = vl_cv_matnr.

    wl_alv-matnr = vl_cv_matnr.

    vl_split = tl_split[ 4 ].
    TRANSLATE vl_split USING '. '.
    TRANSLATE vl_split USING ',.'.
    CONDENSE  vl_split NO-GAPS.

    wl_alv-menge = vl_split.
    wl_alv-meins = tl_split[ 5 ].

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = tl_split[ 6 ]
      IMPORTING
        output = vl_cv_kunnr.

    wl_alv-kunnr = vl_cv_kunnr.

    APPEND wl_alv TO tg_alv.

  ENDLOOP.

  PERFORM zf_select_makt_kna1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_select_makt_kna1
*&---------------------------------------------------------------------*
FORM zf_select_makt_kna1 .

  DATA: tl_t_kna1 TYPE ty_t_kna1.
  DATA: tl_t_makt TYPE ty_t_makt.

  SELECT kunnr name1
    FROM kna1
    INTO TABLE tl_t_kna1
    FOR ALL ENTRIES IN tg_alv
      WHERE kunnr EQ tg_alv-kunnr.

  SELECT matnr maktx
    FROM makt
    INTO TABLE tl_t_makt
    FOR ALL ENTRIES IN tg_alv
     WHERE matnr EQ tg_alv-matnr.

  LOOP AT tg_alv ASSIGNING FIELD-SYMBOL(<alv>).
    READ TABLE tl_t_kna1 ASSIGNING FIELD-SYMBOL(<kna1>) WITH TABLE KEY kunnr = <alv>-kunnr.
    IF sy-subrc = 0.
      <alv>-name1 = <kna1>-name.
    ENDIF.

    READ TABLE tl_t_makt ASSIGNING FIELD-SYMBOL(<makt>) WITH TABLE KEY matnr = <alv>-matnr.
    IF sy-subrc = 0.
      <alv>-maktx = <makt>-maktx.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_alv
*&---------------------------------------------------------------------*
FORM zf_alv .
  DATA: tl_fldcat TYPE slis_t_fieldcat_alv,
        wl_fldcat TYPE slis_fieldcat_alv,
        wl_layout TYPE slis_layout_alv.

  DATA: tl_sort TYPE slis_t_sortinfo_alv,
        wl_sort TYPE slis_sortinfo_alv.


*  wl_sort-tabname   = 'TG_ALV'.
*  wl_sort-fieldname = 'MATNR'.
*  wl_sort-up        = 'X'.
*  wl_sort-subtot    = 'X'.
**  wl_sort-group     = 'X'.
*  wl_sort-expa      = 'X'.
*  APPEND wl_sort TO tl_sort.

  wl_layout-zebra = 'X'.
  wl_layout-colwidth_optimize = 'X'.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname = 'VBELN'.
  wl_fldcat-rollname  = 'VBELN_VA'.
  wl_fldcat-key       = 'X'.
  APPEND wl_fldcat TO tl_fldcat.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname = 'POSNR'.
  wl_fldcat-rollname  = 'POSNR_VA'.
  wl_fldcat-key       = 'X'.
  APPEND wl_fldcat TO tl_fldcat.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname = 'MATNR'.
  wl_fldcat-rollname  = 'MATNR'.
  wl_fldcat-no_zero   = 'X'.
  wl_fldcat-hotspot   = 'X'.
  APPEND wl_fldcat TO tl_fldcat.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname = 'MAKTX'.
  wl_fldcat-rollname  = 'MAKTX'.
  APPEND wl_fldcat TO tl_fldcat.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname = 'MENGE'.
  wl_fldcat-rollname  = 'DZMENG'.
*  wl_fldcat-do_sum  = 'X'.
  APPEND wl_fldcat TO tl_fldcat.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname  = 'MEINS'.
  wl_fldcat-rollname = 'MEINS'.
  APPEND wl_fldcat TO tl_fldcat.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname = 'VLR_TOT'.
  wl_fldcat-seltext_s = 'Vl.Tot'.
  wl_fldcat-seltext_m = 'Valor Tot'.
  wl_fldcat-seltext_l = 'Valor Total'.
  APPEND wl_fldcat TO tl_fldcat.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname = 'VLR_UNIT'.
  wl_fldcat-seltext_s = 'Vlr. Unit'.
  wl_fldcat-seltext_m = 'Vlr Unit'.
  wl_fldcat-seltext_l = 'Valor Unitario'.
  APPEND wl_fldcat TO tl_fldcat.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname = 'KUNNR'.
  wl_fldcat-rollname  = 'KUNNR'.
  wl_fldcat-no_zero   = 'X'.
  wl_fldcat-hotspot   = 'X'.
  APPEND wl_fldcat TO tl_fldcat.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname   = 'NAME1'.
  wl_fldcat-rollname  = 'NAME1_GP'.
  APPEND wl_fldcat TO tl_fldcat.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'ZF_PF_STATUS'
      i_callback_user_command  = 'ZF_USER_COMMAND'
      it_fieldcat              = tl_fldcat
      is_layout                = wl_layout
      is_variant               = wg_variant
      i_save                   = 'A'
*     it_sort                  = tl_sort
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER  =
*     ES_EXIT_CAUSED_BY_USER   =
    TABLES
      t_outtab                 = tg_alv.

ENDFORM.
*&---------------------------------------------------------------------*
*& SET PF STATUS
*&---------------------------------------------------------------------*
FORM zf_pf_status USING extab TYPE slis_t_extab.
  SET PF-STATUS 'PF_STATUS_ARQUIVO'.
ENDFORM.

FORM zf_user_command USING ucomm TYPE sy-ucomm selfield TYPE slis_selfield.

  DATA: tl_vend   TYPE TABLE OF ztt0maceng_tm_vd,
        wl_vend   TYPE ztt0maceng_tm_vd,
        wl_alv    TYPE ty_s_alv,
        msg       TYPE string,
        vl_answer TYPE c.

  CASE ucomm.
    WHEN 'SAVE'.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          text_question         = 'Deseja gravar todos os dados?'
          text_button_1         = 'Sim'
          text_button_2         = 'Não'
          display_cancel_button = ''
        IMPORTING
          answer                = vl_answer.

      CASE vl_answer.
        WHEN 1.
          LOOP AT tg_alv INTO wl_alv.
            wl_vend-nro = wl_alv-vbeln.
            wl_vend-item = wl_alv-posnr+3(3).
            wl_vend-matnr = wl_alv-matnr.
            wl_vend-maktx = wl_alv-maktx.
            wl_vend-kunnr = wl_alv-kunnr.
            wl_vend-unv = wl_alv-meins.
            wl_vend-qtd = wl_alv-menge.

            APPEND wl_vend TO tl_vend.
*        INSERT ztt0maceng_tm_vd FROM wl_vend.
          ENDLOOP.

          IF tl_vend[] IS NOT INITIAL.
            TRY.
                INSERT ztt0maceng_tm_vd FROM TABLE tl_vend.
                IF sy-subrc = 0.
                  COMMIT WORK.
                  msg = |{ sy-dbcnt }  foram inseridas |.
                  MESSAGE msg TYPE 'S'.
                ENDIF.
              CATCH cx_sy_open_sql_db.
                MESSAGE 'Erro, Linhas duplicadas.' TYPE 'I' DISPLAY LIKE 'E'.
            ENDTRY.
          ENDIF.
        WHEN 2.
          MESSAGE 'Gravação Cancelada.' TYPE 'S' DISPLAY LIKE 'W'.
      ENDCASE.

    WHEN '&IC1'.
      CASE selfield-fieldname.
        WHEN 'matnr'.
          SET PARAMETER ID 'MAT'  FIELD selfield-value.
          SET PARAMETER ID 'MXX'  FIELD 'K'.
          CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
        WHEN 'kunnr'.
          SET PARAMETER ID 'KUN'  FIELD selfield-value.
          CALL TRANSACTION 'XD03' AND SKIP FIRST SCREEN.
      ENDCASE.


  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_f4_vari
*&---------------------------------------------------------------------*
FORM zf_f4_vari  CHANGING p_vari.

  wg_variant-report   = sy-repid.
  wg_variant-username = sy-uname.
  wg_variant-variant  = p_vari.

  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant    = wg_variant
      i_save        = 'A'
    IMPORTING
      es_variant    = wg_variant
    EXCEPTIONS
      not_found     = 1
      program_error = 2
      OTHERS        = 3.
  IF sy-subrc <> 0.
    MESSAGE 'Erro ao buscar variant.' TYPE 'I' DISPLAY LIKE 'E'.
  ELSE.
    p_vari = wg_variant-variant.
  ENDIF.
ENDFORM.