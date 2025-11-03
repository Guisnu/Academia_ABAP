*&---------------------------------------------------------------------*
*& Report ZTT0MACENG_R_RELATORIO_SD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0maceng_r_relatorio_sd.

TABLES: ztt0maceng_tm_vd.
*--------------------------------------------------------------------*
* Declarações globais.
*--------------------------------------------------------------------*
TYPES: BEGIN OF ty_s_alv_vd,
         nro        TYPE ztt0maceng_tm_vd-nro, "Número do pedido
         item       TYPE ztt0maceng_tm_vd-item, "Número do item
         matnr      TYPE ztt0maceng_tm_vd-matnr, "Material Number
         maktx      TYPE ztt0maceng_tm_vd-maktx, "Material Description
         data_venda TYPE ztt0maceng_tm_vd-data_venda, "Data da venda
         bukrs      TYPE ztt0maceng_tm_vd-bukrs, "Company Code
         branch     TYPE ztt0maceng_tm_vd-branch, "Business Place
         kunnr      TYPE ztt0maceng_tm_vd-kunnr, "Customer Number
         valor      TYPE ztt0maceng_tm_vd-valor, "Valor da venda
         unv        TYPE ztt0maceng_tm_vd-unv, "Unidade de venda
         qtd        TYPE ztt0maceng_tm_vd-qtd, "Quantidade
       END   OF ty_s_alv_vd.

TYPES: BEGIN OF ty_s_alv_bukrs,
         bukrs  TYPE ztt0maceng_tm_vd-bukrs, "Company Code
         branch TYPE ztt0maceng_tm_vd-branch, "Business Place
         valor  TYPE ztt0maceng_tm_vd-valor, "Valor da venda
       END OF ty_s_alv_bukrs.

TYPES: BEGIN OF ty_s_alv_matnr,
         matnr TYPE ztt0maceng_tm_vd-matnr, "Material Number
         maktx TYPE ztt0maceng_tm_vd-maktx, "Material Description
         valor TYPE ztt0maceng_tm_vd-valor, "Valor da venda
       END OF ty_s_alv_matnr.

TYPES: BEGIN OF ty_s_alv_kunnr,
         kunnr TYPE ztt0maceng_tm_vd-kunnr, "Customer Number
         valor TYPE ztt0maceng_tm_vd-valor, "Valor da venda
       END OF ty_s_alv_kunnr.

TYPES: ty_t_alv_vd    TYPE STANDARD TABLE OF ty_s_alv_vd    WITH NON-UNIQUE KEY nro item.
TYPES: ty_t_alv_bukrs TYPE STANDARD TABLE OF ty_s_alv_bukrs WITH NON-UNIQUE KEY bukrs branch.
TYPES: ty_t_alv_matnr TYPE STANDARD TABLE OF ty_s_alv_matnr WITH NON-UNIQUE KEY matnr maktx.
TYPES: ty_t_alv_kunnr TYPE STANDARD TABLE OF ty_s_alv_kunnr WITH NON-UNIQUE KEY kunnr.

DATA: tg_alv_vd    TYPE ty_t_alv_vd,
      tg_alv_bukrs TYPE ty_t_alv_bukrs,
      tg_alv_matnr TYPE ty_t_alv_matnr,
      tg_alv_kunnr TYPE ty_t_alv_kunnr.

*--------------------------------------------------------------------*
* Tela de seleção
*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
  PARAMETERS: p_arq TYPE string LOWER CASE OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-b02.
  SELECT-OPTIONS: s_bukrs  FOR ztt0maceng_tm_vd-bukrs NO-EXTENSION NO INTERVALS,
                  s_branch FOR ztt0maceng_tm_vd-branch      NO INTERVALS,
                  s_nro    FOR ztt0maceng_tm_vd-nro         NO INTERVALS,
                  s_dats   FOR ztt0maceng_tm_vd-data_venda,
                  s_kunnr  FOR ztt0maceng_tm_vd-kunnr       NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b02.

SELECTION-SCREEN BEGIN OF BLOCK b03 WITH FRAME TITLE TEXT-b03.
  PARAMETERS: p_detal RADIOBUTTON GROUP grp1,
              p_bukrs RADIOBUTTON GROUP grp1,
              p_matnr RADIOBUTTON GROUP grp1,
              p_kunnr RADIOBUTTON GROUP grp1.
SELECTION-SCREEN END OF BLOCK b03.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_arq.
  PERFORM zf_arq CHANGING p_arq.

