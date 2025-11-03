*&---------------------------------------------------------------------*
*& Include          ZTT0MACENG_TM_ARQUIVOS_V2_F01
*&---------------------------------------------------------------------*

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
    READ TABLE tl_file_table INTO p_v_arq INDEX 1.
  ENDIF.

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

    WHEN 'EXPORT'.
      CALL SCREEN '0101' STARTING AT 10 10.
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
        vl_cv_kunnr TYPE c LENGTH 10,
        vl_meins    TYPE meins,
        vl_menge    TYPE menge_d.

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

  SELECT knumh, matnr
  FROM a118
  INTO TABLE @DATA(tl_a118).

  IF tl_a118[] IS NOT INITIAL.
    SELECT knumh, kbetr, kpein, kmein " KNUMH - Chave unica, KBETR - Valor da cond., KPEIN - Unidade da condição(%, BRL), KMEIN - Unidade de medida da minha condição
    FROM konp
    INTO TABLE @DATA(tl_konp)
    FOR ALL ENTRIES IN @tl_a118
      WHERE knumh EQ @tl_a118-knumh.

    SELECT matnr, meinh, umrez, umren
      FROM marm
      INTO TABLE @DATA(tl_marm)
      FOR ALL ENTRIES IN @tl_a118
        WHERE matnr EQ @tl_a118-matnr.
  ENDIF.

  SORT tl_a118 BY matnr.
  SORT tl_marm BY matnr meinh.
  SORT tl_konp BY knumh.

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

    READ TABLE tl_a118 INTO DATA(wl_a118) WITH KEY matnr = wl_alv-matnr
                                                   BINARY SEARCH.
    IF sy-subrc EQ 0.
      READ TABLE tl_konp  INTO DATA(wl_konp) WITH KEY knumh = wl_a118-knumh
                                                      BINARY SEARCH.
      IF sy-subrc EQ 0.

        CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
          EXPORTING
            input  = wl_alv-meins
          IMPORTING
            output = vl_meins
          EXCEPTIONS
            OTHERS = 1.

        READ TABLE tl_marm INTO DATA(wl_marm) WITH KEY matnr = wl_alv-matnr
                                                       meinh = vl_meins
                                                       BINARY SEARCH.
        IF sy-subrc EQ 0.
          IF wl_marm-umrez NE 1.
            vl_menge = wl_alv-menge * wl_marm-umrez.
          ELSE.
            vl_menge = wl_alv-menge.
          ENDIF.
        ENDIF.

        wl_alv-vlr_tot   = vl_menge * wl_konp-kbetr.
        wl_alv-vlr_unit  = wl_konp-kbetr.

      ENDIF.
    ENDIF.
    APPEND wl_alv TO tg_alv.

  ENDLOOP.

  PERFORM zf_select_makt_kna1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_f4_folder
*&---------------------------------------------------------------------*
FORM zf_f4_folder  CHANGING p_v_folder.
  cl_gui_frontend_services=>directory_browse(
  EXPORTING
    window_title = 'Selecione o arquivo caminho para salvar'
  CHANGING
    selected_folder = p_v_folder
   EXCEPTIONS
    OTHERS         = 1 ).
  IF p_v_folder IS NOT INITIAL.
    CONCATENATE p_v_folder '\' INTO p_v_folder.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_f4_folder_arq
*&---------------------------------------------------------------------*

FORM zf_f4_folder_serv  CHANGING p_v_folder.
  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
    EXPORTING
      directory  = '/usr/sap/trans/tmp/'
    IMPORTING
      serverfile = p_v_folder
    EXCEPTIONS
      OTHERS     = 1.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_exporta_servidor