*--------------------------------------------------------------------*
* Evento de Execução                                                 *
*--------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM zf_processar_arq.
  PERFORM zf_filtro_arq.

  CASE 'X'.
    WHEN p_detal.
      PERFORM zf_alv_detal.
    WHEN p_bukrs.
      PERFORM zf_alv_bukrs.
    WHEN p_matnr.
      PERFORM zf_alv_matnr.
    WHEN p_kunnr.
      PERFORM zf_alv_kunnr.
  ENDCASE.

*&---------------------------------------------------------------------*
*& Form zf_arq
*&---------------------------------------------------------------------*
FORM zf_arq CHANGING p_v_arq TYPE string.

  DATA tl_file_table TYPE filetable.
  DATA vl_rc TYPE i.

  cl_gui_frontend_services=>file_open_dialog(
    EXPORTING
*      window_title            =                  " Title Of File Open Dialog
*      default_extension       =
*      default_filename        =                  " Default File Name
      file_filter             = 'CSV files (*.csv)|*.csv'
*      with_encoding           =                  " File Encoding
*      initial_directory       =                  " Initial Directory
*      multiselection          =                  " Multiple selections poss.
    CHANGING
      file_table              = tl_file_table                 " Table Holding Selected Files
      rc                      = vl_rc                 " Return Code, Number of Files or -1 If Error Occurred
*      user_action             =                  " User Action (See Class Constants ACTION_OK, ACTION_CANCEL)
*      file_encoding           =
    EXCEPTIONS
      file_open_dialog_failed = 1                " "Open File" dialog failed
      cntl_error              = 2                " Control error
      error_no_gui            = 3                " No GUI available
      not_supported_by_gui    = 4                " GUI does not support this
      OTHERS                  = 5
  ).
  IF sy-subrc <> 0.
    MESSAGE 'Erro no upload do arquivo' TYPE 'I' DISPLAY LIKE 'E'.
    STOP.
  ELSE.
    READ TABLE tl_file_table INTO p_arq INDEX 1.
    FIND '.csv' IN p_arq.
    IF sy-subrc <> 0.
      MESSAGE 'Erro coloque um arquivo .csv' TYPE 'I' DISPLAY LIKE 'E'.
      STOP.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_processar_arq
*&---------------------------------------------------------------------*
FORM zf_processar_arq.
  DATA: tl_arquivo TYPE TABLE OF string,
        tl_split   TYPE TABLE OF string.

  DATA: wl_alv_vd TYPE ty_s_alv_vd.

  DATA: vl_linha     TYPE string,
        vl_split     TYPE string,
        vl_cv_nro    TYPE c LENGTH 10,
        vl_cv_kunnr  TYPE c LENGTH 10,
        vl_num_col   TYPE i,
        vl_num_tabix TYPE i,
        vl_len       TYPE i.

  FIND '.csv' IN p_arq.
  IF sy-subrc <> 0.
    MESSAGE 'Erro coloque um arquivo .csv' TYPE 'I' DISPLAY LIKE 'E'.
    STOP.
  ENDIF.

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

  IF sy-subrc <> 0.
    MESSAGE 'Erro no upload do arquivo.' TYPE 'I' DISPLAY LIKE 'E'.
    STOP.
  ENDIF.

  IF tl_arquivo IS INITIAL.
    MESSAGE 'Nenhum dado foi encontrado no arquivo.' TYPE 'I' DISPLAY LIKE 'E'.
    STOP.
  ENDIF.

*  vl_linha = tl_arquivo[ 1 ]. " Parando caso o numero de colunas do arquivo carregado seja diferente de 11
*  SPLIT vl_linha AT ';' INTO TABLE tl_split.
*
*  vl_num_col = lines( tl_split ).
*
*  IF vl_num_col <> 11.
*     MESSAGE 'Erro, modelo do arquivo diferente do esperado.' TYPE 'I' DISPLAY LIKE 'E'.
*     STOP.
*    ENDIF.

  LOOP AT tl_arquivo INTO vl_linha.
    vl_num_tabix = sy-tabix + 1.
    TRY.
        SPLIT vl_linha AT ';' INTO TABLE tl_split.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = tl_split[ 1 ]
          IMPORTING
            output = vl_cv_nro.

        wl_alv_vd-nro   = vl_cv_nro.
        wl_alv_vd-item  = tl_split[ 2 ].
        wl_alv_vd-matnr = tl_split[ 3 ].
        wl_alv_vd-maktx = tl_split[ 4 ].

        vl_split = tl_split[ 5 ].
        TRANSLATE vl_split USING '/ '.
        CONDENSE  vl_split NO-GAPS.
        wl_alv_vd-data_venda = |{ vl_split+4(4) }{ vl_split+2(2) }{ vl_split(2) }|.

        wl_alv_vd-bukrs  = tl_split[ 6 ].
        wl_alv_vd-branch = tl_split[ 7 ].

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = tl_split[ 8 ]
          IMPORTING
            output = vl_cv_kunnr.

        wl_alv_vd-kunnr  = vl_cv_kunnr.

        vl_split = tl_split[ 9 ].
        TRANSLATE vl_split USING '. '.
        TRANSLATE vl_split USING ',.'.
        CONDENSE  vl_split NO-GAPS.
        wl_alv_vd-valor = vl_split.

        wl_alv_vd-qtd =  tl_split[ 10 ].
        wl_alv_vd-unv =  tl_split[ 11 ].

        APPEND wl_alv_vd TO tg_alv_vd.

      CATCH cx_sy_range_out_of_bounds cx_sy_itab_line_not_found.
        MESSAGE 'Erro, modelo do arquivo diferente do esperado.' TYPE 'I' DISPLAY LIKE 'E'.
        STOP.
      CATCH cx_sy_conversion_no_number cx_root.
        MESSAGE | Verifique os dados da linha { vl_num_tabix } do arquivo ocorreu um erro.| TYPE 'I' DISPLAY LIKE 'E'.
        STOP.
    ENDTRY.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_filtro_arq
*&---------------------------------------------------------------------*
FORM zf_filtro_arq.
  DELETE tg_alv_vd
    WHERE bukrs       NOT IN s_bukrs
    OR    branch      NOT IN s_branch
    OR    nro         NOT IN s_nro
    OR    data_venda  NOT IN s_dats
    OR    kunnr       NOT IN s_kunnr.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_alv
*&---------------------------------------------------------------------*
FORM zf_alv_detal.
  DATA: tl_fldcat TYPE slis_t_fieldcat_alv,
        wl_fldcat TYPE slis_fieldcat_alv,
        wl_layout TYPE slis_layout_alv.

  wl_layout-zebra = 'X'.
  wl_layout-colwidth_optimize = 'X'.
  wl_layout-window_titlebar = 'Relatório Detalhado'.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname = 'NRO'.
  wl_fldcat-seltext_s = 'Nm.Ped'.
  wl_fldcat-seltext_m = 'Num Pedido'.
  wl_fldcat-seltext_l = 'Numero do Pedido'.
  wl_fldcat-key       = 'X'.
  wl_fldcat-no_zero   = 'X'.
  APPEND wl_fldcat TO tl_fldcat.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname = 'ITEM'.
  wl_fldcat-seltext_s = 'Item'.
  wl_fldcat-seltext_m = 'Item'.
  wl_fldcat-seltext_l = 'Item'.
  wl_fldcat-key       = 'X'.
  APPEND wl_fldcat TO tl_fldcat.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname = 'MATNR'.
  wl_fldcat-rollname  = 'MATNR'.
  APPEND wl_fldcat TO tl_fldcat.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname = 'MAKTX'.
  wl_fldcat-rollname  = 'MAKTX'.
  APPEND wl_fldcat TO tl_fldcat.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname = 'DATA_VENDA'.
  wl_fldcat-seltext_s = 'Dt.Vend'.
  wl_fldcat-seltext_m = 'Data de venda'.
  wl_fldcat-seltext_l = 'Data de venda'.
  APPEND wl_fldcat TO tl_fldcat.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname = 'BUKRS'.
  wl_fldcat-rollname  = 'BUKRS'.
  APPEND wl_fldcat TO tl_fldcat.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname = 'BRANCH'.
  wl_fldcat-rollname  = 'J_1BBRANC_'.
  APPEND wl_fldcat TO tl_fldcat.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname = 'KUNNR'.
  wl_fldcat-rollname  = 'KUNNR'.
  wl_fldcat-no_zero   = 'X'.
  APPEND wl_fldcat TO tl_fldcat.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname = 'VALOR'.
  wl_fldcat-seltext_s = 'Valor'.
  wl_fldcat-seltext_m = 'Valor'.
  wl_fldcat-seltext_l = 'Valor'.
  APPEND wl_fldcat TO tl_fldcat.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname = 'UNV'.
  wl_fldcat-seltext_s = 'Uni.vend'.
  wl_fldcat-seltext_m = 'Unid.vend'.
  wl_fldcat-seltext_l = 'Unidade de venda'.
  APPEND wl_fldcat TO tl_fldcat.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname = 'qtd'.
  wl_fldcat-seltext_s = 'Qtd'.
  wl_fldcat-seltext_m = 'Qtd'.
  wl_fldcat-seltext_l = 'Quantidade'.
  APPEND wl_fldcat TO tl_fldcat.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'ZF_PF_STATUS'
      i_callback_user_command  = 'ZF_USER_COMMAND'
      it_fieldcat              = tl_fldcat
      is_layout                = wl_layout
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER  =
*     ES_EXIT_CAUSED_BY_USER   =
    TABLES
      t_outtab                 = tg_alv_vd.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_alv_bukrs