*&---------------------------------------------------------------------*
FORM zf_exporta_servidor .
  DATA tl_csv TYPE STANDARD TABLE OF string.

  APPEND 'Sales Doc.;Item;Material;MaterialDescription;Target Qty;BUn;Valor Total;Vlr.Unit.;Customer;Name1' TO tl_csv.
  LOOP AT tg_alv ASSIGNING FIELD-SYMBOL(<alv>).
    DATA(vl_line) = |{ <alv>-vbeln };{ <alv>-posnr };{ <alv>-matnr };{ <alv>-maktx };{ <alv>-menge };{ <alv>-meins };{ <alv>-vlr_tot };{ <alv>-vlr_unit };{ <alv>-name1 }|.
    APPEND vl_line TO tl_csv.
  ENDLOOP.

  IF scr_0101-arquivo IS INITIAL.
    MESSAGE 'Adicione um caminho valido' TYPE 'S' DISPLAY LIKE 'E'.
    CLEAR scr_0101-arquivo.
    EXIT.
  ENDIF.

  IF scr_0101-arquivo CP ' '.
    MESSAGE 'Não é possivel inserir arquivos com espaço no nome' TYPE 'S' DISPLAY LIKE 'S'.
    EXIT.
  ENDIF.

  TRANSLATE scr_0101-arquivo TO LOWER CASE.

*  IF scr_0101-arquivo NS '/usr/sap/trans/tmp'.
*    MESSAGE 'O arquivo precisa estar dentro do diretório usr > sap > trans > tmp' TYPE 'S' DISPLAY LIKE 'E'.
*    CLEAR scr_0101-arquivo.
*    EXIT.
*  ENDIF.

  DATA(lv_filename) = |{ scr_0101-arquivo }MACENG_{ sy-datum }_{ sy-uzeit }.csv|.

  OPEN DATASET lv_filename FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.

  IF sy-subrc = 0.
    LOOP AT tl_csv ASSIGNING FIELD-SYMBOL(<data>).
      TRANSFER <data> TO lv_filename.
    ENDLOOP.
    CLOSE DATASET lv_filename.
    MESSAGE 'Sucesso ao criar arquivo no servidor' TYPE 'S'.
    LEAVE TO SCREEN 0.
*          ELSE.
*            MESSAGE 'O caminho não existe no server' TYPE 'S' DISPLAY LIKE 'E'.
*            EXIT.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_download
*&---------------------------------------------------------------------*
FORM zf_download .
  DATA tl_csv TYPE STANDARD TABLE OF string.

  APPEND 'Sales Doc.;Item;Material;MaterialDescription;Target Qty;BUn;Valor Total;Vlr.Unit.;Customer;Name1' TO tl_csv.
  LOOP AT tg_alv ASSIGNING FIELD-SYMBOL(<alv>).
    DATA(vl_line) = |{ <alv>-vbeln };{ <alv>-posnr };{ <alv>-matnr };{ <alv>-maktx };{ <alv>-menge };{ <alv>-meins };{ <alv>-vlr_tot };{ <alv>-vlr_unit };{ <alv>-name1 }|.
    APPEND vl_line TO tl_csv.
  ENDLOOP.

  IF scr_0101-arquivo IS INITIAL.
    MESSAGE 'Adicione um caminho valido' TYPE 'S' DISPLAY LIKE 'E'.
    CLEAR scr_0101-arquivo.
    EXIT.
  ENDIF.

  IF scr_0101-arquivo CP ' '.
    MESSAGE 'Não é possivel inserir arquivos com espaço no nome' TYPE 'S' DISPLAY LIKE 'E'.
    CLEAR scr_0101-arquivo.
    EXIT.
  ENDIF.

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename                = |{ scr_0101-arquivo }arquivo_teste.csv|
    TABLES
      data_tab                = tl_csv
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      OTHERS                  = 22.
  IF sy-subrc <> 0.
    MESSAGE 'Erro ao tentar realizar download' TYPE 'S' DISPLAY LIKE 'E'.
    CLEAR scr_0101-arquivo.
  ELSE.
    MESSAGE 'Sucesso' TYPE 'S'.
    LEAVE TO SCREEN 0.
  ENDIF.
ENDFORM.