*&---------------------------------------------------------------------*
FORM zf_alv_bukrs .
  DATA: tl_fldcat TYPE slis_t_fieldcat_alv,
        wl_fldcat TYPE slis_fieldcat_alv,
        wl_layout TYPE slis_layout_alv.

  PERFORM zf_collect.

  wl_layout-zebra = 'X'.
  wl_layout-colwidth_optimize = 'X'.
  wl_layout-window_titlebar = 'Relatório de Empresas'.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname     = 'BUKRS'.
  wl_fldcat-rollname      = 'BUKRS'.
  wl_fldcat-tabname       = 'TG_ALV_MATNR'.
  wl_fldcat-ref_tabname   = 'ZTT0MACENG_TM_VD'.
  APPEND wl_fldcat TO tl_fldcat.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname = 'BRANCH'.
  wl_fldcat-rollname  = 'J_1BBRANC_'.
  APPEND wl_fldcat TO tl_fldcat.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname = 'VALOR'.
  wl_fldcat-seltext_s = 'Vl.Vd'.
  wl_fldcat-seltext_m = 'Vl.vend'.
  wl_fldcat-seltext_l = 'Valor da venda'.
  wl_fldcat-do_sum    = 'X'.
  APPEND wl_fldcat TO tl_fldcat.

*  MOVE-CORRESPONDING tl_fldcat TO tl_fldcat.
*  tl_fldcat[] = tl_fldcat[].

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     i_callback_program       = sy-repid
*     i_callback_pf_status_set = 'ZF_PF_STATUS'
*     i_callback_user_command  = 'ZF_USER_COMMAND'
      it_fieldcat = tl_fldcat
      is_layout   = wl_layout
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER  =
*     ES_EXIT_CAUSED_BY_USER   =
    TABLES
      t_outtab    = tg_alv_bukrs.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_alv_matnr
*&---------------------------------------------------------------------*
FORM zf_alv_matnr .
  DATA: tl_fldcat TYPE slis_t_fieldcat_alv,
        wl_fldcat TYPE slis_fieldcat_alv,
        wl_layout TYPE slis_layout_alv.

  PERFORM zf_collect.

  wl_layout-zebra = 'X'.
  wl_layout-colwidth_optimize = 'X'.
  wl_layout-window_titlebar = 'Relatório de Materiais'.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname     = 'MATNR'.
  wl_fldcat-rollname      = 'MATNR'.
  wl_fldcat-tabname       = 'TG_ALV_MATNR'.
  wl_fldcat-ref_tabname   = 'ZTT0MACENG_TM_VD'.
  APPEND wl_fldcat TO tl_fldcat.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname = 'MAKTX'.
  wl_fldcat-rollname  = 'MAKTX'.
  APPEND wl_fldcat TO tl_fldcat.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname = 'VALOR'.
  wl_fldcat-seltext_s = 'Valor'.
  wl_fldcat-seltext_m = 'Valor'.
  wl_fldcat-seltext_l = 'Valor'.
  wl_fldcat-do_sum    = 'X'.
  APPEND wl_fldcat TO tl_fldcat.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     i_callback_program       = sy-repid
*     i_callback_pf_status_set = 'ZF_PF_STATUS'
*     i_callback_user_command  = 'ZF_USER_COMMAND'
      it_fieldcat = tl_fldcat
      is_layout   = wl_layout
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER  =
*     ES_EXIT_CAUSED_BY_USER   =
    TABLES
      t_outtab    = tg_alv_matnr.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_alv_kunnr
*&---------------------------------------------------------------------*
FORM zf_alv_kunnr.
  DATA: tl_fldcat TYPE slis_t_fieldcat_alv,
        wl_fldcat TYPE slis_fieldcat_alv,
        wl_layout TYPE slis_layout_alv.

  PERFORM zf_collect.

  wl_layout-zebra = 'X'.
  wl_layout-colwidth_optimize = 'X'.
  wl_layout-window_titlebar = 'Relatório de Clientes'.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname     = 'KUNNR'.
  wl_fldcat-rollname      = 'KUNNR'.
  wl_fldcat-tabname       = 'TG_ALV_MATNR'.
  wl_fldcat-ref_tabname   = 'ZTT0MACENG_TM_VD'.
  wl_fldcat-no_zero       = 'X'.
  APPEND wl_fldcat TO tl_fldcat.

  CLEAR wl_fldcat.
  wl_fldcat-fieldname = 'VALOR'.
  wl_fldcat-seltext_s = 'Valor'.
  wl_fldcat-seltext_m = 'Valor'.
  wl_fldcat-seltext_l = 'Valor'.
  wl_fldcat-do_sum    = 'X'.
  APPEND wl_fldcat TO tl_fldcat.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     i_callback_program       = sy-repid
*     i_callback_pf_status_set = 'ZF_PF_STATUS'
*     i_callback_user_command  = 'ZF_USER_COMMAND'
      it_fieldcat = tl_fldcat
      is_layout   = wl_layout
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER  =
*     ES_EXIT_CAUSED_BY_USER   =
    TABLES
      t_outtab    = tg_alv_kunnr.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form collect
*&---------------------------------------------------------------------*
FORM zf_collect.

  DATA: wl_alv_bukrs TYPE ty_s_alv_bukrs,
        wl_alv_matnr TYPE ty_s_alv_matnr,
        wl_alv_kunnr TYPE ty_s_alv_kunnr.

  CASE 'X'.
    WHEN p_bukrs.
      LOOP AT tg_alv_vd ASSIGNING FIELD-SYMBOL(<vd>).
        CLEAR wl_alv_bukrs.
        wl_alv_bukrs-bukrs  = <vd>-bukrs.
        wl_alv_bukrs-branch = <vd>-branch.
        wl_alv_bukrs-valor  = <vd>-valor.
        COLLECT wl_alv_bukrs INTO tg_alv_bukrs.
      ENDLOOP.
    WHEN p_matnr.
      LOOP AT tg_alv_vd ASSIGNING <vd>.
        CLEAR wl_alv_matnr.
        wl_alv_matnr-matnr = <vd>-matnr.
        wl_alv_matnr-maktx = <vd>-maktx.
        wl_alv_matnr-valor = <vd>-valor.
        COLLECT wl_alv_matnr INTO tg_alv_matnr.
      ENDLOOP.
    WHEN p_kunnr.
      LOOP AT tg_alv_vd ASSIGNING <vd>.
        CLEAR wl_alv_kunnr.
        wl_alv_kunnr-kunnr = <vd>-kunnr.
        wl_alv_kunnr-valor = <vd>-valor.
        COLLECT wl_alv_kunnr INTO tg_alv_kunnr.
      ENDLOOP.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ZF_PF_STATUS
*&---------------------------------------------------------------------*
FORM zf_pf_status USING rt_extab TYPE slis_t_extab.
  SET PF-STATUS 'PF_STATUS_SD'.
ENDFORM.
*--------------------------------------------------------------------*
* Form ZF_USER_COMMAND
*--------------------------------------------------------------------*
FORM zf_user_command USING ucomm TYPE sy-ucomm selfield TYPE kkblo_selfield.
  DATA: tl_vend   TYPE TABLE OF ztt0maceng_tm_vd,
        wl_vend   TYPE ztt0maceng_tm_vd,
        wl_alv_vd TYPE ty_s_alv_vd,
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
          LOOP AT tg_alv_vd INTO wl_alv_vd.
            wl_vend-nro        = wl_alv_vd-nro.
            wl_vend-item       = wl_alv_vd-item.
            wl_vend-matnr      = wl_alv_vd-matnr.
            wl_vend-maktx      = wl_alv_vd-maktx.
            wl_vend-data_venda = wl_alv_vd-maktx.
            wl_vend-kunnr      = wl_alv_vd-kunnr.
            wl_vend-valor      = wl_alv_vd-valor.
            wl_vend-unv        = wl_alv_vd-unv.
            wl_vend-qtd        = wl_alv_vd-qtd.
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

  ENDCASE.
ENDFORM.